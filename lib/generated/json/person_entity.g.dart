import 'package:lanzhong/generated/json/base/json_convert_content.dart';
import 'package:lanzhong/model/person_entity.dart';

PersonEntity $PersonEntityFromJson(Map<String, dynamic> json) {
	final PersonEntity personEntity = PersonEntity();
	final int? yhid = jsonConvert.convert<int>(json['yhid']);
	if (yhid != null) {
		personEntity.yhid = yhid;
	}
	final String? ygnc = jsonConvert.convert<String>(json['ygnc']);
	if (ygnc != null) {
		personEntity.ygnc = ygnc;
	}
	final double? price = jsonConvert.convert<double>(json['Price']);
	if (price != null) {
		personEntity.price = price;
	}
	final int? dxCount = jsonConvert.convert<int>(json['DxCount']);
	if (dxCount != null) {
		personEntity.dxCount = dxCount;
	}
	final List<PersonGames>? games = jsonConvert.convertListNotNull<PersonGames>(json['games']);
	if (games != null) {
		personEntity.games = games;
	}
	final List<PersonPlats>? plats = jsonConvert.convertListNotNull<PersonPlats>(json['plats']);
	if (plats != null) {
		personEntity.plats = plats;
	}
	return personEntity;
}

Map<String, dynamic> $PersonEntityToJson(PersonEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['yhid'] = entity.yhid;
	data['ygnc'] = entity.ygnc;
	data['Price'] = entity.price;
	data['DxCount'] = entity.dxCount;
	data['games'] =  entity.games.map((v) => v.toJson()).toList();
	data['plats'] =  entity.plats.map((v) => v.toJson()).toList();
	return data;
}

PersonGames $PersonGamesFromJson(Map<String, dynamic> json) {
	final PersonGames personGames = PersonGames();
	final int? id = jsonConvert.convert<int>(json['Id']);
	if (id != null) {
		personGames.id = id;
	}
	final String? yxmc = jsonConvert.convert<String>(json['yxmc']);
	if (yxmc != null) {
		personGames.yxmc = yxmc;
	}
	final String? kfpt = jsonConvert.convert<String>(json['kfpt']);
	if (kfpt != null) {
		personGames.kfpt = kfpt;
	}
	return personGames;
}

Map<String, dynamic> $PersonGamesToJson(PersonGames entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['Id'] = entity.id;
	data['yxmc'] = entity.yxmc;
	data['kfpt'] = entity.kfpt;
	return data;
}

PersonPlats $PersonPlatsFromJson(Map<String, dynamic> json) {
	final PersonPlats personPlats = PersonPlats();
	final int? id = jsonConvert.convert<int>(json['Id']);
	if (id != null) {
		personPlats.id = id;
	}
	final String? platformName = jsonConvert.convert<String>(json['PlatformName']);
	if (platformName != null) {
		personPlats.platformName = platformName;
	}
	final String? platformPicture = jsonConvert.convert<String>(json['PlatformPicture']);
	if (platformPicture != null) {
		personPlats.platformPicture = platformPicture;
	}
	final String? platformAccount = jsonConvert.convert<String>(json['PlatformAccount']);
	if (platformAccount != null) {
		personPlats.platformAccount = platformAccount;
	}
	final String? platformNick = jsonConvert.convert<String>(json['PlatformNick']);
	if (platformNick != null) {
		personPlats.platformNick = platformNick;
	}
	return personPlats;
}

Map<String, dynamic> $PersonPlatsToJson(PersonPlats entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['Id'] = entity.id;
	data['PlatformName'] = entity.platformName;
	data['PlatformPicture'] = entity.platformPicture;
	data['PlatformAccount'] = entity.platformAccount;
	data['PlatformNick'] = entity.platformNick;
	return data;
}