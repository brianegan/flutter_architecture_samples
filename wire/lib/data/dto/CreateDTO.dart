class CreateDTO {
  final String text;
  final String note;
  final bool completed;

  CreateDTO(this.text, this.note, [this.completed = false]);
}