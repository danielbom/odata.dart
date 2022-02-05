import 'package:odata/odata.dart';

abstract class ODataMapper<T> {
  const ODataMapper();

  T mapOne(Map<String, dynamic> data);
  List<T> mapMany(List<Map<String, dynamic>> data);
}

extension ODataMapperExtension<T> on ODataMapper<T> {
  List<T> mapMany1(Map<String, dynamic> data) {
    return mapMany(ODataSource.getValueAsList(data));
  }
}
