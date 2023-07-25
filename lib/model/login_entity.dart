import 'package:lanzhong/generated/json/base/json_field.dart';
import 'package:lanzhong/generated/json/login_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class LoginEntity {
	late String accessToken;
	late int yhid;
	@JSONField(name: "Pid")
	late int pid;

	LoginEntity();

	factory LoginEntity.fromJson(Map<String, dynamic> json) => $LoginEntityFromJson(json);

	Map<String, dynamic> toJson() => $LoginEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}