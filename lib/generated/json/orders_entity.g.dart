import 'package:lanzhong/generated/json/base/json_convert_content.dart';
import 'package:lanzhong/model/orders_entity.dart';

OrdersEntity $OrdersEntityFromJson(Map<String, dynamic> json) {
	final OrdersEntity ordersEntity = OrdersEntity();
	final List<OrdersData>? data = jsonConvert.convertListNotNull<OrdersData>(json['data']);
	if (data != null) {
		ordersEntity.data = data;
	}
	final int? total = jsonConvert.convert<int>(json['total']);
	if (total != null) {
		ordersEntity.total = total;
	}
	final int? pageCount = jsonConvert.convert<int>(json['pageCount']);
	if (pageCount != null) {
		ordersEntity.pageCount = pageCount;
	}
	return ordersEntity;
}

Map<String, dynamic> $OrdersEntityToJson(OrdersEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['data'] =  entity.data.map((v) => v.toJson()).toList();
	data['total'] = entity.total;
	data['pageCount'] = entity.pageCount;
	return data;
}

OrdersData $OrdersDataFromJson(Map<String, dynamic> json) {
	final OrdersData ordersData = OrdersData();
	final int? id = jsonConvert.convert<int>(json['Id']);
	if (id != null) {
		ordersData.id = id;
	}
	final String? ddh = jsonConvert.convert<String>(json['ddh']);
	if (ddh != null) {
		ordersData.ddh = ddh;
	}
	final String? dlzt = jsonConvert.convert<String>(json['dlzt']);
	if (dlzt != null) {
		ordersData.dlzt = dlzt;
	}
	final String? ddlx = jsonConvert.convert<String>(json['ddlx']);
	if (ddlx != null) {
		ordersData.ddlx = ddlx;
	}
	final int? yxid = jsonConvert.convert<int>(json['yxid']);
	if (yxid != null) {
		ordersData.yxid = yxid;
	}
	final String? dq = jsonConvert.convert<String>(json['dq']);
	if (dq != null) {
		ordersData.dq = dq;
	}
	final String? qh = jsonConvert.convert<String>(json['qh']);
	if (qh != null) {
		ordersData.qh = qh;
	}
	final String? js = jsonConvert.convert<String>(json['js']);
	if (js != null) {
		ordersData.js = js;
	}
	final String? zh = jsonConvert.convert<String>(json['zh']);
	if (zh != null) {
		ordersData.zh = zh;
	}
	final String? mm = jsonConvert.convert<String>(json['mm']);
	if (mm != null) {
		ordersData.mm = mm;
	}
	final String? yq = jsonConvert.convert<String>(json['yq']);
	if (yq != null) {
		ordersData.yq = yq;
	}
	final String? ww = jsonConvert.convert<String>(json['ww']);
	if (ww != null) {
		ordersData.ww = ww;
	}
	final String? zt = jsonConvert.convert<String>(json['zt']);
	if (zt != null) {
		ordersData.zt = zt;
	}
	final int? sr = jsonConvert.convert<int>(json['sr']);
	if (sr != null) {
		ordersData.sr = sr;
	}
	final int? zc = jsonConvert.convert<int>(json['zc']);
	if (zc != null) {
		ordersData.zc = zc;
	}
	final int? userGameTypeId = jsonConvert.convert<int>(json['UserGameTypeId']);
	if (userGameTypeId != null) {
		ordersData.userGameTypeId = userGameTypeId;
	}
	final int? kfAppUserId = jsonConvert.convert<int>(json['KfAppUserId']);
	if (kfAppUserId != null) {
		ordersData.kfAppUserId = kfAppUserId;
	}
	final String? sj = jsonConvert.convert<String>(json['sj']);
	if (sj != null) {
		ordersData.sj = sj;
	}
	final int? lr = jsonConvert.convert<int>(json['lr']);
	if (lr != null) {
		ordersData.lr = lr;
	}
	final int? bdzc = jsonConvert.convert<int>(json['bdzc']);
	if (bdzc != null) {
		ordersData.bdzc = bdzc;
	}
	final String? dlpt = jsonConvert.convert<String>(json['dlpt']);
	if (dlpt != null) {
		ordersData.dlpt = dlpt;
	}
	final int? fdAppUserId = jsonConvert.convert<int>(json['FdAppUserId']);
	if (fdAppUserId != null) {
		ordersData.fdAppUserId = fdAppUserId;
	}
	final String? isbaodan = jsonConvert.convert<String>(json['isbaodan']);
	if (isbaodan != null) {
		ordersData.isbaodan = isbaodan;
	}
	final String? ddly = jsonConvert.convert<String>(json['ddly']);
	if (ddly != null) {
		ordersData.ddly = ddly;
	}
	final String? istk = jsonConvert.convert<String>(json['istk']);
	if (istk != null) {
		ordersData.istk = istk;
	}
	final int? tkje = jsonConvert.convert<int>(json['tkje']);
	if (tkje != null) {
		ordersData.tkje = tkje;
	}
	final String? tjsj = jsonConvert.convert<String>(json['tjsj']);
	if (tjsj != null) {
		ordersData.tjsj = tjsj;
	}
	final int? aqbzj = jsonConvert.convert<int>(json['aqbzj']);
	if (aqbzj != null) {
		ordersData.aqbzj = aqbzj;
	}
	final int? xlbzj = jsonConvert.convert<int>(json['xlbzj']);
	if (xlbzj != null) {
		ordersData.xlbzj = xlbzj;
	}
	final int? dlsj = jsonConvert.convert<int>(json['dlsj']);
	if (dlsj != null) {
		ordersData.dlsj = dlsj;
	}
	final int? clsh = jsonConvert.convert<int>(json['clsh']);
	if (clsh != null) {
		ordersData.clsh = clsh;
	}
	final int? appUserId = jsonConvert.convert<int>(json['AppUserId']);
	if (appUserId != null) {
		ordersData.appUserId = appUserId;
	}
	final int? bdcs = jsonConvert.convert<int>(json['bdcs']);
	if (bdcs != null) {
		ordersData.bdcs = bdcs;
	}
	final int? yccs = jsonConvert.convert<int>(json['yccs']);
	if (yccs != null) {
		ordersData.yccs = yccs;
	}
	final int? cdcs = jsonConvert.convert<int>(json['cdcs']);
	if (cdcs != null) {
		ordersData.cdcs = cdcs;
	}
	final int? tjcs = jsonConvert.convert<int>(json['tjcs']);
	if (tjcs != null) {
		ordersData.tjcs = tjcs;
	}
	final int? jrcs = jsonConvert.convert<int>(json['jrcs']);
	if (jrcs != null) {
		ordersData.jrcs = jrcs;
	}
	final int? cxcs = jsonConvert.convert<int>(json['cxcs']);
	if (cxcs != null) {
		ordersData.cxcs = cxcs;
	}
	final int? sfmj = jsonConvert.convert<int>(json['sfmj']);
	if (sfmj != null) {
		ordersData.sfmj = sfmj;
	}
	final String? tbzt = jsonConvert.convert<String>(json['tbzt']);
	if (tbzt != null) {
		ordersData.tbzt = tbzt;
	}
	final String? xdsj = jsonConvert.convert<String>(json['xdsj']);
	if (xdsj != null) {
		ordersData.xdsj = xdsj;
	}
	final String? kfscsj = jsonConvert.convert<String>(json['kfscsj']);
	if (kfscsj != null) {
		ordersData.kfscsj = kfscsj;
	}
	final String? cswjs = jsonConvert.convert<String>(json['cswjs']);
	if (cswjs != null) {
		ordersData.cswjs = cswjs;
	}
	final String? yxmc = jsonConvert.convert<String>(json['yxmc']);
	if (yxmc != null) {
		ordersData.yxmc = yxmc;
	}
	final String? dllx = jsonConvert.convert<String>(json['dllx']);
	if (dllx != null) {
		ordersData.dllx = dllx;
	}
	final int? yhid = jsonConvert.convert<int>(json['yhid']);
	if (yhid != null) {
		ordersData.yhid = yhid;
	}
	final int? pid = jsonConvert.convert<int>(json['Pid']);
	if (pid != null) {
		ordersData.pid = pid;
	}
	final String? lxr = jsonConvert.convert<String>(json['lxr']);
	if (lxr != null) {
		ordersData.lxr = lxr;
	}
	final String? bdddh = jsonConvert.convert<String>(json['bdddh']);
	if (bdddh != null) {
		ordersData.bdddh = bdddh;
	}
	final String? fdrnick = jsonConvert.convert<String>(json['fdrnick']);
	if (fdrnick != null) {
		ordersData.fdrnick = fdrnick;
	}
	final String? yxsm = jsonConvert.convert<String>(json['yxsm']);
	if (yxsm != null) {
		ordersData.yxsm = yxsm;
	}
	final String? zdyys = jsonConvert.convert<String>(json['zdyys']);
	if (zdyys != null) {
		ordersData.zdyys = zdyys;
	}
	final int? staffBeaterId = jsonConvert.convert<int>(json['StaffBeaterId']);
	if (staffBeaterId != null) {
		ordersData.staffBeaterId = staffBeaterId;
	}
	final String? sfpb = jsonConvert.convert<String>(json['sfpb']);
	if (sfpb != null) {
		ordersData.sfpb = sfpb;
	}
	final String? bzxx1 = jsonConvert.convert<String>(json['bzxx1']);
	if (bzxx1 != null) {
		ordersData.bzxx1 = bzxx1;
	}
	final String? kfpt = jsonConvert.convert<String>(json['kfpt']);
	if (kfpt != null) {
		ordersData.kfpt = kfpt;
	}
	final String? ptddh = jsonConvert.convert<String>(json['ptddh']);
	if (ptddh != null) {
		ordersData.ptddh = ptddh;
	}
	final String? cxxx = jsonConvert.convert<String>(json['cxxx']);
	if (cxxx != null) {
		ordersData.cxxx = cxxx;
	}
	final String? cxyy = jsonConvert.convert<String>(json['cxyy']);
	if (cxyy != null) {
		ordersData.cxyy = cxyy;
	}
	return ordersData;
}

