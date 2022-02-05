import 'package:odata/odata_mapper.dart';

import 'models/figure.dart';

class FigureMapper implements ODataMapper<Figure> {
  @override
  List<Figure> mapMany(List<Map<String, dynamic>> data) {
    return Figure.fromMany(data);
  }

  @override
  Figure mapOne(Map<String, dynamic> data) {
    return Figure.fromMap(data);
  }
}
