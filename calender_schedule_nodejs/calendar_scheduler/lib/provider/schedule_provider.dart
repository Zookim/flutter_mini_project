import 'dart:ui';

import 'package:calendar_scheduler/model/schedule_model.dart';
import 'package:calendar_scheduler/repository/schdule_repository.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

// ScheduleRepository, selectedDate, cache 변수 3가지 필요
class ScheduleProvider extends ChangeNotifier {
  final SchduleRepository repository;
  DateTime selectedDate = DateTime.utc(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);
  Map<DateTime, List<ScheduleModel>> cache = {};

  ScheduleProvider({required this.repository}) : super() {
    getSchedules(date: selectedDate);
  }

//일정을 읽어온다.
  void getSchedules({required DateTime date}) async {
    print('getSchedules ${date.toString()}');
    final resp = await repository.getSchedules(date: date);
    //선택한 날짜의 일정을 업데이트 한다.
    cache.update(date, (value) => resp, ifAbsent: () => resp); // 이게 있으면 결과가 뜬다.
    notifyListeners();
    //이 함수를 실행하면 watch하는 모든 위젯의 build를 재실행한다.
  }

  //일정을 생성한다. DB에 삽입
  void createSchedule({required ScheduleModel schedule}) async {
    print('createSchedule');
    final targetDate = schedule.date;

    final uuid = Uuid();

    final tmpId = uuid.v4();
    final newSchedule = schedule.copyWith(id: tmpId);
    //optimistic response
    //update cache(add data), before get server reponse
    cache.update(
        targetDate,
        (value) => [
              ...value,
              newSchedule,
            ]..sort((a, b) => a.startTime.compareTo(b.startTime)),
        ifAbsent: () => [newSchedule]);
    notifyListeners();
    try {
      final savedSchedule = await repository.createSchedule(schedule: schedule);
      cache.update(
          targetDate,
          (value) => value
              .map((e) => e.id == tmpId ? e.copyWith(id: savedSchedule) : e)
              .toList());
    } catch (e) {
      //입력 실패시 롤백하기
      cache.update(
          targetDate, (value) => value.where((e) => e.id != tmpId).toList());
    }
    notifyListeners();
  }

  void deleteSchedule({required DateTime date, required String id}) async {
    print('deleteSchedule ${date.toString()}');
    final tarSchedule =
        cache[date]!.firstWhere((e) => e.id == id); //삭제하려는 일정을 캐시를 위해 저장해 둔다.
    cache.update(date, (value) => value.where((e) => e.id != id).toList(),
        ifAbsent: () => []); //같지 않은것만 가져간다.
    notifyListeners();

    try {
      final resp = await repository.deleteSchedule(id: id);
    } catch (e) {
      print('delete error');
      cache.update(
          date,
          (value) => [...value, tarSchedule]
            ..sort((a, b) => a.startTime.compareTo(b.startTime)));
    }
    notifyListeners();
  }

  //키가 되는 날짜 변경
  void changeSelectedDate({required DateTime date}) {
    print('changeSelectedDate ${date.toString()}');
    selectedDate = date;
    notifyListeners();
    //이 함수를 실행하면 watch하는 모든 위젯의 build를 재실행한다.
  }
}
