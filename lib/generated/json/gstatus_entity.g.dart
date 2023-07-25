import 'package:lanzhong/generated/json/base/json_convert_content.dart';
import 'package:lanzhong/model/gstatus_entity.dart';

GstatusEntity $GstatusEntityFromJson(Map<String, dynamic> json) {
	final GstatusEntity gstatusEntity = GstatusEntity();
	final List<GstatusGames>? games = jsonConvert.convertListNotNull<GstatusGames>(json['games']);
	if (games != null) {
		gstatusEntity.games = games;
	}
	final List<GstatusZts>? zts = jsonConvert.convertListNotNull<GstatusZts>(json['zts']);
	if (zts != null) {
		gstatusEntity.zts = zts;
	}
	return gstatusEntity;
}

Map<String, dynamic> $GstatusEntityToJson(GstatusEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['games'] =  entity.games.map((v) => v.toJson()).toList();
	data['zts'] =  entity.zts.map((v) => v.toJson()).toList();
	return data;
}

GstatusGames $GstatusGamesFromJson(Map<String, dynamic> json) {
	final GstatusGames gstatusGames = GstatusGames();
	final int? id = jsonConvert.convert<int>(json['Id']);
	if (id != null) {
		gstatusGames.id = id;
	}
	final String? yxmc = jsonConvert.convert<String>(json['yxmc']);
	if (yxmc != null) {
		gstatusGames.yxmc = yxmc;
	}
	final dynamic kfpt = jsonConvert.convert<dynamic>(json['kfpt']);
	if (kfpt != null) {
		gstatusGames.kfpt = kfpt;
	}
	return gstatusGames;
}

Map<String, dynamic> $GstatusGamesToJson(GstatusGames entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['Id'] = entity.id;
	data['yxmc'] = entity.yxmc;
	data['kfpt'] = entity.kfpt;
	return data;
}

GstatusZts $GstatusZtsFromJson(Map<String, dynamic> json) {
	final GstatusZts gstatusZts = GstatusZts();
	final String? ddzt = jsonConvert.convert<String>(json['ddzt']);
	if (ddzt != null) {
		gstatusZts.ddzt = ddzt;
	}
	final int? sl = jsonConvert.convert<int>(json['sl']);
	if (sl != null) {
		gstatusZts.sl = sl;
	}
	return gstatusZts;
}

Map<String, dynamic> $GstatusZtsToJson(GstatusZts entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['ddzt'] = entity.ddzt;
	data['sl'] = entity.sl;
	return data;
}