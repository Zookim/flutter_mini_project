import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime firstDay = DateTime.now(); // 날짜를 저장한다.

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.pink[100],
      body: SafeArea(
        top: true,
        bottom: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DDay(
              // 네임드 파라미터
              OnHeartPressed:
                  onHeartPressed, //_DDay가 가진 하트 위젯을 눌렀을 때 실행할 함수를 전달한다.
              firstDay: firstDay,
            ),
            _CoupleImage(),
          ],
        ),
      ),
    );
  }

  void onHeartPressed() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return Align(
          // 자식을 어떻게 위치할지 정할수 있다.
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Color.fromARGB(95, 255, 255, 255),
            height: 300,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (DateTime date) {
                setState(() {
                  firstDay = date;
                });
              },
            ),
          ),
        );
      },
      barrierDismissible: true,
    );
    /*
    setState(() {
      // setState가 없다면 값은 변경되어도 build되지 않기 때문에 UI에 반영되지 않는다.
      firstDay = firstDay.subtract(Duration(days: 1));
    });*/
    //이것은 일급객체인 함수이다.
    //print('클릭');
  }
}

class _DDay extends StatelessWidget {
  final GestureTapCallback OnHeartPressed; //어디선가 이 제스처가 발생하면 이것을 반환하는데
  final DateTime firstDay; //= DateTime.now(); 값을 넣어 주지 않는다면 어디선가 받아오는 상태여야한다.
  final DateTime now = DateTime.now();
  _DDay({
    required this.OnHeartPressed, //이것은 상위함수로 부터 받아오며
    required this.firstDay,
  }); // 상위함수로 부터 받는다.
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // TODO: implement build
    return Column(
      children: [
        const SizedBox(height: 16),
        Text(
          'U&I',
          style: textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        Text(
          '우리 처음 만난날',
          style: textTheme.bodySmall,
        ),
        const SizedBox(height: 16),
        Text(
          '${firstDay.year}.${firstDay.month}.${firstDay.day}',
          style: textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        IconButton(
          iconSize: 60,
          onPressed: OnHeartPressed, //어딘가란 이곳이고
          icon: Icon(
            Icons.favorite,
            color: Colors.red,
          ),
        ),
        const SizedBox(height: 16),
        Text(
            'D+${DateTime(now.year, now.month, now.day).difference(firstDay).inDays + 1}',
            style: textTheme.headlineMedium),
      ],
    );
  }
}

class _CoupleImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Expanded(
      //이미지는 _DDay가 먼저 위치된후 남은 만큼만 차지하도록한다.
      child: Center(
        child: Image.asset(
          'assets/img/middle_image.png',
          height: MediaQuery.of(context).size.height / 2,
        ),
      ),
    );
  }
}
