import 'package:lanzhong/generated/json/base/json_field.dart';
import 'package:lanzhong/generated/json/dq_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class DqEntity {
	late List<DqDllxs> dllxs;
	late List<DqServers> servers;
	late String zdygs;

	DqEntity();

	factory DqEntity.fromJson(Map<String, dynamic> json) => $DqEntityFromJson(json);

	Map<String, dynamic> toJson() => $DqEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class DqDllxs {
	@JSONField(name: "Id")
	late int id;
	late String dllx;
	late int gid;
	late String lrrq;
	late String kfpts;
	late String zdywz;

	DqDllxs();

	factory DqDllxs.fromJson(Map<String, dynamic> json) => $DqDllxsFromJson(json);

	Map<String, dynamic> toJson() => $DqDllxsToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class DqServers {
	@JSONField(name: "Id")
	late int id;
	@JSONField(name: "MGameNameId")
	late int mGameNameId;
	@JSONField(name: "GameServerName")
	late String gameServerName;

	DqServers();

	factory DqServers.fromJson(Map<String, dynamic> json) => $DqServersFromJson(json);

	Map<String, dynamic> toJson() => $DqServersToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}