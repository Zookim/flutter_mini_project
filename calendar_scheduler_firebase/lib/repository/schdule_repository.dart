import 'package:calendar_scheduler/model/schedule_model.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'dart:async';

class SchduleRepository {
  final dio = Dio();

  //http://localhost:3000/schedule?date=20210102
  final _targetUrl = 'http://localhost:3000/schedule';
  //'http://${Platform.isAndroid ? '10.0.2.2' : 'localhost'}:3000/schedule';
  //안드로이드에선 10.0.2.2가 로컬호스트이다.

  Future<List<ScheduleModel>> getSchedules({required DateTime date}) async {
    //dio.options.receiveTimeout = Duration(seconds: 3);
    //dio.options.connectTimeout = Duration(seconds: 3);
    print(
        '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}');

    final resp = await dio.get(
      _targetUrl,
      queryParameters: {
        'date':
            '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}'
      },
    );
    return resp.data
        .map<ScheduleModel>((x) => ScheduleModel.fromJson(json: x))
        .toList();
  }

  Future<String> createSchedule({required ScheduleModel schedule}) async {
    final json = schedule.toJson();
    print(json);
    final resp = await dio.post(_targetUrl, data: json);
    return resp.data?['id'];
  }

  Future<String> deleteSchedule({required String id}) async {
    final resp = await dio.delete(_targetUrl, data: {'id': id});
    print(resp.data?['id']);
    return resp.data?['id'];
  }
}
