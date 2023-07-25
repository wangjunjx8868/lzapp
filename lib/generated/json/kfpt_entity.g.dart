import 'package:lanzhong/generated/json/base/json_convert_content.dart';
import 'package:lanzhong/model/kfpt_entity.dart';

KfptEntity $KfptEntityFromJson(Map<String, dynamic> json) {
	final KfptEntity kfptEntity = KfptEntity();
	final String? kfpts = jsonConvert.convert<String>(json['kfpts']);
	if (kfpts != null) {
		kfptEntity.kfpts = kfpts;
	}
	return kfptEntity;
}

Map<String, dynamic> $KfptEntityToJson(KfptEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['kfpts'] = entity.kfpts;
	return data;
}