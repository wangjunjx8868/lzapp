import 'package:lanzhong/generated/json/base/json_field.dart';
import 'package:lanzhong/generated/json/chat_message_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class ChatMessageEntity {
	@JSONField(name: "Id")
	late int id;
	late String ygzh;
	late String ygnc;
	late String os;
	ChatMessageEntity();

	factory ChatMessageEntity.fromJson(Map<String, dynamic> json) => $ChatMessageEntityFromJson(json);

	Map<String, dynamic> toJson() => $ChatMessageEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}