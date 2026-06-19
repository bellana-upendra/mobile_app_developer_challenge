class QuizQuestion {
  const QuizQuestion({
    required this.question,
    required this.options,
    required this.answer,
  });

  final String question;
  final List<String> options;
  final String answer;

  factory QuizQuestion.fromJson(Map<String, Object?> json) {
    final rawQuestion = json['question'];
    final rawOptions = json['options'];
    final rawAnswer = json['answer'];

    if (rawQuestion is! String || rawQuestion.trim().isEmpty) {
      throw const FormatException('Quiz question is missing or invalid.');
    }

    if (rawOptions is! List || rawOptions.isEmpty) {
      throw const FormatException('Quiz options are missing or invalid.');
    }

    if (rawAnswer is! String || rawAnswer.trim().isEmpty) {
      throw const FormatException('Quiz answer is missing or invalid.');
    }

    final parsedOptions = rawOptions.map((option) => option.toString()).toList();

    if (!parsedOptions.contains(rawAnswer)) {
      throw const FormatException('Quiz answer must exist inside options.');
    }

    return QuizQuestion(
      question: rawQuestion,
      options: parsedOptions,
      answer: rawAnswer,
    );
  }

  bool isCorrect(String option) => option.trim() == answer.trim();
}
