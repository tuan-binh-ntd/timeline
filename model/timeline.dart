class Timeline {
  final int id;
  final String name;

  Timeline({this.id, this.name});

  factory Timeline.fromMap(Map<String, dynamic> json) =>
      new Timeline(id: json['id'], name: json['name']);

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }
}
