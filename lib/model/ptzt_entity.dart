import 'package:lanzhong/generated/json/base/json_field.dart';
import 'package:lanzhong/generated/json/ptzt_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class PtztEntity {
	late String ddzt;
	late double sl;

	PtztEntity();

	factory PtztEntity.fromJson(Map<String, dynamic> json) => $PtztEntityFromJson(json);

	Map<String, dynamic> toJson() => $PtztEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}