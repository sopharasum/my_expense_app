class DayOfWeek {
  final String en;
  final String kh;
  bool? selected;

  DayOfWeek({
    required this.en,
    required this.kh,
    this.selected = false,
  });

  factory DayOfWeek.fromJson(Map<String, dynamic> map) {
    return DayOfWeek(
      en: map["en"],
      kh: map["kh"],
      selected: map["selected"],
    );
  }
}
