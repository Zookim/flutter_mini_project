import 'package:flutter/material.dart';
import 'package:video_call/screen/cam_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.blue[100]!,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _Logo()),
              Expanded(child: _Image()),
              Expanded(child: _EntryButton()),
              //expanded로 우선 해당 행을 보두 차지하도록한다.
            ],
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              //list로 제공 -> 여러 그림자를 적용 할수도 있다.
              BoxShadow(
                color: Colors.blue[300]!,
                blurRadius: 12, //흐림정도
                spreadRadius: 2, //퍼짐정도
              ),
            ]),
        //decoration: Shadow(color: Colors.black, offset: , blurRadius: 1),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisSize: MainAxisSize.min, //좌우로 최소한의 크기만 차지한다.
            children: [
              Icon(
                Icons.videocam,
                color: Colors.white,
              ),
              SizedBox(width: 5),
              Text(
                ' LIVE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2, //글자간의 간격
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Image extends StatelessWidget {
  const _Image({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
        child: SizedBox(
            height: 300,
            width: 300,
            child: Image.asset('asset/img/home_img.png')));
  }
}

class _EntryButton extends StatelessWidget {
  const _EntryButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => CamScreen(),
            ));
          },
          child: Text(
            '입장하기',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
