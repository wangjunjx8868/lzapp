import 'package:lanzhong/generated/json/base/json_field.dart';
import 'package:lanzhong/generated/json/uploads_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class UploadsEntity {
	late int code;
	late String message;
	late List<UploadsData> data;
	late String errStr="";
	UploadsEntity();

	factory UploadsEntity.fromJson(Map<String, dynamic> json) => $UploadsEntityFromJson(json);

	Map<String, dynamic> toJson() => $UploadsEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class UploadsData {
	late String nickName;
	late String createTime;
	late String msgStr;
	late String remark;

	UploadsData();

	factory UploadsData.fromJson(Map<String, dynamic> json) => $UploadsDataFromJson(json);

	Map<String, dynamic> toJson() => $UploadsDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}