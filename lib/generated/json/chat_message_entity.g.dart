import 'package:lanzhong/generated/json/base/json_convert_content.dart';
import 'package:lanzhong/model/chat_message_entity.dart';

ChatMessageEntity $ChatMessageEntityFromJson(Map<String, dynamic> json) {
	final ChatMessageEntity chatMessageEntity = ChatMessageEntity();
	final int? id = jsonConvert.convert<int>(json['Id']);
	if (id != null) {
		chatMessageEntity.id = id;
	}
	final String? ygzh = jsonConvert.convert<String>(json['ygzh']);
	if (ygzh != null) {
		chatMessageEntity.ygzh = ygzh;
	}
	final String? ygnc = jsonConvert.convert<String>(json['ygnc']);
	if (ygnc != null) {
		chatMessageEntity.ygnc = ygnc;
	}
	final String? os = jsonConvert.convert<String>(json['os']);
	if (os != null) {
		chatMessageEntity.os = os;
	}
	return chatMessageEntity;
}

Map<String, dynamic> $ChatMessageEntityToJson(ChatMessageEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['Id'] = entity.id;
	data['ygzh'] = entity.ygzh;
	data['ygnc'] = entity.ygnc;
	data['os'] = entity.os;
	return data;
}