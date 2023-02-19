class TimelineModel {
  final int id;
  final String name;

  TimelineModel({this.id, this.name});

  factory TimelineModel.fromMap(Map<String, dynamic> json) =>
      new TimelineModel(id: json['id'], name: json['name']);

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }
}
