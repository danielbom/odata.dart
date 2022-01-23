library odata;

// http://docs.oasis-open.org/odata/odata/v4.01/odata-v4.01-part2-url-conventions.html#_Toc31360970

String internalToString(dynamic x) {
  return x.toString();
}

abstract class Nameable {
  const Nameable();
}

// Operations
abstract class Predicate extends Nameable {
  const Predicate();
}

abstract class BinaryPredicate extends Predicate {
  final String lhs;
  final String rhs;
  final String op;

  const BinaryPredicate(this.lhs, this.op, this.rhs);

  @override
  String toString() {
    return '($lhs $op $rhs)';
  }
}

class Ne extends BinaryPredicate {
  const Ne(String lhs, String rhs) : super(lhs, 'ne', rhs);
}

class Eq extends BinaryPredicate {
  const Eq(String lhs, String rhs) : super(lhs, 'eq', rhs);
}

class Gt extends BinaryPredicate {
  const Gt(String lhs, String rhs) : super(lhs, 'gt', rhs);
}

class Ge extends BinaryPredicate {
  const Ge(String lhs, String rhs) : super(lhs, 'ge', rhs);
}

class Lt extends BinaryPredicate {
  const Lt(String lhs, String rhs) : super(lhs, 'lt', rhs);
}

class Le extends BinaryPredicate {
  const Le(String lhs, String rhs) : super(lhs, 'lt', rhs);
}

class IsNull extends Eq {
  const IsNull(String value) : super(value, 'null');
}

class NotNull extends Ne {
  const NotNull(String value) : super(value, 'null');
}

class IsFalse extends Eq {
  IsFalse(Predicate predicate) : super('($predicate)', 'false');
}

class ManyPredicate extends Predicate {
  final List<Predicate> ops;
  final String connector;

  const ManyPredicate({required this.ops, required this.connector});

  @override
  String toString() {
    return ops.join(connector);
  }
}

class And extends ManyPredicate {
  const And(List<Predicate> ops) : super(ops: ops, connector: ' and ');
}

class Or extends ManyPredicate {
  const Or(List<Predicate> ops) : super(ops: ops, connector: ' or ');
}

typedef Any = Or;
typedef All = And;

// Expand
class Expand {
  final String field;
  final Params? params;

  const Expand(this.field, [this.params]);

  @override
  String toString() {
    if (params != null) {
      return '$field(${buildParams(';', params!)})';
    } else {
      return field;
    }
  }
}

// Order
enum Ordering { Asc, Desc }

abstract class Order {
  final String field;
  final Ordering order;

  const Order(this.field, this.order);

  @override
  String toString() {
    if (order == Ordering.Asc) return '$field asc';
    /* if (order == Ordering.Desc) */ return '$field desc';
  }
}

class OrderAsc extends Order {
  const OrderAsc(String field) : super(field, Ordering.Asc);
}

class OrderDesc extends Order {
  const OrderDesc(String field) : super(field, Ordering.Desc);
}

// Apply Base
abstract class Apply {
  const Apply();
}

class Sequence extends Apply {
  final List<Apply> operations;

  const Sequence(this.operations);

  @override
  String toString() {
    return operations.join('/');
  }
}

class Aggregate extends Apply {
  final List<Aggregation> aggregations;

  const Aggregate(this.aggregations);

  @override
  String toString() {
    return 'aggregate(${aggregations.join(', ')})';
  }
}

class GroupBy extends Apply {
  final String field;
  final Apply? aggregate;

  const GroupBy(this.field, this.aggregate);

  @override
  String toString() {
    if (aggregate == null) {
      return 'groupby(($field))';
    } else {
      return 'groupby(($field), $aggregate)';
    }
  }
}

class Filter extends Apply {
  final Predicate filter;

  const Filter(this.filter);

  @override
  String toString() {
    return 'filter$filter';
  }
}

// Aggregate
abstract class Aggregation {
  const Aggregation();
}

// Field Aggregate
abstract class FieldAggregate extends Aggregation {
  final String field;
  final String operation;
  final String asName;

  const FieldAggregate(this.field, this.operation, this.asName);

  @override
  String toString() {
    return '$field with $operation as $asName';
  }
}

class Max extends FieldAggregate {
  const Max(String field, String asName) : super(field, 'max', asName);
}

class Min extends FieldAggregate {
  const Min(String field, String asName) : super(field, 'min', asName);
}

class Sum extends FieldAggregate {
  const Sum(String field, String asName) : super(field, 'sum', asName);
}

class CountDistinct extends FieldAggregate {
  const CountDistinct(String field, String asName)
      : super(field, 'countdistinct', asName);
}

class Max1 extends Max {
  const Max1(String field) : super(field, field);
}

class Min1 extends Min {
  const Min1(String field) : super(field, field);
}

class Sum1 extends Sum {
  const Sum1(String field) : super(field, field);
}

class CountDistinct1 extends CountDistinct {
  const CountDistinct1(String field) : super(field, field);
}

// Operation Aggregate
abstract class OperationAggregate extends Aggregation {
  final String operation;
  final String asName;

  const OperationAggregate(this.operation, this.asName);

  @override
  String toString() {
    return '$operation as $asName';
  }
}

class Count extends OperationAggregate {
  const Count(String asName) : super('\$count', asName);
}

// Operation
abstract class Operation extends Nameable {
  const Operation();
}

// Binary Operation
abstract class BinaryOperation extends Operation {
  final String lhs;
  final String rhs;
  final String op;

