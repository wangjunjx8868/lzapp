import 'package:lanzhong/generated/json/base/json_convert_content.dart';
import 'package:lanzhong/model/game_entity.dart';

GameEntity $GameEntityFromJson(Map<String, dynamic> json) {
	final GameEntity gameEntity = GameEntity();
	final int? id = jsonConvert.convert<int>(json['Id']);
	if (id != null) {
		gameEntity.id = id;
	}
	final String? yxmc = jsonConvert.convert<String>(json['yxmc']);
	if (yxmc != null) {
		gameEntity.yxmc = yxmc;
	}
	return gameEntity;
}

Map<String, dynamic> $GameEntityToJson(GameEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['Id'] = entity.id;
	data['yxmc'] = entity.yxmc;
	return data;
}