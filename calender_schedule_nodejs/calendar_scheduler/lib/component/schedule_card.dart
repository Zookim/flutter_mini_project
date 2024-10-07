import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';

class ScheduleCard extends StatelessWidget {
  final int startTime;
  final int endTime;
  final String content;

  ScheduleCard(
      {required this.startTime,
      required this.endTime,
      required this.content,
      Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
      decoration: BoxDecoration(
          border: Border.all(color: PRIMARY_COLOR, width: 2),
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: IntrinsicHeight(
          child: Row(
            children: [
              _Time(startTime: this.startTime, endTime: this.endTime),
              SizedBox(width: 16),
              _Content(content: this.content),
              SizedBox(width: 16),
              _Buttons()
            ],
          ),
        ),
      ),
    );
  }
}

class _Time extends StatelessWidget {
  final int startTime;
  final int endTime;

  _Time({required this.startTime, required this.endTime, Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontWeight: FontWeight.w600,
      color: PRIMARY_COLOR,
      fontSize: 16,
    );
    // TODO: implement build
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${startTime.toString().padLeft(2, '0')}:${startTime.toString().padLeft(2, '0')}',
          style: textStyle,
        ),
        Text(
          '${endTime.toString().padLeft(2, '0')}:${endTime.toString().padLeft(2, '0')}',
          style: textStyle.copyWith(fontSize: 10),
        )
      ],
    );
  }
}

class _Content extends StatelessWidget {
  final String content;

  const _Content({required this.content, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Expanded(child: Text(content, style: TextStyle(fontSize: 16)));
  }
}

class _Buttons extends StatefulWidget {
  bool state = false;
  _Buttons({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ButtonsState();
}

class _ButtonsState extends State<_Buttons> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Row(children: [
        //중지 종료 버튼 추가
        if (!widget.state)
          ElevatedButton(
            onPressed: () {
              setState(() {
                widget.state = true;
              });
            },
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.red,
                backgroundColor: Colors.yellow,
                shadowColor: const Color.fromARGB(255, 134, 36, 29)),
            child: Text(
              '시작',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        if (widget.state)
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.red,
                backgroundColor: Colors.yellow,
                shadowColor: const Color.fromARGB(255, 134, 36, 29)),
            child: Text('중지', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        SizedBox(width: 10),
        if (widget.state)
          ElevatedButton(
            onPressed: () {
              setState(() {
                widget.state = false;
              });
            },
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.red,
                backgroundColor: Colors.yellow,
                shadowColor: const Color.fromARGB(255, 134, 36, 29)),
            child: Text('종료', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
      ]),
    );
  }
}
