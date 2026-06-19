import 'package:flutter_test/flutter_test.dart';
import 'package:peblo_story_buddy/models/quiz_question.dart';

void main() {
  test('QuizQuestion parses backend-style payload', () {
    final question = QuizQuestion.fromJson({
      'question': 'Pick a colour',
      'options': ['Red', 'Blue', 'Green'],
      'answer': 'Blue',
    });

    expect(question.question, 'Pick a colour');
    expect(question.options.length, 3);
    expect(question.isCorrect('Blue'), isTrue);
    expect(question.isCorrect('Red'), isFalse);
  });

  test('QuizQuestion rejects answer not present in options', () {
    expect(
      () => QuizQuestion.fromJson({
        'question': 'Pick a colour',
        'options': ['Red', 'Green'],
        'answer': 'Blue',
      }),
      throwsFormatException,
    );
  });
}
