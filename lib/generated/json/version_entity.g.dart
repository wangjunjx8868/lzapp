import 'package:lanzhong/generated/json/base/json_convert_content.dart';
import 'package:lanzhong/model/version_entity.dart';

VersionEntity $VersionEntityFromJson(Map<String, dynamic> json) {
	final VersionEntity versionEntity = VersionEntity();
	final int? versionCode = jsonConvert.convert<int>(json['VersionCode']);
	if (versionCode != null) {
		versionEntity.versionCode = versionCode;
	}
	final String? versionContent = jsonConvert.convert<String>(json['VersionContent']);
	if (versionContent != null) {
		versionEntity.versionContent = versionContent;
	}
	final String? versionName = jsonConvert.convert<String>(json['VersionName']);
	if (versionName != null) {
		versionEntity.versionName = versionName;
	}
	return versionEntity;
}

Map<String, dynamic> $VersionEntityToJson(VersionEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['VersionCode'] = entity.versionCode;
	data['VersionContent'] = entity.versionContent;
	data['VersionName'] = entity.versionName;
	return data;
}