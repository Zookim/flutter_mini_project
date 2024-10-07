import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vid_player/component/custom_video_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  XFile? video; //동영상을 저장할 변수
  //image_picker 플러그인은 이미지나 동영상을 선택했을때 이를 XFile이라는 클래스 형태로 보여준다.
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.black,
      body: video == null
          ? renderEmpty()
          : renderVideo(), //동영상이 선택되지 않은 경우와 선택된경우
    );
  }

  Widget renderEmpty() {
    return Container(
      decoration: getBoxDecoration(),
      width:
          MediaQuery.of(context).size.width, //즉 main에 있는 MaterialApp의 너비를 가져온다.
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _Logo(logoTap: onNewVideoPressed),
          SizedBox(height: 30),
          _AppName(),
        ],
      ),
    );
  }

  void onNewVideoPressed() async {
    print('!!------onNewVideoPressed\n');
    //로고를 탭하면
    //갤러리에서 동영상을 선택하는 창이 뜬다.
    //ImageSource.camera는 새로운 영상을 찍고 이를 선택한다.
    final video = await ImagePicker().pickVideo(source: ImageSource.gallery);
    print('!!-------new video\n');
    if (video != null) {
      setState(() {
        this.video = video;
      });
    }
  }

  BoxDecoration getBoxDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
          //그라데이션 색상 적용
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF2A3A7C),
            Color(0xFF000118),
          ]),
    );
  }

  Widget renderVideo() {
    print('!!!--------render--------!!!');
    return Center(
      child: CustomVideoPlayer(
          video: video!, onNewVideoPressed: onNewVideoPressed),
    );
  }
}

class _Logo extends StatelessWidget {
  final GestureTapCallback logoTap;

  const _Logo({required this.logoTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: logoTap,
      child: Image.asset('asset/img/logo.png'),
    );
  }
}

class _AppName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: 30,
      fontWeight: FontWeight.w300,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'VIDEO',
          style: textStyle,
        ),
        Text('PLAYER', style: textStyle.copyWith(fontWeight: FontWeight.w700)),
      ],
    );
  }
}
