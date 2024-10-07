import 'package:calendar_scheduler/component/main_calendar.dart';
import 'package:calendar_scheduler/component/schedule_card.dart';
import 'package:calendar_scheduler/component/schedule_insert_sheet.dart';
import 'package:calendar_scheduler/component/selectedDay_banner.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:calendar_scheduler/provider/schedule_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  DateTime selectedDate = DateTime.utc(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);
  @override
  Widget build(BuildContext context) {
    //provider의 변경이 생길때 마다 build() 재실행
    final provider = context.watch<ScheduleProvider>();
    final selectedDate = provider.selectedDate;
    final schedules = provider.cache[selectedDate] ?? [];

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (_) => ScheduleInsertSheet(selectedDate: selectedDate),
            isScrollControlled:
                true, //이게 있어야 화면이 올라온다. 없으면 화면 반 이상의 위치로 올라오지 못한다.
            isDismissible: true, // 배경을 탭할시 모달이 닫힘
          );
        },
        backgroundColor: PRIMARY_COLOR,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
      body: SafeArea(
          child: Column(
        children: [
          MainCalendar(
            onDaySelected: (selectedDate, focusedDate) =>
                onDaySelected(selectedDate, focusedDate, context),
            selectedDate: selectedDate,
          ),
          SizedBox(height: 10),
          selectedDayBanner(
              selectedDate: selectedDate, count: schedules.length),
          /*StreamBuilder<List<Schedule>>(
              stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDate),
              builder: (context, snapshot) {
                return selectedDayBanner(
                    selectedDate: selectedDate,
                    count: snapshot.data?.length ?? 0);
              }),*/
          SizedBox(height: 5),
          //ScheduleCard(startTime: 1, endTime: 21, content: 'test'),
          Expanded(
              child: ListView.builder(
            itemCount: schedules.length, //총 갯수
            itemBuilder: (context, index) {
              final schedule = schedules[index];

              return Dismissible(
                  key: ObjectKey(schedule.id),
                  direction: DismissDirection.startToEnd, //이 방향만 인식한다.
                  onDismissed: (DismissDirection direction) {
                    provider.deleteSchedule(
                        date: selectedDate, id: schedule.id);
                  },
                  child: ScheduleCard(
                    startTime: schedule.startTime,
                    endTime: schedule.endTime,
                    content: schedule.content,
                  ));
            },
          )),

          /*
          Expanded(
            child: StreamBuilder<List<Schedule>>(
              //선택한 날이 변경되면 다시 값을 읽어온다.
              stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDate),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                return ListView.builder(
                  itemCount: snapshot.data!.length, //총 갯수
                  itemBuilder: (context, index) {
                    //리스트에서 index번째의 스케쥴
                    final Schedule = snapshot.data![index];
                    return Dismissible(
                        key: ObjectKey(Schedule.id),
                        direction: DismissDirection.startToEnd, //이 방향만 인식한다.
                        onDismissed: (DismissDirection direction) {
                          GetIt.I<LocalDatabase>().deleteSchedule(Schedule.id);
                        },
                        child: ScheduleCard(
                          startTime: Schedule.startTime,
                          endTime: Schedule.endTime,
                          content: Schedule.content,
                        ));
                  },
                );
              },
            ),
          ),*/
        ],
      )),
    );
  }

  void onDaySelected(
      DateTime selectedDate, DateTime focusedDate, BuildContext context) {
    print('onDaySelected ${selectedDate.toString()}');
    final provider = context.read<ScheduleProvider>();
    provider.changeSelectedDate(date: selectedDate);
    provider.getSchedules(date: selectedDate);
  }
}
