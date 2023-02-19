class TimelineModel {
  final int id;
  final String startTime;
  final String finishTime;
  final String time;

  TimelineModel({this.id, this.startTime, this.finishTime, this.time});

  factory TimelineModel.fromMap(Map<String, dynamic> json) =>
      new TimelineModel(id: json['id'], startTime: json['startTime'], finishTime: json['finishTime'], time: json['time']);

  Map<String, dynamic> toMap() {
    return {'id': id, 'startTime': startTime, 'finishTime': finishTime, 'time': time};
  }
}