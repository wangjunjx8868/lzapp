import 'package:lanzhong/generated/json/base/json_convert_content.dart';
import 'package:lanzhong/model/insert_entity.dart';

InsertEntity $InsertEntityFromJson(Map<String, dynamic> json) {
	final InsertEntity insertEntity = InsertEntity();
	final int? insertid = jsonConvert.convert<int>(json['insertid']);
	if (insertid != null) {
		insertEntity.insertid = insertid;
	}
	return insertEntity;
}

Map<String, dynamic> $InsertEntityToJson(InsertEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['insertid'] = entity.insertid;
	return data;
}