import 'package:lanzhong/generated/json/base/json_field.dart';
import 'package:lanzhong/generated/json/person_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class PersonEntity {
	late int yhid;
	late String ygnc;
	@JSONField(name: "Price")
	late double price;
	@JSONField(name: "DxCount")
	late int dxCount;
	late List<PersonGames> games;
	late List<PersonPlats> plats;

	PersonEntity();

	factory PersonEntity.fromJson(Map<String, dynamic> json) => $PersonEntityFromJson(json);

	Map<String, dynamic> toJson() => $PersonEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class PersonGames {
	@JSONField(name: "Id")
	late int id;
	late String yxmc;
	late String kfpt;

	PersonGames();

	factory PersonGames.fromJson(Map<String, dynamic> json) => $PersonGamesFromJson(json);

	Map<String, dynamic> toJson() => $PersonGamesToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class PersonPlats {
	@JSONField(name: "Id")
	late int id;
	@JSONField(name: "PlatformName")
	late String? platformName="";
	@JSONField(name: "PlatformPicture")
	late String platformPicture;

	@JSONField(name: "PlatformAccount")
	late String? platformAccount="";

	@JSONField(name: "PlatformNick")
	late	String? platformNick="";
	PersonPlats();

	factory PersonPlats.fromJson(Map<String, dynamic> json) => $PersonPlatsFromJson(json);

	Map<String, dynamic> toJson() => $PersonPlatsToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}