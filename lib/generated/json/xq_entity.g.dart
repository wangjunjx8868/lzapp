import 'package:lanzhong/generated/json/base/json_convert_content.dart';
import 'package:lanzhong/model/xq_entity.dart';

XqEntity $XqEntityFromJson(Map<String, dynamic> json) {
	final XqEntity xqEntity = XqEntity();
	final List<XqAreas>? areas = jsonConvert.convertListNotNull<XqAreas>(json['areas']);
	if (areas != null) {
		xqEntity.areas = areas;
	}
	return xqEntity;
}

Map<String, dynamic> $XqEntityToJson(XqEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['areas'] =  entity.areas.map((v) => v.toJson()).toList();
	return data;
}

XqAreas $XqAreasFromJson(Map<String, dynamic> json) {
	final XqAreas xqAreas = XqAreas();
	final int? id = jsonConvert.convert<int>(json['Id']);
	if (id != null) {
		xqAreas.id = id;
	}
	final String? gameAreaName = jsonConvert.convert<String>(json['GameAreaName']);
	if (gameAreaName != null) {
		xqAreas.gameAreaName = gameAreaName;
	}
	return xqAreas;
}

Map<String, dynamic> $XqAreasToJson(XqAreas entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['Id'] = entity.id;
	data['GameAreaName'] = entity.gameAreaName;
	return data;
}