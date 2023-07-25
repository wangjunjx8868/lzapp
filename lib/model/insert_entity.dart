import 'package:lanzhong/generated/json/base/json_field.dart';
import 'package:lanzhong/generated/json/insert_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class InsertEntity {
	late int insertid;

	InsertEntity();

	factory InsertEntity.fromJson(Map<String, dynamic> json) => $InsertEntityFromJson(json);

	Map<String, dynamic> toJson() => $InsertEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}