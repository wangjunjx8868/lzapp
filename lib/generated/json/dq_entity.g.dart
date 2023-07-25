import 'package:lanzhong/generated/json/base/json_convert_content.dart';
import 'package:lanzhong/model/dq_entity.dart';

DqEntity $DqEntityFromJson(Map<String, dynamic> json) {
	final DqEntity dqEntity = DqEntity();
	final List<DqDllxs>? dllxs = jsonConvert.convertListNotNull<DqDllxs>(json['dllxs']);
	if (dllxs != null) {
		dqEntity.dllxs = dllxs;
	}
	final List<DqServers>? servers = jsonConvert.convertListNotNull<DqServers>(json['servers']);
	if (servers != null) {
		dqEntity.servers = servers;
	}
	final String? zdygs = jsonConvert.convert<String>(json['zdygs']);
	if (zdygs != null) {
		dqEntity.zdygs = zdygs;
	}
	return dqEntity;
}

Map<String, dynamic> $DqEntityToJson(DqEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['dllxs'] =  entity.dllxs.map((v) => v.toJson()).toList();
	data['servers'] =  entity.servers.map((v) => v.toJson()).toList();
	data['zdygs'] = entity.zdygs;
	return data;
}

DqDllxs $DqDllxsFromJson(Map<String, dynamic> json) {
	final DqDllxs dqDllxs = DqDllxs();
	final int? id = jsonConvert.convert<int>(json['Id']);
	if (id != null) {
		dqDllxs.id = id;
	}
	final String? dllx = jsonConvert.convert<String>(json['dllx']);
	if (dllx != null) {
		dqDllxs.dllx = dllx;
	}
	final int? gid = jsonConvert.convert<int>(json['gid']);
	if (gid != null) {
		dqDllxs.gid = gid;
	}
	final String? lrrq = jsonConvert.convert<String>(json['lrrq']);
	if (lrrq != null) {
		dqDllxs.lrrq = lrrq;
	}
	final String? kfpts = jsonConvert.convert<String>(json['kfpts']);
	if (kfpts != null) {
		dqDllxs.kfpts = kfpts;
	}
	final String? zdywz = jsonConvert.convert<String>(json['zdywz']);
	if (zdywz != null) {
		dqDllxs.zdywz = zdywz;
	}
	return dqDllxs;
}

Map<String, dynamic> $DqDllxsToJson(DqDllxs entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['Id'] = entity.id;
	data['dllx'] = entity.dllx;
	data['gid'] = entity.gid;
	data['lrrq'] = entity.lrrq;
	data['kfpts'] = entity.kfpts;
	data['zdywz'] = entity.zdywz;
	return data;
}

DqServers $DqServersFromJson(Map<String, dynamic> json) {
	final DqServers dqServers = DqServers();
	final int? id = jsonConvert.convert<int>(json['Id']);
	if (id != null) {
		dqServers.id = id;
	}
	final int? mGameNameId = jsonConvert.convert<int>(json['MGameNameId']);
	if (mGameNameId != null) {
		dqServers.mGameNameId = mGameNameId;
	}
	final String? gameServerName = jsonConvert.convert<String>(json['GameServerName']);
	if (gameServerName != null) {
		dqServers.gameServerName = gameServerName;
	}
	return dqServers;
}

Map<String, dynamic> $DqServersToJson(DqServers entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['Id'] = entity.id;
	data['MGameNameId'] = entity.mGameNameId;
	data['GameServerName'] = entity.gameServerName;
	return data;
}