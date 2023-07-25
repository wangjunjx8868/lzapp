import 'package:lanzhong/generated/json/base/json_convert_content.dart';
import 'package:lanzhong/model/image_url_entity.dart';

ImageUrlEntity $ImageUrlEntityFromJson(Map<String, dynamic> json) {
	final ImageUrlEntity imageUrlEntity = ImageUrlEntity();
	final String? createTime = jsonConvert.convert<String>(json['createTime']);
	if (createTime != null) {
		imageUrlEntity.createTime = createTime;
	}
	final String? msg = jsonConvert.convert<String>(json['msg']);
	if (msg != null) {
		imageUrlEntity.msg = msg;
	}
	final String? imgUrl = jsonConvert.convert<String>(json['imgUrl']);
	if (imgUrl != null) {
		imageUrlEntity.imgUrl = imgUrl;
	}
	final String? title = jsonConvert.convert<String>(json['title']);
	if (title != null) {
		imageUrlEntity.title = title;
	}
	return imageUrlEntity;
}

Map<String, dynamic> $ImageUrlEntityToJson(ImageUrlEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['createTime'] = entity.createTime;
	data['msg'] = entity.msg;
	data['imgUrl'] = entity.imgUrl;
	data['title'] = entity.title;
	return data;
}