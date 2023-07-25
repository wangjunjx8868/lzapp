import 'package:lanzhong/generated/json/base/json_field.dart';
import 'package:lanzhong/generated/json/message_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class MessageEntity {
	late String nickName;
	late String createTime;
	late String msgStr;
	late String remark;
	MessageEntity();

	factory MessageEntity.fromJson(Map<String, dynamic> json) => $MessageEntityFromJson(json);

	Map<String, dynamic> toJson() => $MessageEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}