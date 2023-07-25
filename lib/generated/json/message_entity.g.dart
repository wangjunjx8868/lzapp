import 'package:lanzhong/generated/json/base/json_convert_content.dart';
import 'package:lanzhong/model/message_entity.dart';

MessageEntity $MessageEntityFromJson(Map<String, dynamic> json) {
	final MessageEntity messageEntity = MessageEntity();
	final String? nickName = jsonConvert.convert<String>(json['nickName']);
	if (nickName != null) {
		messageEntity.nickName = nickName;
	}
	final String? createTime = jsonConvert.convert<String>(json['createTime']);
	if (createTime != null) {
		messageEntity.createTime = createTime;
	}
	final String? msgStr = jsonConvert.convert<String>(json['msgStr']);
	if (msgStr != null) {
		messageEntity.msgStr = msgStr;
	}
	final String? remark = jsonConvert.convert<String>(json['remark']);
	if (remark != null) {
		messageEntity.remark = remark;
	}
	return messageEntity;
}

Map<String, dynamic> $MessageEntityToJson(MessageEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['nickName'] = entity.nickName;
	data['createTime'] = entity.createTime;
	data['msgStr'] = entity.msgStr;
	data['remark'] = entity.remark;
	return data;
}