import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_call/const/agora.dart';

class CamScreen extends StatefulWidget {
  CamScreen({Key? key}) : super(key: key);

  @override
  _CamScreenState createState() => _CamScreenState(); //반환값이 state이다.
}

class _CamScreenState extends State<CamScreen> {
  RtcEngine? engine; //아고라 엔진을 저장
  int? uid; //나의 uid, 채널에 입장후 생성되는 값
  int? otherUid; //상대

  Future<bool> init() async {
    /*권한 확인*/
    final resp = await [Permission.camera, Permission.microphone].request();
    final cameraPermission = resp[Permission.camera];
    final microphonePermission = resp[Permission.microphone];

    if (cameraPermission != PermissionStatus.granted ||
        microphonePermission != PermissionStatus.granted) {
      throw '카메라 또는 마이크 권한이 없습니다.';
    }
    /*엔진 사용*/
    if (engine == null) {
      print('!! -------- initialize engine ----- !!');
      engine = createAgoraRtcEngine(); //엔진 정의
      await engine!.initialize(
        // 엔진 초기화
        RtcEngineContext(
            //아고라 안에서 받을 수 있는 이벤트 값들을 등록
            appId: APP_ID,
            channelProfile: ChannelProfileType.channelProfileLiveBroadcasting),
      );
      //이벤트 콜백함수를 등록한다.
      engine!.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection con, int elapsed) {
            //내가 채널에 입장 elapsed joinChannel 실행후 콜백되기까지 걸린시간
            print('!!-----채널에 입장했습니다. uid: ${con.localUid}');
            setState(() {
              this.uid = con.localUid;
            });
          },
          onConnectionStateChanged: (RtcConnection con,
              ConnectionStateType contype,
              ConnectionChangedReasonType conChtype) {
            print('!!--------------connection is changed-------------!!');
            print(conChtype.name);
            // setState(() {
            //   this.uid = con.localUid;
            // });
          },
          onLeaveChannel: (RtcConnection con, RtcStats stats) {
            //내가 퇴장
            print('채널퇴장');
            setState(() {
              uid = null;
            });
          },
          onUserJoined: (RtcConnection con, int remoteUid, int elapsed) {
            //상대 입장 elapsed 나의 입장후 상대 입장까지 시간
            print('상대가 채널에 입장했습니다. uid : ${remoteUid}');
            setState(() {
              this.otherUid = remoteUid;
            });
          },
          onUserOffline:
              (RtcConnection con, int remoteUid, UserOfflineReasonType reason) {
            //상대 퇴장
            print('상대가 채널에서 나갔습니다.'); //reason 퇴장이유
            setState(() {
              otherUid = null;
            });
          },
        ),
      );

      //엔진으로 영상 송출을 설정
      if (engine == null) {
        print('!! ----------------- engine is null------------!!');
      }
      await engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
      await engine!.enableVideo(); //동영상기능을 활성화
      await engine!.startPreview(); //카메라로 동영상화면을 실행

      //채널에 입장
      await engine!.joinChannel(
          token: TEMP_TOKEN,
          channelId: CHANNEL_NAME,
          uid: 0, //나의 고유 uid,0이면 자동으로 생성된다.
          options: ChannelMediaOptions());
    }
    print('!! ----------- init end ---------- !!');

    return true;
  }

  @override
  void dispose() {
    print('!!-----dispose------!!');
    // TODO: implement dispose
    super.dispose();
    _dispose();
  }

  Future<void> _dispose() async {
    //채널에 입장과 퇴장을 반복할때 앱이 멈추는 것을 수정
    await engine!.leaveChannel();
    await engine!.release();
  }

  @override
  Widget build(BuildContext context) {
    //AsyncSnapshot의 결과 값이 변할때마다 builder가 재실행된다.
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('Live')),
      body: FutureBuilder(
        // 권한 허용여부에 따라 보여줄 화면이 다르지만 init()의 결과가 언제 올지 모르므로 FutureBuilder()가 필요
        //상태에따라 다른 위젯을 보여준다.

        future: init(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          //init결과에 따른 결과 화면들
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  child: Stack(
                children: [
                  renderMainVIew(),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                          color: Colors.grey,
                          height: 160,
                          width: 120,
                          child: renderSubView()))
                ],
              )),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (engine != null) {
                        await engine!.leaveChannel();
                      }
                      Navigator.of(context).pop();
                    },
                    child: Text('나가기'),
                  ))
            ],
          );
        },
      ),
    );
  }

  /*이제 엔진에서 송수신하는 정보를 화면에 꾸며준다.*/

  // 내핸드폰이 찍는 화면
  Widget renderSubView() {
    // print('!! ----- my camera rendering ----- !!');
    if (uid != null) {
      print('!! ----- my camera rendering ----- !!');
      //내영상을 보여준다.
      return AgoraVideoView(
          controller: VideoViewController(
              rtcEngine: engine!, canvas: const VideoCanvas(uid: 0)));
    } else {
      //내가 접속 전일때
      return CircularProgressIndicator();
    }
  }

  //상대방이 찍는 화면
  Widget renderMainVIew() {
    if (otherUid != null) {
      return AgoraVideoView(
          controller: VideoViewController.remote(
              rtcEngine: engine!,
              canvas: VideoCanvas(uid: otherUid),
              connection: const RtcConnection(channelId: CHANNEL_NAME)));
    } else {
      return Center(
          child: const Text('다른 사용자가 입장할때까지 대기해 주세요',
              textAlign: TextAlign.center));
    }
  }
}
