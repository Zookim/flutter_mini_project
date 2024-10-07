import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vid_player/component/custom_icon_button.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  final XFile video;
  final GestureTapCallback onNewVideoPressed; //다른 비디오 선택 버튼 기능

  const CustomVideoPlayer(
      {required this.video, required this.onNewVideoPressed, Key? key})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  VideoPlayerController? videoController; //비디오 조작 컨트롤러
  bool showControlsIcon = false; //아이콘 보이기 여부

  @override
  void initState() {
    // 이순간은 비디오가 선택되는 순간이다.
    print('video_player initState-----------');
    super.initState();
    initializeController();
  }

  initializeController() async {
    //파일로부터 videoPlayerController를 만든다.
    //VideoPlayerController.asset 에셋 파일의 경로로 부터 동영상을 불러온다.
    //VideoPlayerController.networkUrl //URL로 부터 동영상을 불러온다.
    videoController = VideoPlayerController.file(File(widget.video.path));
    //this가 widget
    //videoController!.removeListener(videoControllerListener);
    await videoController!.initialize(); //동영상을 재생할수 있도록 준비한다.
    videoController!.addListener(videoControllerListener);
    //예를들어 영상 앞뒤로 가기등의 조작시 slider가 렌더링되어야한다.
    setState(() {
      this.videoController = videoController;
    });
  }

  void videoControllerListener() {
    setState(() {
      this.videoController = videoController; //??
    });
  }

  initmy() async {
    videoController!.removeListener(videoControllerListener);
    videoController!.dispose();
    videoController = VideoPlayerController.file(File(widget.video.path));

    await videoController!.initialize();
    videoController!.addListener(videoControllerListener);
    setState(() {
      this.videoController = videoController;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    videoController?.removeListener(videoControllerListener);
    super.dispose();
    print('-----------dispose ');
  }

  @override
  void didUpdateWidget(covariant CustomVideoPlayer oldWidget) {
    print('----------------update');
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (oldWidget.video.path != widget.video.path) {
      //initializeController(); //영상을 가져오고 다시 틀기 위한 과정을 반복해야 다른 영상으로 교체된다.
      initmy();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (videoController == null) {
      // 아직 null인 상태 일때, 아마 setState가 실행되기 전인듯
      return Center(
          child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.white),
      ));
    }

    return GestureDetector(
      //화면전체의 탭을 인식하기 위해서
      onTap: () {
        setState(() {
          //리렌더링
          showControlsIcon = !showControlsIcon;
        });
      },
      child: AspectRatio(
        // 동영상 비율에 따른 화면 렌더링
        aspectRatio: videoController!.value.aspectRatio, //선택된 동영상의 비율을 가져온다.
        child: Stack(
          //자식들이 그냥 쌓인다.
          children: [
            VideoPlayer(videoController!), //widget.video가 아닌 videoController

            if (showControlsIcon) //아이콘이 보일때 화면을 어둡게 만든다.(왜 여기?)
              Container(color: Colors.black.withOpacity(0.5)),
            Positioned(
              //각각에서의 거리
              bottom: 0, //바닥과의 거리 0
              left: 0, //이걸로 너비를 꽉채우게 설정할수 있다.
              right: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    renderTimeTextFromDuration(videoController!.value.position),
                    Expanded(
                      child: Slider(
                        onChanged: (double val) {
                          //슬라이더의 위치가 이동할 때 이동한 위치로 동영상을 움직인다.seekTo로 가능
                          videoController!
                              .seekTo(Duration(seconds: val.toInt()));
                        },
                        min: 0,
                        //max는 double
                        max: videoController!.value.duration.inSeconds
                            .toDouble(),
                        //position은 현재 위치
                        value: videoController!.value.position.inSeconds
                            .toDouble(),
                        //setState()없이는 렌더링되지 않는다. 리스너 사용
                      ),
                    ),
                    renderTimeTextFromDuration(videoController!.value.duration),
                  ],
                ),
              ),
            ),
            if (showControlsIcon) //아이콘이 보일때만 아래를 보여준다.
              Align(
                //다른 동영상 버튼
                alignment: Alignment.topRight,
                child: CustomIconButton(
                  onPressed:
                      widget.onNewVideoPressed, //this가 아닌 widget의 것을 가져오므로
                  iconData: Icons.photo_camera_back,
                ),
              ),
            if (showControlsIcon) //아이콘이 보일때만 아래를 보여준다.
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomIconButton(
                        onPressed: onReversePressed,
                        iconData: Icons.rotate_left),
                    CustomIconButton(
                        onPressed: onPlayPressed,
                        iconData: videoController!.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow),
                    CustomIconButton(
                        onPressed: onForwardPressed,
                        iconData: Icons.rotate_right)
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget renderTimeTextFromDuration(Duration duration) {
    return Text(
      '${duration.inMinutes.toString().padLeft(2, '0')} : ${duration.inSeconds.toString().padLeft(2, '0')}',
      style: TextStyle(color: Colors.white),
    );
  }

  void onReversePressed() {
    final currentPosition = videoController!.value.position;

    Duration position = Duration();
    if (currentPosition.inSeconds > 3) {
      position = currentPosition - Duration(seconds: 3);
    }
    videoController!.seekTo(position);
  }

  void onForwardPressed() {
    final currentPosition = videoController!.value.position;
    Duration position = videoController!.value.duration;
    if (currentPosition.inSeconds + 3 < position.inSeconds) {
      position = currentPosition + Duration(seconds: 3);
    }
    videoController!.seekTo(position);
  }

  void onPlayPressed() {
    if (videoController!.value.isPlaying) {
      videoController!.pause();
    } else {
      videoController!.play();
    }
  }
}
