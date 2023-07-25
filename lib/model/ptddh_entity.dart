import 'package:lanzhong/generated/json/base/json_field.dart';
import 'package:lanzhong/generated/json/ptddh_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class PtddhEntity {
	late String ptddh;

	PtddhEntity();

	factory PtddhEntity.fromJson(Map<String, dynamic> json) => $PtddhEntityFromJson(json);

	Map<String, dynamic> toJson() => $PtddhEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}