import 'package:calendar_scheduler/component/main_calendar.dart';
import 'package:calendar_scheduler/component/schedule_card.dart';
import 'package:calendar_scheduler/component/schedule_insert_sheet.dart';
import 'package:calendar_scheduler/component/selectedDay_banner.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:calendar_scheduler/model/schedule_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.utc(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);
  @override
  Widget build(BuildContext context) {
    /*
    final provider = context.watch<ScheduleProvider>();
    final selectedDate = provider.selectedDate;
    final schedules = provider.cache[selectedDate] ?? [];*/

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

          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('schedule')
                  .where('date',
                      isEqualTo:
                          '${selectedDate.year}${selectedDate.month.toString().padLeft(2, '0')}${selectedDate.day.toString().padLeft(2, '0')}')
                  .snapshots(),
              builder: (context, snapshot) {
                return selectedDayBanner(
                    selectedDate: selectedDate,
                    count: snapshot.data?.docs.length ?? 0);
              }),
          SizedBox(height: 5),
          //ScheduleCard(startTime: 1, endTime: 21, content: 'test'),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              //선택한 날이 변경되면 다시 값을 읽어온다.
              stream: FirebaseFirestore.instance
                  .collection('schedule')
                  .where('date',
                      isEqualTo:
                          '${selectedDate.year}${selectedDate.month.toString().padLeft(2, '0')}${selectedDate.day.toString().padLeft(2, '0')}')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('일정정보를 가져오지 못했습니다.'),
                  );
                }
                //로딩중
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container();
                }
                print(snapshot.data!.docs.length);
                final schedules = snapshot.data!.docs
                    .map((QueryDocumentSnapshot e) => ScheduleModel.fromJson(
                        json: (e.data() as Map<String, dynamic>)))
                    .toList();

                return ListView.builder(
                  itemCount: schedules.length, //총 갯수
                  itemBuilder: (context, index) {
                    //리스트에서 index번째의 스케쥴
                    final schedule = schedules[index];
                    return Dismissible(
                        key: ObjectKey(schedule.id),
                        direction: DismissDirection.startToEnd, //이 방향만 인식한다.
                        onDismissed: (DismissDirection direction) {
                          FirebaseFirestore.instance
                              .collection('schedule')
                              .doc(schedule.id)
                              .delete();
                        },
                        child: ScheduleCard(
                          startTime: schedule.startTime,
                          endTime: schedule.endTime,
                          content: schedule.content,
                        ));
                  },
                );
              },
            ),
          ),
        ],
      )),
    );
  }

  void onDaySelected(
      DateTime selectedDate, DateTime focusedDate, BuildContext context) {
    print('onDaySelected ${selectedDate.toString()}');
    setState(() {
      this.selectedDate = selectedDate;
    });

    /*
    final provider = context.read<ScheduleProvider>();
    provider.changeSelectedDate(date: selectedDate);
    provider.getSchedules(date: selectedDate);
  */
  }
}
