import 'package:expense_app/domain/entities/category.dart';
import 'package:expense_app/domain/entities/meta.dart';

class EntryResponse {
  final List<Entry> data;
  final Meta meta;

  EntryResponse({required this.data, required this.meta});

  factory EntryResponse.fromJson(Map<String, dynamic> map) {
    return EntryResponse(
      data: List<Entry>.from(map["data"].map((x) => Entry.fromJson(x))),
      meta: Meta.fromJson(map["meta"]),
    );
  }
}

class Entry {
  final int? entryId;
  final Category? entryCategory;
  final double? entryAmount;
  final String? entryCurrency;
  final String? entryDateTime;
  final String? entryRemark;

  Entry({
    this.entryId,
    this.entryCategory,
    this.entryAmount,
    this.entryCurrency,
    this.entryDateTime,
    this.entryRemark,
  });

  factory Entry.fromJson(Map<String, dynamic> map) {
    return Entry(
      entryId: map["id"],
      entryCategory: Category.fromJson(map["category"]),
      entryAmount: map["amount"].toDouble(),
      entryCurrency: map["currency"],
      entryDateTime: map["createdAt"],
      entryRemark: map["remark"],
    );
  }
}
