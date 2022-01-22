class Figure {
  String id;
  int width;
  int height;

  Figure({required this.id, required this.width, required this.height});

  factory Figure.fromMap(Map<String, dynamic> data) {
    return Figure(id: data['Id'], width: data['Width'], height: data['Height']);
  }

  static List<Figure>? fromMany(List<Map<String, dynamic>>? list) {
    return list?.map((e) => Figure.fromMap(e)).toList();
  }

  @override
  String toString() {
    return 'Figure(id=$id, width=$width, height=$height)';
  }
}