Map<String, dynamic> $OrdersDataToJson(OrdersData entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['Id'] = entity.id;
	data['ddh'] = entity.ddh;
	data['dlzt'] = entity.dlzt;
	data['ddlx'] = entity.ddlx;
	data['yxid'] = entity.yxid;
	data['dq'] = entity.dq;
	data['qh'] = entity.qh;
	data['js'] = entity.js;
	data['zh'] = entity.zh;
	data['mm'] = entity.mm;
	data['yq'] = entity.yq;
	data['ww'] = entity.ww;
	data['zt'] = entity.zt;
	data['sr'] = entity.sr;
	data['zc'] = entity.zc;
	data['UserGameTypeId'] = entity.userGameTypeId;
	data['KfAppUserId'] = entity.kfAppUserId;
	data['sj'] = entity.sj;
	data['lr'] = entity.lr;
	data['bdzc'] = entity.bdzc;
	data['dlpt'] = entity.dlpt;
	data['FdAppUserId'] = entity.fdAppUserId;
	data['isbaodan'] = entity.isbaodan;
	data['ddly'] = entity.ddly;
	data['istk'] = entity.istk;
	data['tkje'] = entity.tkje;
	data['tjsj'] = entity.tjsj;
	data['aqbzj'] = entity.aqbzj;
	data['xlbzj'] = entity.xlbzj;
	data['dlsj'] = entity.dlsj;
	data['clsh'] = entity.clsh;
	data['AppUserId'] = entity.appUserId;
	data['bdcs'] = entity.bdcs;
	data['yccs'] = entity.yccs;
	data['cdcs'] = entity.cdcs;
	data['tjcs'] = entity.tjcs;
	data['jrcs'] = entity.jrcs;
	data['cxcs'] = entity.cxcs;
	data['sfmj'] = entity.sfmj;
	data['tbzt'] = entity.tbzt;
	data['xdsj'] = entity.xdsj;
	data['kfscsj'] = entity.kfscsj;
	data['cswjs'] = entity.cswjs;
	data['yxmc'] = entity.yxmc;
	data['dllx'] = entity.dllx;
	data['yhid'] = entity.yhid;
	data['Pid'] = entity.pid;
	data['lxr'] = entity.lxr;
	data['bdddh'] = entity.bdddh;
	data['fdrnick'] = entity.fdrnick;
	data['yxsm'] = entity.yxsm;
	data['zdyys'] = entity.zdyys;
	data['StaffBeaterId'] = entity.staffBeaterId;
	data['sfpb'] = entity.sfpb;
	data['bzxx1'] = entity.bzxx1;
	data['kfpt'] = entity.kfpt;
	data['ptddh'] = entity.ptddh;
	data['cxxx'] = entity.cxxx;
	data['cxyy'] = entity.cxyy;
	return data;
}