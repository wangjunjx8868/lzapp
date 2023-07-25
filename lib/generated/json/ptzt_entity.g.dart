import 'package:lanzhong/generated/json/base/json_convert_content.dart';
import 'package:lanzhong/model/ptzt_entity.dart';

PtztEntity $PtztEntityFromJson(Map<String, dynamic> json) {
	final PtztEntity ptztEntity = PtztEntity();
	final String? ddzt = jsonConvert.convert<String>(json['ddzt']);
	if (ddzt != null) {
		ptztEntity.ddzt = ddzt;
	}
	final double? sl = jsonConvert.convert<double>(json['sl']);
	if (sl != null) {
		ptztEntity.sl = sl;
	}
	return ptztEntity;
}

Map<String, dynamic> $PtztEntityToJson(PtztEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['ddzt'] = entity.ddzt;
	data['sl'] = entity.sl;
	return data;
}