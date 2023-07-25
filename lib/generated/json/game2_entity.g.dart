import 'package:lanzhong/generated/json/base/json_convert_content.dart';
import 'package:lanzhong/model/game2_entity.dart';

Game2Entity $Game2EntityFromJson(Map<String, dynamic> json) {
	final Game2Entity game2Entity = Game2Entity();
	final int? id = jsonConvert.convert<int>(json['Id']);
	if (id != null) {
		game2Entity.id = id;
	}
	final String? gameName = jsonConvert.convert<String>(json['GameName']);
	if (gameName != null) {
		game2Entity.gameName = gameName;
	}
	final int? isky = jsonConvert.convert<int>(json['Isky']);
	if (isky != null) {
		game2Entity.isky = isky;
	}
	return game2Entity;
}

Map<String, dynamic> $Game2EntityToJson(Game2Entity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['Id'] = entity.id;
	data['GameName'] = entity.gameName;
	data['Isky'] = entity.isky;
	return data;
}