import 'package:lanzhong/generated/json/base/json_convert_content.dart';
import 'package:lanzhong/model/platform_entity.dart';

PlatformEntity $PlatformEntityFromJson(Map<String, dynamic> json) {
	final PlatformEntity platformEntity = PlatformEntity();
	final int? id = jsonConvert.convert<int>(json['Id']);
	if (id != null) {
		platformEntity.id = id;
	}
	final String? platformName = jsonConvert.convert<String>(json['PlatformName']);
	if (platformName != null) {
		platformEntity.platformName = platformName;
	}
	final String? platformAccount = jsonConvert.convert<String>(json['PlatformAccount']);
	if (platformAccount != null) {
		platformEntity.platformAccount = platformAccount;
	}
	final String? platformNick = jsonConvert.convert<String>(json['PlatformNick']);
	if (platformNick != null) {
		platformEntity.platformNick = platformNick;
	}
	final String? platformLogo = jsonConvert.convert<String>(json['PlatformLogo']);
	if (platformLogo != null) {
		platformEntity.platformLogo = platformLogo;
	}
	final String? payPwd = jsonConvert.convert<String>(json['PayPwd']);
	if (payPwd != null) {
		platformEntity.payPwd = payPwd;
	}
	final String? isSend = jsonConvert.convert<String>(json['IsSend']);
	if (isSend != null) {
		platformEntity.isSend = isSend;
	}
	final int? yhid = jsonConvert.convert<int>(json['yhid']);
	if (yhid != null) {
		platformEntity.yhid = yhid;
	}
	return platformEntity;
}

Map<String, dynamic> $PlatformEntityToJson(PlatformEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['Id'] = entity.id;
	data['PlatformName'] = entity.platformName;
	data['PlatformAccount'] = entity.platformAccount;
	data['PlatformNick'] = entity.platformNick;
	data['PlatformLogo'] = entity.platformLogo;
	data['PayPwd'] = entity.payPwd;
	data['IsSend'] = entity.isSend;
	data['yhid'] = entity.yhid;
	return data;
}