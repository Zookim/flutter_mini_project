import 'package:cf_tube/model/video_model.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/* 유튜브 동영상을 재생할수 있는 상태로 제공하는 위젯
 * videomodel을 homescreen으로 부터 받으면 재생할수 있는 형태로 만든다.
 *  */
class CustomYoutubePlayer extends StatefulWidget {
  final VideoModel videoModel;
  CustomYoutubePlayer({required this.videoModel, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CustomYoutubePlayerState();
}

class _CustomYoutubePlayerState extends State<CustomYoutubePlayer> {
  YoutubePlayerController? controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //컨트롤러 초기화
    controller = YoutubePlayerController(
      initialVideoId: widget.videoModel.id,
      flags: YoutubePlayerFlags(autoPlay: false), //자동실행안함
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        YoutubePlayer(
          controller: controller!,
          showVideoProgressIndicator: true,
        ), //동영상 슬라이더 보이기
        const SizedBox(height: 16),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              widget.videoModel.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            )),
        const SizedBox(height: 16),
      ],
    );
  }
}
