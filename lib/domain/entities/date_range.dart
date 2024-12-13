class DateRange {
  final String label;
  final String start;
  final String end;
  final bool? isCustom;

  DateRange({
    required this.label,
    required this.start,
    required this.end,
    this.isCustom,
  });
}
