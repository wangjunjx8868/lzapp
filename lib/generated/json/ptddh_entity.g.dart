import 'package:lanzhong/generated/json/base/json_convert_content.dart';
import 'package:lanzhong/model/ptddh_entity.dart';

PtddhEntity $PtddhEntityFromJson(Map<String, dynamic> json) {
	final PtddhEntity ptddhEntity = PtddhEntity();
	final String? ptddh = jsonConvert.convert<String>(json['ptddh']);
	if (ptddh != null) {
		ptddhEntity.ptddh = ptddh;
	}
	return ptddhEntity;
}

Map<String, dynamic> $PtddhEntityToJson(PtddhEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['ptddh'] = entity.ptddh;
	return data;
}