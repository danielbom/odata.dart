class Figure {
  String id;
  int width;
  int height;
  Map<String, dynamic> dyn;

  Figure({required this.id, required this.width, required this.height, required this.dyn});

  factory Figure.fromMap(Map<String, dynamic> data) {
    var dyn = Map<String, dynamic>.from(data)
      ..remove('Id')
      ..remove('Width')
      ..remove('Height');

    return Figure(
      id: data['Id'],
      width: data['Width'],
      height: data['Height'],
      dyn: dyn
    );
  }

  static List<Figure> fromMany(List<Map<String, dynamic>> list) {
    return list.map((e) => Figure.fromMap(e)).toList();
  }

  @override
  String toString() {
    return 'Figure(id=$id, width=$width, height=$height)';
  }
}