  const BinaryOperation(this.lhs, this.op, this.rhs);

  @override
  String toString() {
    return '$lhs $op $rhs';
  }
}

class Add extends BinaryOperation {
  const Add(String lhs, String rhs) : super(lhs, 'add', rhs);
}

class Sub extends BinaryOperation {
  const Sub(String lhs, String rhs) : super(lhs, 'sub', rhs);
}

class Mul extends BinaryOperation {
  const Mul(String lhs, String rhs) : super(lhs, 'mul', rhs);
}

class Div extends BinaryOperation {
  const Div(String lhs, String rhs) : super(lhs, 'div', rhs);
}

class Mod extends BinaryOperation {
  const Mod(String lhs, String rhs) : super(lhs, 'mod', rhs);
}

abstract class BinaryLeftOperation extends Operation {
  final String lhs;
  final Operation rhs;
  final String op;

  const BinaryLeftOperation(this.lhs, this.op, this.rhs);

  @override
  String toString() {
    return '$lhs $op ($rhs)';
  }
}

class AddL extends BinaryLeftOperation {
  const AddL(String lhs, Operation rhs) : super(lhs, 'add', rhs);
}

class SubL extends BinaryLeftOperation {
  const SubL(String lhs, Operation rhs) : super(lhs, 'sub', rhs);
}

class MulL extends BinaryLeftOperation {
  const MulL(String lhs, Operation rhs) : super(lhs, 'mul', rhs);
}

class DivL extends BinaryLeftOperation {
  const DivL(String lhs, Operation rhs) : super(lhs, 'div', rhs);
}

class ModL extends BinaryLeftOperation {
  const ModL(String lhs, Operation rhs) : super(lhs, 'mod', rhs);
}

abstract class BinaryRightOperation extends Operation {
  final Operation lhs;
  final String rhs;
  final String op;

  const BinaryRightOperation(this.lhs, this.op, this.rhs);

  @override
  String toString() {
    return '($lhs) $op $rhs';
  }
}

class AddR extends BinaryRightOperation {
  const AddR(Operation lhs, String rhs) : super(lhs, 'add', rhs);
}

class SubR extends BinaryRightOperation {
  const SubR(Operation lhs, String rhs) : super(lhs, 'sub', rhs);
}

class MulR extends BinaryRightOperation {
  const MulR(Operation lhs, String rhs) : super(lhs, 'mul', rhs);
}

class DivR extends BinaryRightOperation {
  const DivR(Operation lhs, String rhs) : super(lhs, 'div', rhs);
}

class ModR extends BinaryRightOperation {
  const ModR(Operation lhs, String rhs) : super(lhs, 'mod', rhs);
}

// Functions
class SubString extends Operation {
  final String field;
  final int start;
  final int end;

  const SubString(this.field, this.start, this.end);

  @override
  String toString() {
    return 'substring($field,$start,$end)';
  }
}

class Year extends Operation {
  final String field;

  const Year(this.field);

  @override
  String toString() {
    return 'year($field)';
  }
}

// Compute
abstract class Compute {
  const Compute();
}

class Named extends Compute {
  final Nameable nameable;
  final String asName;

  const Named(this.nameable, this.asName);

  @override
  String toString() {
    return '($nameable as $asName)';
  }
}

// Select
class Select {
  final String field;
  final Params? params;

  const Select(this.field, [this.params]);

  @override
  String toString() {
    if (params != null) {
      return '$field(${buildParams(';', params!)})';
    } else {
      return field;
    }
  }
}

// https://docs.microsoft.com/pt-br/azure/devops/report/extend-analytics/odata-supported-features?view=azure-devops
class Params {
  final List<String> select1;
  final List<Select> select;
  final List<String> expand1;
  final List<Expand> expand;
  final List<String> orderby1;
  final List<Order> orderby;
  final List<String> compute1;
  final List<Compute> compute;
  final Predicate? filter;
  final Apply? apply;
  final bool? count;
  final int? skip;
  final int? top;

  const Params(
      {this.select1 = const [],
      this.select = const [],
      this.expand1 = const [],
      this.expand = const [],
      this.orderby1 = const [],
      this.orderby = const [],
      this.compute1 = const [],
      this.compute = const [],
      this.filter,
      this.apply,
      this.count,
      this.skip,
      this.top});

  @override
  String toString() {
    return buildParams('&', this);
  }
}

String buildParams(String separator, Params options) {
  final params = <String>[];
  final selects = [...options.select1, ...options.select.map(internalToString)];
  final expands = [...options.expand1, ...options.expand.map(internalToString)];
  final orderbys = [
    ...options.orderby1,
    ...options.orderby.map(internalToString)
  ];
  final computes = [
    ...options.compute1,
    ...options.compute.map(internalToString)
  ];

  if (options.count == true) params.add('\$count=true');
  if (options.skip != null) params.add('\$skip=${options.skip}');
  if (options.top != null) params.add('\$top=${options.top}');
  if (options.apply != null) params.add('\$apply=${options.apply}');
  if (options.filter != null) params.add('\$filter=${options.filter}');
  if (computes.isNotEmpty) params.add('\$compute=${computes.join(',')}');
  if (selects.isNotEmpty) params.add('\$select=${selects.join(',')}');
  if (expands.isNotEmpty) params.add('\$expand=${expands.join(',')}');
  if (orderbys.isNotEmpty) params.add('\$orderby=${orderbys.join(',')}');

  if (params.isEmpty) {
    return '';
  } else {
    return params.join(separator);
  }
}
