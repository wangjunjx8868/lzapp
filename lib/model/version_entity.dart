import 'package:lanzhong/generated/json/base/json_field.dart';
import 'package:lanzhong/generated/json/version_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class VersionEntity {
	@JSONField(name: "VersionCode")
	late int versionCode;
	@JSONField(name: "VersionContent")
	late String versionContent;
	@JSONField(name: "VersionName")
	late String versionName;
	VersionEntity();

	factory VersionEntity.fromJson(Map<String, dynamic> json) => $VersionEntityFromJson(json);

	Map<String, dynamic> toJson() => $VersionEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}