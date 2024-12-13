class Meta {
  final int page;
  final int limit;
  final int total;

  Meta({required this.page, required this.limit, required this.total});

  factory Meta.fromJson(Map<String, dynamic> map) {
    return Meta(
      page: map["page"],
      limit: map["limit"],
      total: map["total"],
    );
  }
}
