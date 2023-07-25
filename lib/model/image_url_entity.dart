import 'package:lanzhong/generated/json/base/json_field.dart';
import 'package:lanzhong/generated/json/image_url_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class ImageUrlEntity {
	late String createTime;
	late String msg;
	late String imgUrl;
	late String title;

	ImageUrlEntity();

	factory ImageUrlEntity.fromJson(Map<String, dynamic> json) => $ImageUrlEntityFromJson(json);

	Map<String, dynamic> toJson() => $ImageUrlEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}