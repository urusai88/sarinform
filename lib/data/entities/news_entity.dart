import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/domain.dart';

part 'news_entity.g.dart';

@JsonSerializable(createToJson: false)
@HiveType(typeId: 1)
class NewsEntity {
  const NewsEntity({
    required this.id,
    required this.img,
    required this.date,
    required this.title,
    this.text,
  });

  factory NewsEntity.fromJson(Map<String, dynamic> json) => _$NewsEntityFromJson(json);

  @JsonKey(fromJson: int.parse)
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String img;
  @JsonKey(fromJson: AppUtils.parseRawDateTime)
  @HiveField(2)
  final DateTime date;
  @HiveField(3)
  final String title;
  @HiveField(4)
  final String? text;
}
