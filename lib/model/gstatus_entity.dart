import 'package:lanzhong/generated/json/base/json_field.dart';
import 'package:lanzhong/generated/json/gstatus_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class GstatusEntity {
	late List<GstatusGames> games;
	late List<GstatusZts> zts;

	GstatusEntity();

	factory GstatusEntity.fromJson(Map<String, dynamic> json) => $GstatusEntityFromJson(json);

	Map<String, dynamic> toJson() => $GstatusEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class GstatusGames {
	@JSONField(name: "Id")
	late int id;
	late String yxmc;
	dynamic kfpt;

	GstatusGames();

	factory GstatusGames.fromJson(Map<String, dynamic> json) => $GstatusGamesFromJson(json);

	Map<String, dynamic> toJson() => $GstatusGamesToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class GstatusZts {
	late String ddzt;
	late int sl;

	GstatusZts();

	factory GstatusZts.fromJson(Map<String, dynamic> json) => $GstatusZtsFromJson(json);

	Map<String, dynamic> toJson() => $GstatusZtsToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}