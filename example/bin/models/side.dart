class Side {
  String id;
  int length;
  Map<String, dynamic> dyn;

  Side({
    required this.id,
    required this.length,
    required this.dyn,
  });

  factory Side.fromMap(Map<String, dynamic> data) {
    var dyn = Map<String, dynamic>.from(data)..remove('Id')..remove('Length');
    return Side(id: data['Id'], length: data['Length'], dyn: dyn);
  }

  static List<Side> fromMany(List<Map<String, dynamic>> list) {
    return list.map((e) => Side.fromMap(e)).toList();
  }

  @override
  String toString() {
    return 'Side(id=$id, length=$length)';
  }
}
