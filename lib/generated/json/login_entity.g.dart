import 'package:lanzhong/generated/json/base/json_convert_content.dart';
import 'package:lanzhong/model/login_entity.dart';

LoginEntity $LoginEntityFromJson(Map<String, dynamic> json) {
	final LoginEntity loginEntity = LoginEntity();
	final String? accessToken = jsonConvert.convert<String>(json['accessToken']);
	if (accessToken != null) {
		loginEntity.accessToken = accessToken;
	}
	final int? yhid = jsonConvert.convert<int>(json['yhid']);
	if (yhid != null) {
		loginEntity.yhid = yhid;
	}
	final int? pid = jsonConvert.convert<int>(json['Pid']);
	if (pid != null) {
		loginEntity.pid = pid;
	}
	return loginEntity;
}

Map<String, dynamic> $LoginEntityToJson(LoginEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['accessToken'] = entity.accessToken;
	data['yhid'] = entity.yhid;
	data['Pid'] = entity.pid;
	return data;
}