import 'dart:io';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:calendar_scheduler/model/schedule.dart';
import 'package:drift/drift.dart';

//private 까지 불러 올수 있다.
part 'drift_database.g.dart'; //part파일 지정
// model/schedule.dart 파일 처럼 '코드 생성'을 사용하려면 part파일을 지정해 주어야한다.
//일반적으로 현재 파일에 .g.를 추가한 파일명을 가지며, 코드 생성시 해당 코드가 생성된다.

@DriftDatabase(
  tables: [
    Schedules,
  ],
)
// 쿼리 작성
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection()); //필수,DB를 생성할 위치에 대한 정보 입력

  @override
  int get schemaVersion => 1; //테이블 변화시마다 값을 증가시켜 테이블의 구조가 변경되었음을 drift에 알린다.

  //날짜가 변경될때마다 일정리스트를 읽어오므로 watch사용
  //테이블명 schedules ,대소문을 구분안한다하면...
  //Schedule는 뭐지 ?????
  Stream<List<Schedule>> watchSchedules(DateTime date) =>
      (select(schedules)..where((tbl) => tbl.date.equals(date))).watch();

  Future<int> createSchedule(SchedulesCompanion data) =>
      into(schedules).insert(data);

  Future<int> deleteSchedule(int data) =>
      (delete(schedules)..where((tbl) => tbl.id.equals(data))).go();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    //db파일을 저장할 폴더
    //현재 앱에 배정된 폴더 경로를 dbFolder로 받아온다.
    final dbFolder = await getApplicationDocumentsDirectory();
    //배정된 폴더의 db.sqlite를 db폴더로 사용한다.
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
