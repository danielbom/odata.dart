import 'package:odata/odata.dart';
import 'models/models.dart';
import 'odata_manager.dart';
import 'requester_fake.dart';

List<Figure> figureMapper(Map<String, dynamic> data) {
  return Figure.fromMany(ODataSource.getValueAsList(data));
}

Future urlVisualExample(
    {required ODataManager manager,
    RequestOptions? options,
    Params? params,
    String? params1}) async {
  final response = await manager.figure
      .list(options: options, params: params, params1: params1);
  print('');
  print(response.url);
}

Future urlVisualExamples() async {
  final requester = RequesterFaker(baseUrl: 'http://localhost:5000');
  final manager = ODataManager(requester: requester);

  {
    const params1 =
        '?\$count=true&\$skip=20&\$top=10&\$filter=(Parent ne null) and (Parent/Status eq available) and (Sides/\$count gt 0)&\$select=Id,Width,Height&\$expand=Sides,Parent(\$expand=Sides)&\$orderby=Width';
    await urlVisualExample(manager: manager, params1: params1);
  }

  {
    const options = RequestOptions(
      params: {
        '\$count': 'true',
        '\$skip': '20',
        '\$top': '10',
        '\$filter':
            '(Parent ne null) and (Parent/Status eq available) and (Sides/\$count gt 0)',
        '\$select': 'Id,Width,Height',
        '\$expand': 'Sides,Parent(\$expand=Sides)',
        '\$orderby': 'Width'
      },
    );
    await urlVisualExample(manager: manager, options: options);
  }

  {
    const params = Params(
        count: true,
        skip: 20,
        top: 10,
        filter: And([
          NotNull('Parent'),
          Eq('Parent/Status', 'available'),
          Gt('Sides/\$count', '0')
        ]),
        select1: ['Id', 'Width', 'Height'],
        expand1: ['Sides', 'Parent(\$expand=Sides)'],
        orderby1: ['Width']);
    await urlVisualExample(manager: manager, params: params);
  }

  {
    const params = Params(
        count: true,
        skip: 20,
        top: 10,
        filter: And([
          NotNull('Parent'),
          Eq('Parent/Status', 'available'),
          Gt('Sides/\$count', '0')
        ]),
        select: [
          Select('Id'),
          Select('Width'),
          Select('Height')
        ],
        expand: [
          Expand('Sides'),
          Expand('Parent', Params(expand: [Expand('Sides')]))
        ],
        orderby: [
          OrderAsc('Width')
        ]);
    await urlVisualExample(manager: manager, params: params);
  }
}
