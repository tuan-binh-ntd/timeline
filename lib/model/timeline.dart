class TimelineModel {
  final int id;
  final String startTime;
  final String finishTime;
  final double time;

  TimelineModel({this.id, this.startTime, this.finishTime, this.time});

  factory TimelineModel.fromMap(Map<String, dynamic> json) {
    return new TimelineModel(
        id: json['Id'],
        startTime: json['StartTime'],
        finishTime: json['FinishTime'],
        time: json['Time']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'startTime': startTime,
      'finishTime': finishTime,
      'time': time
    };
  }
}
