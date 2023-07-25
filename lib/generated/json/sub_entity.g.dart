import 'package:lanzhong/generated/json/base/json_convert_content.dart';
import 'package:lanzhong/model/sub_entity.dart';

SubEntity $SubEntityFromJson(Map<String, dynamic> json) {
	final SubEntity subEntity = SubEntity();
	final int? id = jsonConvert.convert<int>(json['Id']);
	if (id != null) {
		subEntity.id = id;
	}
	final String? dllx = jsonConvert.convert<String>(json['dllx']);
	if (dllx != null) {
		subEntity.dllx = dllx;
	}
	final int? gid = jsonConvert.convert<int>(json['gid']);
	if (gid != null) {
		subEntity.gid = gid;
	}
	final String? lrrq = jsonConvert.convert<String>(json['lrrq']);
	if (lrrq != null) {
		subEntity.lrrq = lrrq;
	}
	final String? kfpts = jsonConvert.convert<String>(json['kfpts']);
	if (kfpts != null) {
		subEntity.kfpts = kfpts;
	}
	final String? zdywz = jsonConvert.convert<String>(json['zdywz']);
	if (zdywz != null) {
		subEntity.zdywz = zdywz;
	}
	return subEntity;
}

Map<String, dynamic> $SubEntityToJson(SubEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['Id'] = entity.id;
	data['dllx'] = entity.dllx;
	data['gid'] = entity.gid;
	data['lrrq'] = entity.lrrq;
	data['kfpts'] = entity.kfpts;
	data['zdywz'] = entity.zdywz;
	return data;
}