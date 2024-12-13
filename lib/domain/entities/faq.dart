import 'package:expense_app/domain/entities/meta.dart';

class FaqResponse {
  final List<Faq> data;
  final Meta meta;

  FaqResponse({required this.data, required this.meta});

  factory FaqResponse.fromJson(Map<String, dynamic> map) {
    return FaqResponse(
      data: List.from(map["data"].map((x) => Faq.fromJson(x))),
      meta: Meta.fromJson(map["meta"]),
    );
  }
}

class Faq {
  final String faqQuestionKh;
  final String faqQuestionEn;
  final String faqAnswerKh;
  final String faqAnswerEn;
  final String? faqLink;

  Faq({
    required this.faqQuestionKh,
    required this.faqQuestionEn,
    required this.faqAnswerKh,
    required this.faqAnswerEn,
    this.faqLink,
  });

  factory Faq.fromJson(Map<String, dynamic> map) {
    return Faq(
      faqQuestionKh: map["questionKh"],
      faqQuestionEn: map["questionEn"],
      faqAnswerKh: map["answerKh"],
      faqAnswerEn: map["answerEn"],
      faqLink: map["link"],
    );
  }
}
