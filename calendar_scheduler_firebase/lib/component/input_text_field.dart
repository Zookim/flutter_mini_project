import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/*공통으로 사용되는 입력 필드*/
class InputTextField extends StatelessWidget {
  final String label;
  final bool isTime;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;

  const InputTextField(
      {required this.label,
      required this.isTime,
      required this.onSaved,
      required this.validator,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(this.label,
            style:
                TextStyle(color: PRIMARY_COLOR, fontWeight: FontWeight.w700)),
        Expanded(
          flex: isTime ? 0 : 1, //0이면 최소, 1이면 최대한, expanded간의 비율로 사용
          child: TextFormField(
            onSaved: onSaved, //  폼 저장시 실행할 함수
            validator: validator, // 폼 검증시 실행할 함수
            // 폼안에 다수의 텍스트 입력을  사용함
            cursorColor: const Color.fromARGB(255, 124, 123, 123),
            maxLines: isTime ? 1 : null, //시간 필드가 아니면 제한 없음
            expands: !isTime, //시간필드가 아니면 최대 공간을 차지한다.
            keyboardType:
                isTime ? TextInputType.number : TextInputType.multiline,
            //시간 필드가 아니면 일반 키보드
            inputFormatters:
                isTime ? [FilteringTextInputFormatter.digitsOnly] : [],
            //시간 필드는 숫자만 입력 가능하도록 한다.
            decoration: InputDecoration(
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.grey[100],
              suffixText: isTime ? '시' : null, // 시간필드에서 접미사 추가
            ),
          ),
        ),
      ],
    );
  }
}
