import 'package:cf_tube/const/api.dart';
import 'package:cf_tube/model/video_model.dart';
import 'package:dio/dio.dart';

class YoutubeRepository {
  /*영상을 요청하고 받아서 video Model로 저장 */
  static Future<List<VideoModel>> getVideos() async {
    /*get 요청보내기*/
    final resp = await Dio().get(
      YOUTUBE_API_BASE_URL, //요청주소
      queryParameters: {
        //필요값
        'part': 'snippet',
        'channelId': CHANNEL_ID,
        'maxResults': 25,
        'key': API_KEY, //구글 클라우드 API를 사용하고 있다.
        'order': 'date'
      },
    );

    /*받은 데이터 변환 */
    final listWithData = resp.data['items'].where((item) =>
        item?['id']?['videoId'] != null && item?['snippet']?['title'] != null);

    return listWithData
        .map<VideoModel>((item) => VideoModel(
            id: item['id']['videoId'], title: item['snippet']['title']))
        .toList();
  }
}
