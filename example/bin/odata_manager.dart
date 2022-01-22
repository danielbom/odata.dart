import 'package:odata/odata_requester.dart';
import 'package:odata/odata_source.dart';

class ODataManager {
  ODataRequester requester;
  late ODataSource figure;
  late ODataSource side;

  ODataManager({required this.requester}) {
    figure = ODataSource(requester: requester, entity: 'Figure');
    side = ODataSource(requester: requester, entity: 'Side');
  }
}
