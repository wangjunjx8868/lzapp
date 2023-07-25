import 'package:lanzhong/generated/json/base/json_field.dart';
import 'package:lanzhong/generated/json/tb_game_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class TbGameEntity {
	@JSONField(name: "Id")
	late int id;
	late String yxmc;
	late String tjsj;
	late int yhid;
	late String kfpt;
	late String sfxs;
	late String? lxr="";
	late String? lxdh="";
	late String? lxqq="";
	late int aqbzj;
	late int xlbzj;
	late String jdyq;
	late String jdsm;
	late String sfpb;
	late int dltintervene;
	late int dltfinish;
	late int vip;

	TbGameEntity();

	factory TbGameEntity.fromJson(Map<String, dynamic> json) => $TbGameEntityFromJson(json);

	Map<String, dynamic> toJson() => $TbGameEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}