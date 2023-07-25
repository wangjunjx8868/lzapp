import 'package:lanzhong/generated/json/base/json_field.dart';
import 'package:lanzhong/generated/json/game_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class GameEntity {
	@JSONField(name: "Id")
	late int id;
	late String yxmc;

	GameEntity();

	factory GameEntity.fromJson(Map<String, dynamic> json) => $GameEntityFromJson(json);

	Map<String, dynamic> toJson() => $GameEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}