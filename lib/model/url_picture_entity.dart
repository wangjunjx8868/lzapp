import 'package:lanzhong/generated/json/base/json_field.dart';
import 'package:lanzhong/generated/json/url_picture_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class UrlPictureEntity {
	@JSONField(name: "PicUrl")
	late String picUrl;

	UrlPictureEntity();

	factory UrlPictureEntity.fromJson(Map<String, dynamic> json) => $UrlPictureEntityFromJson(json);

	Map<String, dynamic> toJson() => $UrlPictureEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}