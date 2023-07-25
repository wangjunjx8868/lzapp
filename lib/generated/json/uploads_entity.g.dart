import 'package:lanzhong/generated/json/base/json_convert_content.dart';
import 'package:lanzhong/model/uploads_entity.dart';

UploadsEntity $UploadsEntityFromJson(Map<String, dynamic> json) {
	final UploadsEntity uploadsEntity = UploadsEntity();
	final int? code = jsonConvert.convert<int>(json['code']);
	if (code != null) {
		uploadsEntity.code = code;
	}
	final String? message = jsonConvert.convert<String>(json['message']);
	if (message != null) {
		uploadsEntity.message = message;
	}
	final List<UploadsData>? data = jsonConvert.convertListNotNull<UploadsData>(json['data']);
	if (data != null) {
		uploadsEntity.data = data;
	}
	final String? errStr = jsonConvert.convert<String>(json['errStr']);
	if (errStr != null) {
		uploadsEntity.errStr = errStr;
	}
	return uploadsEntity;
}

Map<String, dynamic> $UploadsEntityToJson(UploadsEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['code'] = entity.code;
	data['message'] = entity.message;
	data['data'] =  entity.data.map((v) => v.toJson()).toList();
	data['errStr'] = entity.errStr;
	return data;
}

UploadsData $UploadsDataFromJson(Map<String, dynamic> json) {
	final UploadsData uploadsData = UploadsData();
	final String? nickName = jsonConvert.convert<String>(json['nickName']);
	if (nickName != null) {
		uploadsData.nickName = nickName;
	}
	final String? createTime = jsonConvert.convert<String>(json['createTime']);
	if (createTime != null) {
		uploadsData.createTime = createTime;
	}
	final String? msgStr = jsonConvert.convert<String>(json['msgStr']);
	if (msgStr != null) {
		uploadsData.msgStr = msgStr;
	}
	final String? remark = jsonConvert.convert<String>(json['remark']);
	if (remark != null) {
		uploadsData.remark = remark;
	}
	return uploadsData;
}

Map<String, dynamic> $UploadsDataToJson(UploadsData entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['nickName'] = entity.nickName;
	data['createTime'] = entity.createTime;
	data['msgStr'] = entity.msgStr;
	data['remark'] = entity.remark;
	return data;
}