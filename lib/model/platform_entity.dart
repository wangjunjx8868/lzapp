import 'package:lanzhong/generated/json/base/json_field.dart';
import 'package:lanzhong/generated/json/platform_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class PlatformEntity {
	@JSONField(name: "Id")
	late int id;
	@JSONField(name: "PlatformName")
	late String platformName;
	@JSONField(name: "PlatformAccount")
	late String platformAccount;
	@JSONField(name: "PlatformNick")
	late String platformNick;
	@JSONField(name: "PlatformLogo")
	late String platformLogo;

	@JSONField(name: "PayPwd")
	late String payPwd;

	@JSONField(name: "IsSend")
	late String isSend;

	late int yhid;

	PlatformEntity();

	factory PlatformEntity.fromJson(Map<String, dynamic> json) => $PlatformEntityFromJson(json);

	Map<String, dynamic> toJson() => $PlatformEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}