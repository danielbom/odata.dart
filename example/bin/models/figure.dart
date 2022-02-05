import 'side.dart';

class Figure {
  String id;
  int width;
  int height;
  List<Side> sides;
  Figure? parent;
  Map<String, dynamic> dyn;

  Figure({
    required this.id,
    required this.width,
    required this.height,
    required this.dyn,
    required this.sides,
    required this.parent
  });

  factory Figure.fromMap(Map<String, dynamic> data) {
    var dyn = Map<String, dynamic>.from(data)
      ..remove('Id')
      ..remove('Width')
      ..remove('Height')
      ..remove('Sides')
      ..remove('Parent');

    return Figure(
        id: data['Id'],
        width: data['Width'],
        height: data['Height'],
        sides: data['Sides'] != null ? Side.fromMany(List.from(data['Sides'])) : const [],
        parent: data['Parent'] != null ? Figure.fromMap(Map.from(data['Parent'])) : null,
        dyn: dyn);
  }

  static List<Figure> fromMany(List<Map<String, dynamic>> list) {
    return list.map((e) => Figure.fromMap(e)).toList();
  }

  @override
  String toString() {
    return 'Figure(id=$id, width=$width, height=$height, sides=$sides, parent=$parent)';
  }
}
