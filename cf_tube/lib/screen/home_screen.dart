import 'package:cf_tube/component/custom_youtube_player.dart';
import 'package:cf_tube/model/video_model.dart';
import 'package:cf_tube/repository/youtube_repository.dart';
import 'package:flutter/material.dart';

/*동영상 새로고침이 가능하기 위해선 StatefulWidget */
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        centerTitle: true,
        title: Text('October'),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<List<VideoModel>>(
        future: YoutubeRepository.getVideos(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
              //새로 고침이 가능한 위젲
              onRefresh: () async {
                //재빌드할수 있도록한다.
                setState(() {});
              },
              child: ListView(
                  physics: BouncingScrollPhysics(), //애니메이션 추가
                  children: snapshot.data!
                      .map((e) => CustomYoutubePlayer(videoModel: e))
                      .toList()));
        },
      ),
    );
  }
}
