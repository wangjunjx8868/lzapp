import 'package:lanzhong/generated/json/base/json_field.dart';
import 'package:lanzhong/generated/json/game2_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class Game2Entity {
	@JSONField(name: "Id")
	late int id;
	@JSONField(name: "GameName")
	late String gameName;
	@JSONField(name: "Isky")
	late int isky;

	Game2Entity();

	factory Game2Entity.fromJson(Map<String, dynamic> json) => $Game2EntityFromJson(json);

	Map<String, dynamic> toJson() => $Game2EntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}