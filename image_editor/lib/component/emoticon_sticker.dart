import 'package:flutter/material.dart';

//선택된 각 스티커에 대한 위젯
class EmoticonSticker extends StatefulWidget {
  final VoidCallback onTransform; //이미지자체를 수정해야하는 경우 호출, 크기등
  final String imgPath;
  final bool isSelected;

  const EmoticonSticker(
      {required this.onTransform,
      required this.imgPath,
      required this.isSelected,
      Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _EmoticonStickerState();
}

class _EmoticonStickerState extends State<EmoticonSticker> {
  double scale = 1; //확대 축소 배율
  double hTransform = 0; //가로 움직임
  double vTransform = 0; //세로 움직임
  double actualScale = 1; // 스티커의 초기크기 기준 배율

  @override
  Widget build(BuildContext context) {
    return Transform(
        //child위젯을 변화시킬수 있다. 변화된 스티커의 상태를 반영할수 있다.
        transform: Matrix4.identity() //자식위젯의 변화를 행렬로 정의한다.
          ..translate(hTransform, vTransform) //상하좌우 움직임 정의
          ..scale(scale, scale), //확대 축소

        child: Container(
            //선택된 스티커엔 테두리를 준다.
            decoration: widget.isSelected
                ? BoxDecoration(
                    border: Border.all(color: Colors.orange, width: 1))
                : BoxDecoration(
                    border: Border.all(color: Colors.transparent, width: 1)),
            child: GestureDetector(
              onTap: () {
                widget.onTransform();//
              },
              onScaleUpdate: (ScaleUpdateDetails details) {
                widget.onTransform();
                setState(() {
                  //상태변화
                  scale = details.scale * actualScale;
                  vTransform += details.focalPointDelta.dy; //세로 움직임
                  hTransform += details.focalPointDelta.dx; //가로 움직임
                });
              },
              onScaleEnd: (ScaleEndDetails details) {
                actualScale = scale; //반드시 저장해두어야 마지막으로 다음엔 수정한 크기에서 변화한다.
              },
              child: Image.asset(widget.imgPath),
            )));
  }
}
