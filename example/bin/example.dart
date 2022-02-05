import 'visual_examples_data.dart';
import 'visual_examples_exception.dart';
import 'visual_examples_url.dart';

void main(List<String> args) async {
  await urlVisualExamples();
  await dataVisualExample();
  exceptionVisualTest();
}
