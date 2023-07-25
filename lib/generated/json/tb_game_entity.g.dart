import 'package:lanzhong/generated/json/base/json_convert_content.dart';
import 'package:lanzhong/model/tb_game_entity.dart';

TbGameEntity $TbGameEntityFromJson(Map<String, dynamic> json) {
	final TbGameEntity tbGameEntity = TbGameEntity();
	final int? id = jsonConvert.convert<int>(json['Id']);
	if (id != null) {
		tbGameEntity.id = id;
	}
	final String? yxmc = jsonConvert.convert<String>(json['yxmc']);
	if (yxmc != null) {
		tbGameEntity.yxmc = yxmc;
	}
	final String? tjsj = jsonConvert.convert<String>(json['tjsj']);
	if (tjsj != null) {
		tbGameEntity.tjsj = tjsj;
	}
	final int? yhid = jsonConvert.convert<int>(json['yhid']);
	if (yhid != null) {
		tbGameEntity.yhid = yhid;
	}
	final String? kfpt = jsonConvert.convert<String>(json['kfpt']);
	if (kfpt != null) {
		tbGameEntity.kfpt = kfpt;
	}
	final String? sfxs = jsonConvert.convert<String>(json['sfxs']);
	if (sfxs != null) {
		tbGameEntity.sfxs = sfxs;
	}
	final String? lxr = jsonConvert.convert<String>(json['lxr']);
	if (lxr != null) {
		tbGameEntity.lxr = lxr;
	}
	final String? lxdh = jsonConvert.convert<String>(json['lxdh']);
	if (lxdh != null) {
		tbGameEntity.lxdh = lxdh;
	}
	final String? lxqq = jsonConvert.convert<String>(json['lxqq']);
	if (lxqq != null) {
		tbGameEntity.lxqq = lxqq;
	}
	final int? aqbzj = jsonConvert.convert<int>(json['aqbzj']);
	if (aqbzj != null) {
		tbGameEntity.aqbzj = aqbzj;
	}
	final int? xlbzj = jsonConvert.convert<int>(json['xlbzj']);
	if (xlbzj != null) {
		tbGameEntity.xlbzj = xlbzj;
	}
	final String? jdyq = jsonConvert.convert<String>(json['jdyq']);
	if (jdyq != null) {
		tbGameEntity.jdyq = jdyq;
	}
	final String? jdsm = jsonConvert.convert<String>(json['jdsm']);
	if (jdsm != null) {
		tbGameEntity.jdsm = jdsm;
	}
	final String? sfpb = jsonConvert.convert<String>(json['sfpb']);
	if (sfpb != null) {
		tbGameEntity.sfpb = sfpb;
	}
	final int? dltintervene = jsonConvert.convert<int>(json['dltintervene']);
	if (dltintervene != null) {
		tbGameEntity.dltintervene = dltintervene;
	}
	final int? dltfinish = jsonConvert.convert<int>(json['dltfinish']);
	if (dltfinish != null) {
		tbGameEntity.dltfinish = dltfinish;
	}
	final int? vip = jsonConvert.convert<int>(json['vip']);
	if (vip != null) {
		tbGameEntity.vip = vip;
	}
	return tbGameEntity;
}

Map<String, dynamic> $TbGameEntityToJson(TbGameEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['Id'] = entity.id;
	data['yxmc'] = entity.yxmc;
	data['tjsj'] = entity.tjsj;
	data['yhid'] = entity.yhid;
	data['kfpt'] = entity.kfpt;
	data['sfxs'] = entity.sfxs;
	data['lxr'] = entity.lxr;
	data['lxdh'] = entity.lxdh;
	data['lxqq'] = entity.lxqq;
	data['aqbzj'] = entity.aqbzj;
	data['xlbzj'] = entity.xlbzj;
	data['jdyq'] = entity.jdyq;
	data['jdsm'] = entity.jdsm;
	data['sfpb'] = entity.sfpb;
	data['dltintervene'] = entity.dltintervene;
	data['dltfinish'] = entity.dltfinish;
	data['vip'] = entity.vip;
	return data;
}