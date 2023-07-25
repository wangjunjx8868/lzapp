import 'package:lanzhong/generated/json/base/json_field.dart';
import 'package:lanzhong/generated/json/sub_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class SubEntity {
	@JSONField(name: "Id")
	late int id;
	late String dllx;
	late int gid;
	late String lrrq;
	late String kfpts;
	late String zdywz;

	SubEntity();

	factory SubEntity.fromJson(Map<String, dynamic> json) => $SubEntityFromJson(json);

	Map<String, dynamic> toJson() => $SubEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}