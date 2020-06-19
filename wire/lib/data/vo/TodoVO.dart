import 'dart:math';

class TodoVO {
  bool completed;
  String text;
  String note;
  String id;

  bool visible = true;

  TodoVO(this.id, this.text, this.note, this.completed);

  TodoVO.fromJson(Map<String, dynamic> json):
      id = json['id'],
      text = json['text'],
      note = json['note'],
      completed = json['completed']
  ;

  Map<String, dynamic> toJson() =>
    {
      'id': id,
      'text': text,
      'note': note,
      'completed': completed
    };
}