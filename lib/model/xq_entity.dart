import 'package:lanzhong/generated/json/base/json_field.dart';
import 'package:lanzhong/generated/json/xq_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class XqEntity {
	late List<XqAreas> areas;

	XqEntity();

	factory XqEntity.fromJson(Map<String, dynamic> json) => $XqEntityFromJson(json);

	Map<String, dynamic> toJson() => $XqEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class XqAreas {
	@JSONField(name: "Id")
	late int id;
	@JSONField(name: "GameAreaName")
	late String gameAreaName;

	XqAreas();

	factory XqAreas.fromJson(Map<String, dynamic> json) => $XqAreasFromJson(json);

	Map<String, dynamic> toJson() => $XqAreasToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}