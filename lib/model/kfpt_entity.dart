import 'package:lanzhong/generated/json/base/json_field.dart';
import 'package:lanzhong/generated/json/kfpt_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class KfptEntity {
	late String kfpts;

	KfptEntity();

	factory KfptEntity.fromJson(Map<String, dynamic> json) => $KfptEntityFromJson(json);

	Map<String, dynamic> toJson() => $KfptEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}