import 'package:lanzhong/generated/json/base/json_convert_content.dart';
import 'package:lanzhong/model/url_picture_entity.dart';

UrlPictureEntity $UrlPictureEntityFromJson(Map<String, dynamic> json) {
	final UrlPictureEntity urlPictureEntity = UrlPictureEntity();
	final String? picUrl = jsonConvert.convert<String>(json['PicUrl']);
	if (picUrl != null) {
		urlPictureEntity.picUrl = picUrl;
	}
	return urlPictureEntity;
}

Map<String, dynamic> $UrlPictureEntityToJson(UrlPictureEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['PicUrl'] = entity.picUrl;
	return data;
}