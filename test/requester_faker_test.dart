// A simple reinforcement to keep in mind what to expect when running on ODataSource

import 'dart:convert';

import 'package:test/test.dart';

import 'requester_fake.dart';

const data = <String, int>{'x': 10};
const url = 'url';

void testSuccessGet() async {
  const statusCode = 200;
  final response =
      await RequesterFaker(data: data, statusCode: statusCode).httpGet(url);
  expect(url, response.url);
  expect(response.data, isNotNull);
  expect(data, jsonDecode(response.data!));
  expect(statusCode, response.statusCode);
}

void testSuccessPost() async {
  const statusCode = 200;
  final response = await RequesterFaker(data: data, statusCode: statusCode)
      .httpPost(url, data);
  expect(url, response.url);
  expect(response.data, isNotNull);
  expect(data, jsonDecode(response.data!));
  expect(statusCode, response.statusCode);
}

void testSuccessPut() async {
  const statusCode = 204;
  final response =
      await RequesterFaker(statusCode: statusCode).httpPut(url, null);
  expect(url, response.url);
  expect(statusCode, response.statusCode);
  expect(response.error, isNull);
  expect(response.data, isNull);
}

void testSuccessPatch() async {
  const statusCode = 204;
  final response =
      await RequesterFaker(statusCode: statusCode).httpPatch(url, null);
  expect(url, response.url);
  expect(statusCode, response.statusCode);
  expect(response.error, isNull);
  expect(response.data, isNull);
}

void testSuccessDelete() async {
  const statusCode = 204;
  final response = await RequesterFaker(statusCode: statusCode).httpDelete(url);
  expect(url, response.url);
  expect(statusCode, response.statusCode);
  expect(response.error, isNull);
  expect(response.data, isNull);
}

void main() {
  test('#1 test success fake request GET', testSuccessGet);
  test('#2 test success fake request POST', testSuccessPost);
  test('#3 test success fake request PUT', testSuccessPut);
  test('#4 test success fake request PATCH', testSuccessPatch);
  test('#5 test success fake request DELETE', testSuccessDelete);
}
