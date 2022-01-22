import 'package:odata/odata_params.dart';
import 'package:test/test.dart';

// URLs was stolen from https://devblogs.microsoft.com/odata/aggregation-extensions-in-odata-asp-net-core/

void aggregateTest1() {
  const expected =
      'http://localhost:5000/odata/Orders?\$apply=aggregate(\$count as OrderCount)';
  const params = Params(apply: Aggregate([Count('OrderCount')]));
  final result = 'http://localhost:5000/odata/Orders?$params';
  expect(expected, result);
}

void aggregateTest2() {
  const expected =
      'http://localhost:5000/odata/Orders?\$apply=groupby((Customer/Name), aggregate(\$count as OrderCount, TotalAmount with sum as TotalAmount))';
  const params = Params(
      apply: GroupBy('Customer/Name',
          Aggregate([Count('OrderCount'), Sum1('TotalAmount')])));
  final result = 'http://localhost:5000/odata/Orders?$params';
  expect(expected, result);
}

void aggregateTest3() {
  const expected =
      "http://localhost:5000/odata/Orders?\$apply=filter(Customer/HomeAddress/City eq 'Redonse')/groupby((Customer/Name), aggregate(\$count as OrderCount, TotalAmount with sum as TotalAmount))";
  const params = Params(
      apply: Sequence([
    Filter(Eq('Customer/HomeAddress/City', "'Redonse'")),
    GroupBy(
        'Customer/Name', Aggregate([Count('OrderCount'), Sum1('TotalAmount')]))
  ]));
  final result = 'http://localhost:5000/odata/Orders?$params';
  expect(expected, result);
}

void aggregateTest4() {
  const expected =
      'http://localhost:5000/odata/Orders?\$apply=groupby((Customer/Name), aggregate(\$count as OrderCount, TotalAmount with sum as TotalAmount))/filter(TotalAmount gt 23)';
  const params = Params(
      apply: Sequence([
    GroupBy(
        'Customer/Name', Aggregate([Count('OrderCount'), Sum1('TotalAmount')])),
    Filter(Gt('TotalAmount', '23'))
  ]));
  final result = 'http://localhost:5000/odata/Orders?$params';
  expect(expected, result);
}

void aggregateTest5() {
  const expected =
      'http://localhost/odata/Document?\$apply=groupby((Category), aggregate(Documents with countdistinct as Total))';
  const params = Params(
      apply: GroupBy(
          'Category', Aggregate([CountDistinct('Documents', 'Total')])));
  final result = 'http://localhost/odata/Document?$params';
  expect(expected, result);
}

void main() {
  final testCases = [
    aggregateTest1,
    aggregateTest2,
    aggregateTest3,
    aggregateTest4,
    aggregateTest5,
  ];
  testCases.asMap().forEach((index, testCase) {
    test('aggregate #$index', testCase);
  });
}
