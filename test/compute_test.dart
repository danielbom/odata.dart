import 'package:odata/odata_params.dart';
import 'package:test/test.dart';

// URLs was stolen from https://devblogs.microsoft.com/odata/compute-and-search-in-asp-net-core-odata-8/

void computeTest1() {
  const expected =
      'http://localhost:5102/odata/products?\$compute=(Price mul Qty as TotalPrice)&\$select=TotalPrice';
  const params = Params(
      compute: [Named(Mul('Price', 'Qty'), 'TotalPrice')],
      select1: ['TotalPrice']);
  final result = 'http://localhost:5102/odata/products?$params';
  expect(expected, result);
}

void computeTest2() {
  const expected =
      'http://localhost:5102/odata/products?\$compute=(Location/ZipCode div 1000 as MainZipCode)&\$select=Id,MainZipCode';
  const params = Params(
      compute: [Named(Div('Location/ZipCode', '1000'), 'MainZipCode')],
      select1: ['Id', 'MainZipCode']);
  final result = 'http://localhost:5102/odata/products?$params';
  expect(expected, result);
}

void computeTest3() {
  const expected =
      'http://localhost:5102/odata/products?\$compute=(substring(Name,0,1) as FirstChar)&\$select=FirstChar';
  const params = Params(
      compute: [Named(SubString('Name', 0, 1), 'FirstChar')],
      select1: ['FirstChar']);
  final result = 'http://localhost:5102/odata/products?$params';
  expect(expected, result);
}

void computeTest4() {
  const expected =
      'http://localhost:5102/odata/products?\$compute=(Price mul Qty as TotalPrice),(TaxRate mul 1.1 as NewTaxRate)&\$select=Id,TotalPrice,NewTaxRate';
  const params = Params(compute: [
    Named(Mul('Price', 'Qty'), 'TotalPrice'),
    Named(Mul('TaxRate', '1.1'), 'NewTaxRate'),
  ], select1: [
    'Id',
    'TotalPrice',
    'NewTaxRate'
  ]);
  final result = 'http://localhost:5102/odata/products?$params';
  expect(expected, result);
}

void computeTest5() {
  const expected =
      'http://localhost:5102/odata/products?\$select=Location(\$compute=(ZipCode div 1000 as MainZipCode);\$select=City,MainZipCode)&\$expand=Sales(\$filter=(SaleYear eq 1999);\$compute=(year(SaleDate) as SaleYear))';
  const params = Params(
    expand: [
      Expand(
          'Sales',
          Params(
              filter: Eq('SaleYear', '1999'),
              compute: [Named(Year('SaleDate'), 'SaleYear')]))
    ],
    select: [
      Select(
          'Location',
          Params(
              compute: [Named(Div('ZipCode', '1000'), 'MainZipCode')],
              select1: ['City', 'MainZipCode']))
    ],
  );
  final result = 'http://localhost:5102/odata/products?$params';
  expect(expected, result);
}

void main() {
  test('compute #1', computeTest1);
  test('compute #2', computeTest2);
  test('compute #3', computeTest3);
  test('compute #4', computeTest4);
  test('compute #5', computeTest5);
}
