

import 'package:lanzhong/model/game2_entity.dart';
import 'package:lanzhong/model/message_entity.dart';
import 'package:lanzhong/model/sub_entity.dart';

import '../../generated/json/base/json_convert_content.dart';
import '../dq_entity.dart';
import '../game_entity.dart';
import '../image_url_entity.dart';
import '../ptzt_entity.dart';
import 'list_data.dart';

ListData<T> $ListDataFromJson<T>(Map<String, dynamic> json) {
  final ListData<T> pagingData = ListData<T>();

  final List<T>? records = jsonConvert.convertListNotNull<T>(json['data']);
  if (records != null) {
    pagingData.data = records;
  }
  return pagingData;
}

Map<String, dynamic> $ListDataToJson(ListData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['records'] =  entity.data;
  return data;
}


M? listDataFromJsonSingle<M>(Map<String, dynamic> json){
  String type = M.toString();
  String genericType = type.substring(type.indexOf("<") + 1, type.length -1);
  print("genericType :$genericType");
  if((GameEntity).toString() == genericType){
    ListData<GameEntity> listData = ListData<GameEntity>.fromJson(json);
  	return listData as M;
  }
  if((DqDllxs).toString() == genericType){
    ListData<DqDllxs> listData = ListData<DqDllxs>.fromJson(json);
    return listData as M;
  }
  if((PtztEntity).toString() == genericType){
    ListData<PtztEntity> listData = ListData<PtztEntity>.fromJson(json);
    return listData as M;
  }
  if((MessageEntity).toString() == genericType){
    ListData<MessageEntity> listData = ListData<MessageEntity>.fromJson(json);
    return listData as M;
  }
  if((ImageUrlEntity).toString() == genericType){
    ListData<ImageUrlEntity> listData = ListData<ImageUrlEntity>.fromJson(json);
    return listData as M;
  }
  if((Game2Entity).toString() == genericType){
    ListData<Game2Entity> listData = ListData<Game2Entity>.fromJson(json);
    return listData as M;
  }
  if((SubEntity).toString() == genericType){
    ListData<SubEntity> listData = ListData<SubEntity>.fromJson(json);
    return listData as M;
  }
  return ListData.fromJson(json) as M;
}