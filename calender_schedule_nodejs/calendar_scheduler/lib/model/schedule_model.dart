//db로 부터 받은 모델을 클래스로 앱내부에서 사용한다.
class ScheduleModel {
  final String id;
  final String content;
  final DateTime date;
  final int startTime;
  final int endTime;
  ScheduleModel({
    required this.id,
    required this.content,
    required this.date,
    required this.startTime,
    required this.endTime,
  });

//json으로 부터 모델을 만드는 생성자
  ScheduleModel.fromJson({required Map<String, dynamic> json})
      : id = json['id'],
        content = json['content'],
        date = DateTime.parse(json['date']),
        startTime = json['startTime'],
        endTime = json['endTime'];

  //모델을 Json으로 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'date':
          '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}',
      'startTime': startTime,
      'endTime': endTime,
    };
  }

  //현재 모델의 특정 속성만 변경해 새로 생성
  //이미 존재하는 인스턴스의 값을 변경할수 없기에 일부만 수정하려는 경우
  // 이렇게 입력한 값만 변경하고 나머지는 기존값을 따르도록 한다.
  ScheduleModel copyWith(
      {String? id,
      String? content,
      DateTime? date,
      int? startTime,
      int? endTime}) {
    return ScheduleModel(
      id: id ?? this.id,
      content: content ?? this.content,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}
