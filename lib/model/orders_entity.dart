import 'package:lanzhong/generated/json/base/json_field.dart';
import 'package:lanzhong/generated/json/orders_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class OrdersEntity {
	late List<OrdersData> data;
	late int total;
	late int pageCount;

	OrdersEntity();

	factory OrdersEntity.fromJson(Map<String, dynamic> json) => $OrdersEntityFromJson(json);

	Map<String, dynamic> toJson() => $OrdersEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class OrdersData {
	@JSONField(name: "Id")
	late int id=0;
	late String ddh="";
	late String dlzt="";
	late String ddlx="";
	late int yxid=0;
	late String dq="";
	late String qh="";
	late String js="";
	late String zh="";
	late String mm="";
	late String yq="";
	late String ww="";
	late String zt="";
	late int sr=0;
	late int zc=0;
	@JSONField(name: "UserGameTypeId")
	late int userGameTypeId=0;
	@JSONField(name: "KfAppUserId")
	late int kfAppUserId=0;
	late String sj="";
	late int lr=0;
	late int bdzc=0;
	late String dlpt="";
	@JSONField(name: "FdAppUserId")
	late int fdAppUserId=0;
	late String isbaodan="";
	late String ddly="";
	late String istk="";
	late int tkje=0;
	late String tjsj="";
	late int aqbzj=0;
	late int xlbzj=0;
	late int dlsj=0;
	late int clsh=0;
	@JSONField(name: "AppUserId")
	late int appUserId=0;
	late int bdcs=0;
	late int yccs=0;
	late int cdcs=0;
	late int tjcs=0;
	late int jrcs=0;
	late int cxcs=0;
	late int sfmj=0;
	late String tbzt="";
	late String xdsj="";
	late String kfscsj="";
	late String cswjs="";
	late String yxmc="";
	late String dllx="";
	late int yhid=0;
	@JSONField(name: "Pid")
	late int pid=0;
	late String lxr="";
	late String bdddh="";
	late String fdrnick="";
	late String yxsm="";
	late String zdyys="";
	@JSONField(name: "StaffBeaterId")
	late int staffBeaterId=0;
	late String sfpb="";
	late String bzxx1="";
	late String kfpt="";
	late String ptddh="";
	late String cxxx="";
	late String cxyy="";
	OrdersData();

	factory OrdersData.fromJson(Map<String, dynamic> json) => $OrdersDataFromJson(json);

	Map<String, dynamic> toJson() => $OrdersDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}