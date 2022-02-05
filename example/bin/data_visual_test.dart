import 'package:odata/odata.dart';

import '../../test/requester_fake.dart';
import 'mappers.dart';
import 'odata_manager.dart';

Future dataVisualExample() async {
  const data = {
    ODATA_CONTEXT: 'fake_context',
    ODATA_VALUE: [
      {
        'Id': '1',
        'Width': 100,
        'Height': 31,
        'Sides': [
          {'Id': '1', 'Length': 10}
        ],
        'Parent': {
          'Id': 2,
          'Width': 48,
          'Height': 21,
          'Sides': null,
          'Parent': null
        }
      },
      {'Id': '2', 'Width': 48, 'Height': 21, 'Sides': null, 'Parent': null}
    ]
  };
  final requester =
      RequesterFaker(baseUrl: 'http://localhost:5000', data: data);
  final manager = ODataManager(requester: requester);
  final mapped = ODataSourceMapped(manager.figure, FigureMapper());
  final response = await mapped.list();

  print('');
  response.data?.value?.forEach((figure) {
    print(figure);
  });
}
