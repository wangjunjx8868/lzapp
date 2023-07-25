
import 'dart:io' show Platform;
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lanzhong/request/request_client.dart';
import 'package:logger/logger.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:popover/popover.dart';
import 'BtnMore.dart';
import 'PanPage.dart';
import 'applyinvoke.dart';
import 'detailpage.dart';
import 'editeorder.dart';
import 'event_bus.dart';
import 'model/api_response/list_data.dart';
import 'model/dq_entity.dart';
import 'model/game_entity.dart';
import 'model/gstatus_entity.dart';
import 'model/orders_entity.dart';
import 'model/ptresponse.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'model/ptzt_entity.dart';
extension ColorX on Color {
  String toHexTriplet() => '#${(value & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
}
class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> with AutomaticKeepAliveClientMixin{
  final List<String> ztItems = ['全部', '未发布', '未接手','代练中','待验收','已撤销','撤销中','已结算','已仲裁','已锁定','异常中','仲裁中','强制撤销','已退款'];
  final List<String> ztItems2 = [];
  var logger = Logger(printer: PrettyPrinter());
  TextEditingController textDdh = TextEditingController();
  List<GameEntity> games=[];
  List<PtztEntity> zts=[];
  List<DqDllxs> dllxs=[];
  List<String> dateRange=["全部","一个月内","三个月内","半年内","一年内"];
  Future<List<GameEntity>?> loadGames() async{
    RequestClient requestClient = RequestClient();
    String url = "/Order/LoadGames";
    ListData<GameEntity>? lsGames = await requestClient.get<ListData<GameEntity>>(url,onError: (e){
      return e.code==0;
    });
    if(lsGames!=null)
    {
      var addGe= GameEntity();
      addGe.id=0;
      addGe.yxmc="全部";
      lsGames.data?.insert(0, addGe);
      return lsGames.data;
    }
    return null;
  }
  Future<void> loadGameAndStaus() async{
    RequestClient requestClient = RequestClient();
    String url = "/Order/LoadGameAndStatus";
    GstatusEntity? gset = await requestClient.get<GstatusEntity>(url,onError: (e){
      return e.code==0;
    });
    if(gset!=null)
    {
      setState(() {
        var addGe= GameEntity();
        addGe.id=0;
        addGe.yxmc="全部";
        games.add(addGe);
        for(var item in gset.games)
        {
          var addGe2= GameEntity();
          addGe2.id=item.id;
          addGe2.yxmc=item.yxmc;
          games.add(addGe2);
        }
        int zsl=0;
        for(var item in gset.zts)
        {
          zsl+=item.sl;
          String slSTR=item.sl.toString();
          if(item.sl>10000)
          {
            slSTR="9999+";
          }
          ztItems2.add("${item.ddzt}($slSTR)");
        }
        ztItems2.insert(0,"全部($zsl)");
      });

    }
  }
  Future<List<DqDllxs>?> loadDllx(int gid) async{
    RequestClient requestClient = RequestClient();
    String url = "/Order/Dllx?gid=$gid";
    ListData<DqDllxs>? lsdllx = await requestClient.get<ListData<DqDllxs>>(url,onError: (e){
      return e.code==0;
    });
    if(lsdllx!=null)
    {
      var addGe= DqDllxs();
      addGe.id=0;
      addGe.dllx="全部";
      lsdllx.data?.insert(0, addGe);
      return lsdllx.data;
    }
    return null;
  }
  String selectedGameValue="游戏名称";
  String selectedDllxValue="代练类型";
  String selectedDateValue="三个月内";//时间范围
  Widget wGame(){
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        alignment:AlignmentDirectional.center ,
        isExpanded: true,
        hint:  SizedBox(
            width: 136,
            child:Text(selectedGameValue,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,  color:Color(0xFF999999),
              ),
            ) ) ,
        items: games.map((item) => DropdownMenuItem<GameEntity>(value: item,
            child: SizedBox(width: 136,child: Text(item.yxmc,  textAlign: TextAlign.left)))
        ).toList(),
        onChanged: (gameEntity) {
          setState(() {
            if(gameEntity!=null)
            {
              if( gameEntity.yxmc=="全部")
              {
                selectedGameValue = "游戏名称";
              }
             else
             {
               selectedGameValue = gameEntity.yxmc;
             }
              if(gameEntity.id>0)
              {
                setState(() {
                  page=1;
                  yxid=gameEntity.id;
                });
                dllxs=[];
                gameTypeId=0;
                Future<List<DqDllxs>?> fldl= loadDllx(gameEntity.id);
                fldl.then((fga)  {
                  setState(() {
                    dllxs=fga!;
                    selectedDllxValue="代练类型";
                  });
                });
              }
              else
              {
                 var _dllx=DqDllxs();
                 _dllx.id=0;
                 _dllx.dllx="全部";

                 setState(() {
                   page=1;
                   yxid=0;
                   dllxs=[_dllx];
                   selectedDllxValue="代练类型";
                 });
              }
              Future<List<OrdersData>?> fod= loadData();
              fod.then((fod)  {
                setState(() {
                  orders=fod!;
                });
              });
            }
          });
        },
        buttonStyleData: const ButtonStyleData(
            height: 32,
            width: 136,
            padding: EdgeInsets.only(left: 0, right:0)
        ),
        iconStyleData: const IconStyleData(
          iconSize: 32,iconEnabledColor:Color(0xFF999999),
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 300,
          width: MediaQuery.of(context).size.width,
          elevation: 8,
          offset: const Offset(100, 0),
          scrollbarTheme: ScrollbarThemeData(
            thickness: MaterialStateProperty.all<double>(2),
            thumbVisibility: MaterialStateProperty.all<bool>(true),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 32,
          padding: EdgeInsets.only(left: 14, right: 14),
        ),
      ),
    );
  }
  Widget wDllx(){
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        alignment:AlignmentDirectional.centerEnd ,
        isExpanded: true,
        hint:  SizedBox(
            width: 100,
            child:Text(selectedDllxValue,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 16,  color:Color(0xFF999999),
              ),
            ) ) ,
        items: dllxs.map((item) => DropdownMenuItem<DqDllxs>(value: item,
            child: SizedBox(width: 120,child: Text(item.dllx,  textAlign: TextAlign.left)))
        ).toList(),
        onChanged: (dllxEntity) {
          setState(() {
            if(dllxEntity!=null)
            {
              if( dllxEntity.dllx=="全部")
              {
                selectedDllxValue = "代练类型";
              }
              else
              {
                selectedDllxValue = dllxEntity.dllx;
              }
              if(dllxEntity.id>0)
              {
                setState(() {
                  page=1;
                  gameTypeId=dllxEntity.id;
                });
              }
              else
              {
                setState(() {
                  page=1;
                  gameTypeId=0;
                });
              }
              Future<List<OrdersData>?> fod= loadData();
              fod.then((fod)  {
                setState(() {
                  orders=fod!;
                });
              });
            }
          });
        },
        buttonStyleData: const ButtonStyleData(
            height: 32,
            width: 120,
            padding: EdgeInsets.only(left: 0, right:0)
        ),
        iconStyleData: const IconStyleData(
            iconSize: 32,iconEnabledColor:Color(0xFF999999),
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 300,
          width: MediaQuery.of(context).size.width,
          elevation: 8,
          offset: const Offset(0, 0),
          scrollbarTheme: ScrollbarThemeData(
            thickness: MaterialStateProperty.all<double>(2),
            thumbVisibility: MaterialStateProperty.all<bool>(true),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 32,
          padding: EdgeInsets.only(left: 14, right: 14),
        ),
      ),
    );
  }
  Widget wDate(){
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        alignment:AlignmentDirectional.centerStart ,
        isExpanded: true,
        hint:  SizedBox(
            width: 100,
            child:Text(selectedDateValue,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16, color:Color(0xFF999999),
              ),
            ) ) ,
        items: dateRange.map((item) => DropdownMenuItem<String>(value: item,
            child: SizedBox(width: 120,child: Text(item,  textAlign: TextAlign.left)))
        ).toList(),
        onChanged: (dateValue) {
          setState(() {
            if(dateValue=="全部")
            {
              selectedDateValue = "时间范围";
            }
            else
            {
              selectedDateValue = dateValue!;
            }
            if(selectedDateValue!="时间范围")
            {
              setState(() {
                page=1;
                dateVal=dateValue!;
              });
            }
            else
            {
              setState(() {
                page=1;
                dateVal="";
              });
            }
            Future<List<OrdersData>?> fod= loadData();
            fod.then((fod)  {
              setState(() {
                orders=fod!;
              });
            });
          });
        },
        buttonStyleData: const ButtonStyleData(
            height: 32,
            width: 120,
            padding: EdgeInsets.only(left: 0, right:0)
        ),
        iconStyleData: const IconStyleData(
            iconSize: 32,iconEnabledColor:Color(0xFF999999),
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 300,
          width: MediaQuery.of(context).size.width,
          elevation: 8,
          offset: const Offset(0, 0),
          scrollbarTheme: ScrollbarThemeData(
            thickness: MaterialStateProperty.all<double>(2),
            thumbVisibility: MaterialStateProperty.all<bool>(true),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 32,
          padding: EdgeInsets.only(left: 14, right: 14),
        ),
      ),
    );
  }
  void rePublish(int tbId,int index)async {
    SharedPreferences prefs =await SharedPreferences.getInstance();
    Map<String, dynamic> dic = {
      "id": tbId.toString(),
      "yhid": prefs.getString("yhid"),
    };
    await EasyLoading.show(status: '验证中...', maskType: EasyLoadingMaskType.black);
    String url="http://lz.lzsterp.com/App/Publish";
    Map<String, dynamic>? headers={"content-type":"application/x-www-form-urlencoded"};
    RequestClient requestClient = RequestClient();
    await requestClient.post(url,data: dic,headers: headers,onError: (e){
      EasyLoading.showError(e.message!);
      return e.code==0;
    },onSuccess: (res)async{
      if(res.code==0)
      {
        EasyLoading.showSuccess("发布成功！");
        setState(() {zt="未接手";orders[index].zt="未接手";});
      }
      else
      {
        EasyLoading.showError(res.message!);
      }
    });
    await  EasyLoading.dismiss();
  }
  void addHour(String hour,int index) async{
    Map<String, dynamic>? formData = {
      "id": orders[index].id.toString(),
      "ptzt":  orders[index].zt,
      "ptName": orders[index].dlpt,
      "addHour": hour,
    };
    await EasyLoading.show(status: '验证中...', maskType: EasyLoadingMaskType.black);
    String url="/Order/AddHour";
    Map<String, dynamic>? headers={"Content-type":"application/x-www-form-urlencoded"};
    RequestClient requestClient = RequestClient();
    await requestClient.post(url,data: formData,headers: headers,onError: (e){
      EasyLoading.showError(e.message!);
      return e.code==0;
    },onSuccess: (res){
      if(res.code==0)
      {
        EasyLoading.showSuccess("操作成功！");
        setState(() {
          orders[index].dlsj=orders[index].dlsj+int.parse(hour);
        });
      }
      else
      {
        EasyLoading.showError(res.message!);
      }
    });
    await  EasyLoading.dismiss();
  }
  void updateHour(String hour,int index) async{
    Map<String, dynamic>? formData = {
      "id": orders[index].id.toString(),
      "addhour": hour,
    };
    await EasyLoading.show(status: '验证中...', maskType: EasyLoadingMaskType.black);
    String url="/Order/UpdateHour";
    RequestClient requestClient = RequestClient();
    await requestClient.get(url,queryParameters: formData,onError: (e){
      EasyLoading.showError(e.message!);
      return true;
    },onSuccess: (res)async{
      if(res.code==0)
      {
        setState(() {
          orders[index].dlsj=orders[index].dlsj+int.parse(hour);
        });
        EasyLoading.showSuccess("操作成功！");
      }
      else
      {
        EasyLoading.showError(res.message!);
      }
    });
    await  EasyLoading.dismiss();
  }
  void addPrice(String price,int index) async{
    Map<String, dynamic>? formData = {
      "id": orders[index].id.toString(),
      "ptzt":  orders[index].zt,
      "ptName": orders[index].dlpt,
      "addPrice": price,
    };
    await EasyLoading.show(status: '验证中...', maskType: EasyLoadingMaskType.black);
    String url="/Order/AddPrice";
    Map<String, dynamic>? headers={"Content-type":"application/x-www-form-urlencoded"};
    RequestClient requestClient = RequestClient();
    await requestClient.post(url,data: formData,headers: headers,onError: (e){
      EasyLoading.showError(e.message!);
      return e.code==0;
    },onSuccess: (res)async{
      if(res.code==0)
      {
        setState(() {
          orders[index].zc=orders[index].zc+int.parse(price);
        });
        EasyLoading.showSuccess("操作成功！");
      }
      else
      {
        EasyLoading.showError(res.message!);
      }
    });
    await  EasyLoading.dismiss();
  }
  void updatePrice(String price,int index) async{
    Map<String, dynamic>? formData = {
      "id": orders[index].id.toString(),
      "addprice": price,
    };
    await EasyLoading.show(status: '验证中...', maskType: EasyLoadingMaskType.black);
    String url="/Order/UpdatePrice";
    RequestClient requestClient = RequestClient();
    await requestClient.get(url,queryParameters: formData,onError: (e){
      EasyLoading.showError(e.message!);
      return true;
    },onSuccess: (res)async{
      if(res.code==0)
      {
        setState(() {
          orders[index].zc=orders[index].zc+int.parse(price);
        });
        EasyLoading.showSuccess("操作成功！");
      }
      else
      {
        EasyLoading.showError(res.message!);
      }
    });
    await  EasyLoading.dismiss();
  }
  void goInvokePage(int index)async {
    int aqj=orders[index].aqbzj!;
    int xlj=orders[index].xlbzj!;
    String tbid=orders[index].id.toString();
    String dlzt=orders[index].zt;
    String ptName=orders[index].dlpt;
   final dataInvoke=await Navigator.push(context, PanPageRouteBuilder(builder: (context) {return  InvokePage(aqbzj: aqj,xlbzj: xlj,tbid: tbid,dlzt: dlzt,ptName: ptName);}, transitionDuration: const Duration(milliseconds: 300),
        popDirection: AxisDirection.left));
    if(dataInvoke.toString()=="1")
    {
      setState(() {
        if(ptName=="私有平台")
        {
          orders[index].zt="已撤销";
          zt="已撤销";
        }
       else
       {
         orders[index].zt="撤销中";
         zt="撤销中";
       }
      });
    }
  }
  void goDetail(int index)async {
    // int aqj=orders[index].aqbzj!;
    // int xlj=orders[index].xlbzj!;
    // String tbid=orders[index].id.toString();
    // String dlzt=orders[index].zt;
    // String ptName=orders[index].dlpt;
    final detailResult=await Navigator.push(context, PanPageRouteBuilder(builder: (context) {return  DetailPage(tbid: orders[index].id,oIndex:index);}, transitionDuration: const Duration(milliseconds: 300),
        popDirection: AxisDirection.left));

    if(detailResult!=null)
    {
      debugPrint("返回了！！！");
      var czPt=detailResult as PtResponse;
      if(czPt.index>-1)
      {
        setState(() {
          orders[czPt.index].zt=czPt.zt;
        });
      }
    }
  }
  void delAll(int index) async{
    String tbid=orders[index].id.toString();
    await EasyLoading.show(status: '验证中...', maskType: EasyLoadingMaskType.black);
    String url="/Order/DeleteAll?id=$tbid";
    RequestClient requestClient = RequestClient();
    await requestClient.get(url,onError: (e){
      EasyLoading.showError(e.message!);
      return e.code==0;
    },onSuccess: (res){
      if(res.code==0)
      {
        EasyLoading.showSuccess("操作成功！");
        setState(() {
        orders.removeAt(index);
        });
      }
      else
      {
        EasyLoading.showError(res.message!);
      }
    });
    await  EasyLoading.dismiss();
  }
  //下架
  void offShelf(int index) async{
    String tbid=orders[index].id.toString();
    await EasyLoading.show(status: '验证中...', maskType: EasyLoadingMaskType.black);
    String url="/Order/PtDelAll?id=$tbid";
    RequestClient requestClient = RequestClient();
    await requestClient.get(url,onError: (e){
      EasyLoading.showError(e.message!);
      return e.code==0;
    },onSuccess: (res){
      if(res.code==0)
      {
        EasyLoading.showSuccess("操作成功！");
        setState(() {
          orders[index].zt="未发布";
        });
      }
      else
      {
        EasyLoading.showError(res.message!);
      }
    });
    await  EasyLoading.dismiss();
  }
  //同意撤销
  void agreeInvoke(int tbId,String ptZt,String ptName,int index) async{
    Map<String, dynamic>? formData = {"id": tbId, "ptzt": ptZt,"ptName": ptName};
    await EasyLoading.show(status: '验证中...', maskType: EasyLoadingMaskType.black);
    String url="/Order/AgreeRevoke";
    Map<String, dynamic>? headers={"Content-type":"application/x-www-form-urlencoded"};
    RequestClient requestClient = RequestClient();
    await EasyLoading.show(status: '验证中...', maskType: EasyLoadingMaskType.black);
    await requestClient.post(url,data: formData,headers: headers,onError: (e){
      EasyLoading.showError(e.message!);
      return e.code==0;
    },onSuccess: (res)async{
      if(res.code==0)
      {
        if (context.mounted) {
          Navigator.of(context).pop(PtResponse(index: index,zt: "已撤销"));
        }
      }
      else
      {
        EasyLoading.showError(res.message!);
      }
    });
    await  EasyLoading.dismiss();
  }
  //取消撤销
  void cancelInvoke(int tbId,String ptZt,String ptName,int index) async{
    Map<String, dynamic>? formData = {"id": tbId, "ptzt": ptZt,"ptName": ptName};
    await EasyLoading.show(status: '验证中...', maskType: EasyLoadingMaskType.black);
    String url="/Order/CancelRevoke";
    Map<String, dynamic>? headers={"Content-type":"application/x-www-form-urlencoded"};
    RequestClient requestClient = RequestClient();
    await requestClient.post(url,data: formData,headers: headers,onError: (e){
      EasyLoading.showError(e.message!);
      return e.code==0;
    },onSuccess: (res)async{
      if(res.code==0)
      {
        EasyLoading.showSuccess("操作成功！");
        setState(() {zt="代练中";orders[index].zt="代练中";});
      }
      else
      {
        EasyLoading.showError(res.message!);
      }
    });
    await  EasyLoading.dismiss();
  }
  void cancelArbitrate(int tbId,String ptZt,String ptName,int index) async{
    Map<String, dynamic>? formData = {"id": tbId, "ptzt": ptZt,"ptName": ptName};
    await EasyLoading.show(status: '验证中...', maskType: EasyLoadingMaskType.black);
    String url="/Order/CancelArbitrate";
    Map<String, dynamic>? headers={"Content-type":"application/x-www-form-urlencoded"};
    RequestClient requestClient = RequestClient();
    await EasyLoading.show(status: '验证中...', maskType: EasyLoadingMaskType.black);
    await requestClient.post(url,data: formData,headers: headers,onError: (e){
      EasyLoading.showError(e.message!);
      return e.code==0;
    },onSuccess: (res)async{
      await  EasyLoading.dismiss();
      if(res.code==0)
      {
        EasyLoading.showSuccess("操作成功！");
        setState(() {zt="撤销中";orders[index].zt="撤销中";});
      }
      else
      {
        EasyLoading.showError(res.message!);
      }
    });
    await  EasyLoading.dismiss();
  }
  void agreeOver(int tbId,String ptZt,String ptName,int index) async{
    Map<String, dynamic>? formData = {
      "id":tbId.toString(),
      "ptzt":  ptZt,
      "ptName": ptName,
    };
    await EasyLoading.show(status: '验证中...', maskType: EasyLoadingMaskType.black);
    String url="/Order/AgreeOver";
    Map<String, dynamic>? headers={"Content-type":"application/x-www-form-urlencoded"};
    RequestClient requestClient = RequestClient();
    await requestClient.post(url,data: formData,headers: headers,onError: (e){
      EasyLoading.showError(e.message!);
      return e.code==0;
    },onSuccess: (res)async{
      if(res.code==0)
      {
        EasyLoading.showSuccess("操作成功！");
        setState(() {zt="已结算";orders[index].zt="已结算";});
      }
      else
      {
        EasyLoading.showError(res.message!);
      }
    });
    await  EasyLoading.dismiss();
  }
  void unLock(int tbId,String ptZt,String ptName,int index) async{
    Map<String, dynamic>? formData = {
      "id":tbId.toString(),
      "ptzt":  ptZt,
      "ptName": ptName,
    };
    await EasyLoading.show(status: '验证中...', maskType: EasyLoadingMaskType.black);
    String url="/Order/Unlock";
    Map<String, dynamic>? headers={"Content-type":"application/x-www-form-urlencoded"};
    RequestClient requestClient = RequestClient();
    await requestClient.post(url,data: formData,headers: headers,onError: (e){
      EasyLoading.showError(e.message!);
      return e.code==0;
    },onSuccess: (res)async{
      if(res.code==0)
      {
        EasyLoading.showSuccess("操作成功！");
        setState(() {zt="代练中";orders[index].zt="代练中";});
      }
      else
      {
        EasyLoading.showError(res.message!);
      }
    });
    await  EasyLoading.dismiss();
  }
  String? selectedValue;
  int clickIndex=-1;
  final RefreshController _refreshController =RefreshController(initialRefresh: false);
  List<OrdersData> orders=[];
  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 360));
    // if failed,use refreshFailed()
    page=1;
    Future<List<OrdersData>?> fod= loadData();
    fod.then((fod)  {
      setState(() {
        orders=fod!;
        _refreshController.refreshCompleted();
      });
    });
  }
  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 360));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if(page>=pageCount)
    {
      _refreshController.loadNoData();
    }
    else
    {
      if(context.mounted)
      {
        page++;
        Future<List<OrdersData>?> fod= loadData();
        fod.then((fod)  {
          setState(() {
            orders.addAll(fod!);
            _refreshController.loadComplete();
          });
        });
      }
    }
  }
  //{"未发布","未接手","代练中", "待验收", "已撤销","撤销中","已结算","已仲裁" }
  int btnIndex = 0;
  Widget btnWidget({required String text,required int index, required VoidCallback onPressed}) {
    return Container(
      width:64,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 10),
      child:  GestureDetector(
        onTap: onPressed,
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text,style:  TextStyle(color: btnIndex==index?const Color(0xFF333333):const Color(0xFF666666),fontWeight:  btnIndex==index?FontWeight.bold:FontWeight.normal,fontSize: 16)),
            Container(
              width:20,height: 3,
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.all(0),
              decoration: btnIndex==index? const BoxDecoration(
                gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Color(0xffFFBF3A), Color(0xffFF5100),]),
                borderRadius: BorderRadius.all( Radius.circular(2)),
              ):null
            )
          ])
      )
    );
  }

  Color currentColor = Colors.amber;
  void changeColor(Color color){
    setState(() => currentColor = color);
  }
  int hexStringToHexInt(String hex) {
    hex = hex.replaceFirst('#', '');
    hex = hex.length == 6 ? 'FF$hex' : hex;
    int val = int.parse(hex, radix: 16);
    return val;
  }
  void setColor(int tbId) async{
    Map<String, dynamic>? formData = {"id": tbId,"colorValue": currentColor.toHexTriplet()};
    String url="/Order/SetCustomColor";
    Map<String, dynamic>? headers={"Content-type":"application/x-www-form-urlencoded"};
    RequestClient requestClient = RequestClient();
    await requestClient.post(url,data: formData,headers: headers,onError: (e){
      return e.code==0;
    },onSuccess: (res){
    });
  }
  void setRemark(int tbId,String bzxx) async{
    Map<String, dynamic>? formData = {"id": tbId,"remark": bzxx};
    String url="/Order/SetRemark";
    Map<String, dynamic>? headers={"Content-type":"application/x-www-form-urlencoded"};
    RequestClient requestClient = RequestClient();
    await requestClient.post(url,data: formData,headers: headers,onError: (e){
      return e.code==0;
    },onSuccess: (res){
    });
  }
  //各状态按钮
  Widget orderWidget(int index) {
    String zt=orders[index].zt;
    if(zt=="未发布"||zt=="已删除"){
      //发布，删除，标记
      return  Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            TextButton (
              onPressed: () async{
                rePublish(orders[index].id,index);
              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all(const EdgeInsets.only(left: 3,right: 3)),
                minimumSize: MaterialStateProperty.all(const Size(60, 26)),
                backgroundColor: MaterialStateProperty.all<Color>( const Color(0xFFFF8D57)),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              child: const Text("发布订单",style:  TextStyle(color: Color(0xFFFFFFFF), fontSize: 14)),
            ),
            const Spacer(),
            TextButton (
              onPressed: ()async{
                var result=await showOkCancelAlertDialog(context: context,title: "提示",message: "确定要删除吗?");
                if(result==OkCancelResult.ok)
                {
                  delAll(index);
                }
              },
              style: ButtonStyle(
                side: MaterialStateProperty.all(const BorderSide(color:Color(0xFFD0D0D0), width: 0.67)),
                padding: MaterialStateProperty.all(const EdgeInsets.only(left: 3,right: 3)),
                minimumSize: MaterialStateProperty.all(const Size(60, 26)),
                backgroundColor: MaterialStateProperty.all<Color>( const Color(0xFFFFFFFF)),
                foregroundColor: MaterialStateProperty.all<Color>(const Color(0xFF333333)),
              ),
              child: const Text("删除订单",style:  TextStyle(color: Color(0xFF333333), fontSize: 14)),
            ),
            const Spacer(),
            TextButton (
              onPressed: ()async{
                clickIndex=index;
                final editResult=await Navigator.push(context, PanPageRouteBuilder(builder: (context) {return  EditOrderPage(id: orders[index].id,oindex:index);}, transitionDuration: const Duration(milliseconds: 300),
                    popDirection: AxisDirection.left));
                if(editResult!=null)
                {
                  OrdersData od=editResult as OrdersData;
                  setState(() {
                    orders[clickIndex]=od;
                  });
                }
              },
              style: ButtonStyle(
                side: MaterialStateProperty.all(const BorderSide(color:Color(0xFFD0D0D0), width: 0.67)),
                padding: MaterialStateProperty.all(const EdgeInsets.only(left: 3,right: 3)),
                minimumSize: MaterialStateProperty.all(const Size(60, 26)),
                backgroundColor: MaterialStateProperty.all<Color>( const Color(0xFFFFFFFF)),
                foregroundColor: MaterialStateProperty.all<Color>(const Color(0xFF333333)),
              ),
              child: const Text("编辑订单",style:  TextStyle(color: Color(0xFF333333), fontSize: 14)),
            ),
            const Spacer(),
            const Spacer(),
            const Spacer()
          ]
      );
    }
    else  if(zt=="未接手") {
      return Row(
        children: [
          const Spacer(),
          TextButton (
            onPressed: () async{
              final textInput = await showTextInputDialog(
                  context: context,title: '补款',okLabel: "确定",cancelLabel: "取消",
                  textFields:  [
                    DialogTextField(hintText: '请输入加钱金额', maxLength: 10,keyboardType: TextInputType.number,
                        validator: (value) {
                          if(value!.isEmpty)
                          {
                            return "金额不能为空";
                          }
                          var isNumber=RegExp(r"\d+").hasMatch(value!);
                          return isNumber?null:"请输入整数";
                        })
                  ]
              );
              if(textInput!=null)
              {
                updatePrice(textInput.elementAt(0).toString(),index);
              }
            },
            style: ButtonStyle(
              side: MaterialStateProperty.all(const BorderSide(color:Color(0xFFD0D0D0), width: 0.67)),
              padding: MaterialStateProperty.all(const EdgeInsets.only(left: 3,right: 3)),
              minimumSize: MaterialStateProperty.all(const Size(60, 26)),
              backgroundColor: MaterialStateProperty.all<Color>( const Color(0xFFFFFFFF)),
              foregroundColor: MaterialStateProperty.all<Color>(const Color(0xFF333333)),
            ),
            child: const Text("加钱",style:  TextStyle(color: Color(0xFF333333), fontSize: 14)),
          ),
          const Spacer(),
          TextButton (
            onPressed: ()async{
              final textInput = await showTextInputDialog(
                  context: context,title: '加时',okLabel: "确定",cancelLabel: "取消",
                  textFields:  [
                    DialogTextField(hintText: '请输入加时小时数', maxLength: 10,keyboardType: TextInputType.number,
                        validator: (value) {
                          if(value!.isEmpty)
                          {
                            return "小时数不能为空";
                          }
                          var isNumber=RegExp(r"\d+").hasMatch(value!);
                          return isNumber?null:"请输入整数";
                        })
                  ]
              );
              if(textInput!=null)
              {
                updateHour(textInput.elementAt(0).toString(),index);
              }
            },
            style: ButtonStyle(
              side: MaterialStateProperty.all(const BorderSide(color:Color(0xFFD0D0D0), width: 0.67)),
              padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
              minimumSize: MaterialStateProperty.all(const Size(60, 26)),
              backgroundColor: MaterialStateProperty.all<Color>( const Color(0xFFFFFFFF)),
              foregroundColor: MaterialStateProperty.all<Color>(const Color(0xFF333333)),
            ),
            child: const Text("加时",style:  TextStyle(color: Color(0xFF333333), fontSize: 14)),
          ),
          const Spacer(),
          TextButton (
            onPressed: ()async{
              var result=await showOkCancelAlertDialog(context: context,title: "提示",message: "确定要下架吗?");
              if(result==OkCancelResult.ok)
              {
                offShelf(index);
              }
            },
            style: ButtonStyle(
              side: MaterialStateProperty.all(const BorderSide(color:Color(0xFFD0D0D0), width: 0.67)),
              padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
              minimumSize: MaterialStateProperty.all(const Size(60, 26)),
              backgroundColor: MaterialStateProperty.all<Color>( const Color(0xFFFFFFFF)),
              foregroundColor: MaterialStateProperty.all<Color>(const Color(0xFF333333)),
            ),
            child: const Text("平台下架",style:  TextStyle(color: Color(0xFF333333), fontSize: 14)),
          ), const Spacer(),
          const Spacer(),
          const Spacer(),
        ],
      );
    }
    else  if(zt=="代练中"||zt=="异常中") {
      //一键删除
      return  Row(
        children: [
          const Spacer(),
          TextButton (
            onPressed: (){goInvokePage(index);},
            style: ButtonStyle(
              side: MaterialStateProperty.all(const BorderSide(color:Color(0xFFD0D0D0), width: 0.67)),
              padding: MaterialStateProperty.all(const EdgeInsets.only(left: 3,right: 3)),
              minimumSize: MaterialStateProperty.all(const Size(60, 26)),
              backgroundColor: MaterialStateProperty.all<Color>( const Color(0xFFFFFFFF)),
              foregroundColor: MaterialStateProperty.all<Color>(const Color(0xFF333333)),
            ),
            child: const Text("申请撤销",style:  TextStyle(color: Color(0xFF333333), fontSize: 14)),
          ),
          const Spacer(),
          TextButton (
            onPressed: () async{
              final textInput = await showTextInputDialog(
                  context: context,title: '补款',okLabel: "确定",cancelLabel: "取消",
                  textFields:  [
                    DialogTextField(hintText: '请输入加钱金额', maxLength: 10,keyboardType: TextInputType.number,
                        validator: (value) {
                          if(value!.isEmpty)
                          {
                            return "金额不能为空";
                          }
                          var isNumber=RegExp(r"\d+").hasMatch(value);
                          return isNumber?null:"请输入整数";
                        })
                  ]
              );
              if(textInput!=null)
              {
                addPrice(textInput.elementAt(0).toString(),index);
              }
            },
            style: ButtonStyle(
              side: MaterialStateProperty.all(const BorderSide(color:Color(0xFFD0D0D0), width: 0.67)),
              padding: MaterialStateProperty.all(const EdgeInsets.only(left: 3,right: 3)),
              minimumSize: MaterialStateProperty.all(const Size(60, 26)),
              backgroundColor: MaterialStateProperty.all<Color>( const Color(0xFFFFFFFF)),
              foregroundColor: MaterialStateProperty.all<Color>(const Color(0xFF333333)),
            ),
            child: const Text("加钱",style:  TextStyle(color: Color(0xFF333333), fontSize: 14)),
          ),
          const Spacer(),
          TextButton (
            onPressed: ()async{
              final textInput = await showTextInputDialog(
                  context: context,title: '加时',okLabel: "确定",cancelLabel: "取消",
                  textFields:  [
                    DialogTextField(hintText: '请输入加时小时数', maxLength: 10,keyboardType: TextInputType.number,
                        validator: (value) {
                          if(value!.isEmpty)
                          {
                            return "小时数不能为空";
                          }
                          var isNumber=RegExp(r"\d+").hasMatch(value!);
                          return isNumber?null:"请输入整数";
                        })
                  ]
              );
              if(textInput!=null)
              {
                addHour(textInput.elementAt(0).toString(),index);
              }
            },
            style: ButtonStyle(
              side: MaterialStateProperty.all(const BorderSide(color:Color(0xFFD0D0D0), width: 0.67)),
              padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
              minimumSize: MaterialStateProperty.all(const Size(60, 26)),
              backgroundColor: MaterialStateProperty.all<Color>( const Color(0xFFFFFFFF)),
              foregroundColor: MaterialStateProperty.all<Color>(const Color(0xFF333333)),
            ),
            child: const Text("加时",style:  TextStyle(color: Color(0xFF333333), fontSize: 14)),
          ),
          const Spacer(),
          const Spacer(),
          const Spacer(),
        ],
      );
    }
    else  if(zt=="撤销中") {
      return  Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          TextButton (
            onPressed: () {
              int tbId=orders[index].id;
              String zt=orders[index].zt;
              String ptName=orders[index].dlpt;
              agreeInvoke(tbId, zt, ptName, index);
            },
            style: ButtonStyle(
              side: MaterialStateProperty.all(const BorderSide(color:Color(0xFFD0D0D0), width: 0.67)),
              padding: MaterialStateProperty.all(const EdgeInsets.only(left: 3,right: 3)),
              minimumSize: MaterialStateProperty.all(const Size(60, 26)),
              backgroundColor: MaterialStateProperty.all<Color>( const Color(0xFFFFFFFF)),
              foregroundColor: MaterialStateProperty.all<Color>(const Color(0xFF333333)),
            ),
            child: const Text("同意撤销",style:  TextStyle(color: Color(0xFF333333), fontSize: 14)),
          ),
          const Spacer(),
          TextButton (
            onPressed: (){
              int tbId=orders[index].id;
              String zt=orders[index].zt;
              String ptName=orders[index].dlpt;
              cancelInvoke(tbId,zt,ptName,index);
            },
            style: ButtonStyle(
              side: MaterialStateProperty.all(const BorderSide(color:Color(0xFFD0D0D0), width: 0.67)),
              padding: MaterialStateProperty.all(const EdgeInsets.only(left: 3,right: 3)),
              minimumSize: MaterialStateProperty.all(const Size(60, 26)),
              backgroundColor: MaterialStateProperty.all<Color>( const Color(0xFFFFFFFF)),
              foregroundColor: MaterialStateProperty.all<Color>(const Color(0xFF333333)),
            ),
            child: const Text("取消撤销",style:  TextStyle(color: Color(0xFF333333), fontSize: 14)),
          ),
          const Spacer()
        ],
      );
    }
    else  if(zt=="已撤销"||zt=="强制撤销") {
      return  Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton (
            onPressed: () async{
              rePublish(orders[index].id,index);
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all(const EdgeInsets.only(left: 3,right: 3)),
              minimumSize: MaterialStateProperty.all(const Size(60, 26)),
              backgroundColor: MaterialStateProperty.all<Color>( const Color(0xFFFF8D57)),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
            child: const Text("一键重发",style:  TextStyle(color: Color(0xFFffffff), fontSize: 14)),
          )
        ],
      );
    }
    else  if(zt=="已锁定") {
      return  Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton (
            onPressed: () {
              int tbId=orders[index].id;
              String zt=orders[index].zt;
              String ptName=orders[index].dlpt;
              unLock(tbId,zt,ptName,index);
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all(const EdgeInsets.only(left: 3,right: 3)),
              minimumSize: MaterialStateProperty.all(const Size(60, 26)),
              backgroundColor: MaterialStateProperty.all<Color>( const Color(0xFFFF8D57)),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
            child: const Text("解锁订单",style:  TextStyle(color: Color(0xFF333333), fontSize: 14)),
          )
        ],
      );
    }
    else  if(zt=="仲裁中") {
      return  Row(
        children: [
        const Spacer(),
          TextButton (
            onPressed: (){
              int tbId=orders[index].id;
              String zt=orders[index].zt;
              String ptName=orders[index].dlpt;
              cancelInvoke(tbId,zt,ptName,index);
            },
            style: ButtonStyle(
              side: MaterialStateProperty.all(const BorderSide(color:Color(0xFFD0D0D0), width: 0.67)),
              padding: MaterialStateProperty.all(const EdgeInsets.only(left: 3,right: 3)),
              minimumSize: MaterialStateProperty.all(const Size(60, 26)),
              backgroundColor: MaterialStateProperty.all<Color>( const Color(0xFFFFFFFF)),
              foregroundColor: MaterialStateProperty.all<Color>(const Color(0xFF333333)),
            ),
            child: const Text("取消仲裁",style:  TextStyle(color: Color(0xFF333333), fontSize: 14)),
          ),const Spacer(),
          TextButton (
            onPressed: () async{
              rePublish(orders[index].id,index);
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all(const EdgeInsets.only(left: 3,right: 3)),
              minimumSize: MaterialStateProperty.all(const Size(60, 26)),
              backgroundColor: MaterialStateProperty.all<Color>( const Color(0xFFFF8D57)),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
            child: const Text("一键重发",style:  TextStyle(color: Color(0xFFFFFFFF), fontSize: 14)),
          ),const Spacer(),
        ],
      );
    }
    else  if(zt=="待验收") {
      return Row(children: [
        TextButton (
        onPressed: (){
            int tbId=orders[index].id;
            String zt=orders[index].zt;
            String ptName=orders[index].dlpt;
            agreeOver(tbId,zt,ptName,index);
          },
        style: ButtonStyle(
          side: MaterialStateProperty.all(const BorderSide(color:Color(0xFFD0D0D0), width: 0.67)),
          padding: MaterialStateProperty.all(const EdgeInsets.only(left: 3,right: 3)),
          minimumSize: MaterialStateProperty.all(const Size(60, 26)),
          backgroundColor: MaterialStateProperty.all<Color>( const Color(0xFFFFFFFF)),
          foregroundColor: MaterialStateProperty.all<Color>(const Color(0xFF333333)),
        ),
        child: const Text("同意验收"),
      ),const Spacer(),
        TextButton (
          onPressed: (){ goInvokePage(index);},
          style: ButtonStyle(
            side: MaterialStateProperty.all(const BorderSide(color:Color(0xFFD0D0D0), width: 0.67)),
            padding: MaterialStateProperty.all(const EdgeInsets.only(left: 3,right: 3)),
            minimumSize: MaterialStateProperty.all(const Size(60, 26)),
            backgroundColor: MaterialStateProperty.all<Color>( const Color(0xFFFFFFFF)),
            foregroundColor: MaterialStateProperty.all<Color>(const Color(0xFF333333)),
          ),
          child: const Text("申请撤销",style:  TextStyle(color: Color(0xFF333333), fontSize: 14)),
        ),const Spacer(),
      ]);
    }
    else  if(zt=="已结算"||zt=="已仲裁") {
      return  Row(children: [
        const Spacer(),
        TextButton (
          onPressed: () async{
            rePublish(orders[index].id,index);
          },
          style: ButtonStyle(
            padding: MaterialStateProperty.all(const EdgeInsets.only(left: 3,right: 3)),
            minimumSize: MaterialStateProperty.all(const Size(60, 26)),
            backgroundColor: MaterialStateProperty.all<Color>( const Color(0xFFFF8D57)),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
          child: const Text("一键重发",style:  TextStyle(color: Color(0xFFFFFFFF), fontSize: 14)),
        ) ,const Spacer(),
      ]);
    }
    else {
      return Row(
          children: [
            TextButton (
            onPressed: (){ goDetail(index);},
            style: ButtonStyle(
              side: MaterialStateProperty.all(const BorderSide(color:Color(0xFFD0D0D0), width: 0.67)),
              padding: MaterialStateProperty.all(const EdgeInsets.only(left: 3,right: 3)),
              minimumSize: MaterialStateProperty.all(const Size(60, 26)),
              backgroundColor: MaterialStateProperty.all<Color>( const Color(0xFFFFFFFF)),
              foregroundColor: MaterialStateProperty.all<Color>(const Color(0xFF333333)),
            ),
            child: const Text("同意验收",style:  TextStyle(color: Color(0xFF333333), fontSize: 14)),
          )
        ]
      );
    }
  }
  int yxid=0;
  int page=1;
  int gameTypeId=0;
  String dq="";
  String zt="";
  String title="";
  String ddh="";
  String dateVal="";
  int pageCount=1;
  Future<List<OrdersData>?> loadData() async{
    RequestClient requestClient = RequestClient();
    String url = "/Order/List?";
    url+="page=$page";
    if(yxid>0) {url+="&yxid=$yxid";}
    if(gameTypeId>0) {url+="&gameTypeId=$gameTypeId";}
    if(dq.isNotEmpty) {url+="&dq=$dq";}
    if(zt.isNotEmpty) {url+="&zt=$zt";}
    if(title.isNotEmpty) {url+="&yq=$title";}
    if(ddh.isNotEmpty) {url+="&ddh=$ddh";}
    if(dateVal.isNotEmpty) {url+="&dateVal=${Uri.encodeComponent(dateVal!)}";}
    OrdersEntity? orderEntity = await requestClient.get<OrdersEntity>(url,onError: (e){
      return e.code==0;
    });
    if(orderEntity!=null)
    {
      setState(() {
        pageCount=orderEntity.pageCount;
      });
      return orderEntity.data;
    }
   return null;
  }
  late  int oIndex=-1;
  @override
  void initState() {
    super.initState();
    bus.on("doAction", (arg){
      debugPrint("order_doAction_index:$arg");
      debugPrint("order_doAction_oIndex:$oIndex");
      if(arg!=null)
      {
        int _index=int.parse(arg.toString());
        if(oIndex!=_index)
        {
          debugPrint("执行订单请求");
          oIndex=_index;
          String curZt=ztItems[_index];
          setState(() {
            btnIndex=_index;
            page=1;
          });
          if(curZt=="全部")
          {
            setState(() {zt="";page=1; btnIndex = _index;});
          }
          else
          {
            setState(() {  zt=curZt;page=1;btnIndex = _index;});
          }
          Future<List<OrdersData>?> fod2= loadData();
          fod2.then((fod11)  {
            setState(() {
              orders=fod11!;
            });
          });
        }
      }
    });
    bus.on("setGames",(arg){
      Future<List<GameEntity>?> flGame2= loadGames();
      flGame2.then((fga2)  {
        setState(() {
          games=fga2!;
        });
      });
    });
    // Future<List<OrdersData>?> fod= loadData();
    // fod.then((fod)  {
    //   setState(() {
    //     orders=fod!;
    //   });
    // });
   loadGameAndStaus();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    String osPlat= Platform.operatingSystem;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body:Column(
    children: [
    Container(
    height: 106,
      padding: const EdgeInsets.only(top: 36,bottom: 0),
      decoration:  const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xffFFEBE5),
              Color(0xffFFFFFF),
            ]),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16),bottomRight: Radius.circular(16)),
      ),
      child:Column(children: [
        Row(
            children: [
              const Spacer(),
              const Text("我的发单",style: TextStyle(color: Color(0xFF333333), fontSize: 18)),
              const Spacer(),
              ConstrainedBox(
                constraints:  BoxConstraints(
                    maxHeight: 36,
                    maxWidth: MediaQuery.of(context).size.width-120
                ),
                child:   TextField(
                  maxLines: 1,
                  controller: textDdh,
                  style:const TextStyle(color: Colors.white),
                  textInputAction: TextInputAction.go,
                  onSubmitted: (value){
                    logger.d(value);
                    title=value;
                    Future<List<OrdersData>?> fod= loadData();
                    fod.then((fod)  {
                      setState(() {
                        orders=fod!;
                      });
                    });
                  },
                  decoration:  InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 2.0,vertical: 0),
                      hintText: '请输入标题/订单号查询',
                      hintStyle: const TextStyle(color: Color(0xFF999999)),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: textDdh.text.isNotEmpty?IconButton(
                        onPressed: (){textDdh.clear();},
                        icon: const Icon(Icons.clear),
                      ):null,
                      filled: true,
                      fillColor: const Color.fromRGBO(255, 255, 255, 1),
                      border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius:
                          BorderRadius.all(Radius.circular(20)))),
                ),
              ),
              const Spacer(),
            ]
        ),
        Row(
            children:  [
              const Spacer(),
              Container(
                width:136,
                height: 32,
                margin: const EdgeInsets.only(left: 0,top: 1),
                child: wGame(),
              ),
              const Spacer(),
              Container(
                width:100,
                height: 32,
                margin: const EdgeInsets.only(left: 0,top: 1),
                child: wDllx(),
              ), const Spacer(),
              Container(
                width:100,
                height: 32,
                margin: const EdgeInsets.only(left: 0,top: 1),
                child: wDate(),
              ),
              const Spacer(),
            ]
        ),
      ]),
    ),
    Container(
    height: 38,
    width: MediaQuery.of(context).size.width,
    padding: const EdgeInsets.all(0),
    margin: const EdgeInsets.only(top: 0),
    child: Flex(
    direction: Axis.horizontal,
    children: [
    Expanded(
    flex: 7,
    child:Container(
    height: 36,
    padding: const EdgeInsets.only(top: 0,bottom: 0,right: 6),
    child: ListView.builder(
    scrollDirection:Axis.horizontal,
    itemCount: 5,
    shrinkWrap:true,
    padding: const EdgeInsets.all(0),
    physics:const NeverScrollableScrollPhysics(),
    itemBuilder: (context, index) {
    return btnWidget(text: ztItems[index],index:index,onPressed: () {
    var curZt= ztItems[index];
    if(curZt=="全部")
    {
    setState(() {zt="";page=1; btnIndex = index;});
    }
    else
    {
    setState(() {  zt=curZt;page=1;btnIndex = index;});
    }
    Future<List<OrdersData>?> fod= loadData();
    fod.then((fod)  {
    setState(() {
    orders=fod!;
    });
    });
    });
    }
    )
    ),
    ),
    ButtonPopover(btnIndex,ztItems2)
    ],
    ),
    ),
    Container(
    height: MediaQuery.of(context).size.height-(osPlat=="android"?200:236),
    width: MediaQuery.of(context).size.width,
    padding:  const EdgeInsets.all(0),
    margin:  const EdgeInsets.only(top: 0),
    child:SmartRefresher(
    enablePullDown: true,
    enablePullUp: true,
    header: const WaterDropHeader(),
    footer: const ClassicFooter(
    height: 46,
    loadingText: "加载中",
    noDataText: "没有了呀",
    loadStyle: LoadStyle.ShowWhenLoading,
    completeDuration: Duration(milliseconds: 300),
    ),
    controller: _refreshController,
    onRefresh: _onRefresh,
    onLoading: _onLoading,
    child: ListView.builder(
    itemBuilder: (c, i)=> InkWell(
    onTap: (){
    goDetail(i);
    },
    child: Container(
    decoration:   const BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(6.0)),
    ),
    margin:  const EdgeInsets.only(left: 16,right: 16,top: 10),
    width: MediaQuery.of(context).size.width,
    height: 346,
    child: Column(children: [
    Container(
    decoration:   const BoxDecoration(
    border:  Border(bottom: BorderSide(width:1, color: Color.fromRGBO(247, 249, 253, 1))),
    ),
    margin:  const EdgeInsets.only(left: 0),
    padding: const EdgeInsets.only(left: 10),
    width: MediaQuery.of(context).size.width-20,
    height: 36,
    child: Row(children: [
    Text("订单号:${orders[i].ddh}",style: const TextStyle(color: Color(0xFF999999), fontSize: 14)),
    IconButton(onPressed: () {
    Clipboard.setData(ClipboardData(text:orders[i].ddh));
    EasyLoading.showSuccess("已复制粘贴板");
    }, icon:const Image(image: AssetImage("images/btn_copy.png"),width: 14,height:14)),
    const Spacer(),
    const Spacer(),
    const Spacer(),
    const Spacer(),
    const Spacer(),   const Spacer(),
    Text(orders[i].zt,style: const TextStyle(color: Color(0xFF999999), fontSize: 14)),
    const Spacer(),
    const Spacer()
    ]
    )
    ),
    Container(
    margin:  const EdgeInsets.only(left: 0,top: 6),
    padding: const EdgeInsets.only(left: 10),
    width: MediaQuery.of(context).size.width-20,
    height: 28,
    child: Text(orders[i].yq,
    overflow: TextOverflow.ellipsis,maxLines: 1,softWrap: false,textAlign: TextAlign.left,
    style:  TextStyle(color:orders[i].zdyys==""?null:Color(hexStringToHexInt(orders[i].zdyys)), fontSize: 18,fontWeight: FontWeight.bold))
    ),
    Container(
    margin:  const EdgeInsets.only(left: 0,top: 6),
    padding: const EdgeInsets.only(left: 10),
    width: MediaQuery.of(context).size.width-20,
    height: 18,
    child: Row(
    children:   [
    const Image(image: AssetImage("images/icon_game.png"),width: 15,height:15),
    const Text("  游戏名 ", style: TextStyle(color: Color(0xFF999999), fontSize: 14)),
    Text("${orders[i].yxmc}|${orders[i].dq}|${orders[i].qh}", style: const TextStyle(color: Color(0xFF333333), fontSize: 14)),
    ],
    )
    ),
    Container(
    margin:  const EdgeInsets.only(left: 0,top: 6),
    padding: const EdgeInsets.only(left: 10),
    width: MediaQuery.of(context).size.width-20,
    height: 18,
    child: Row(
    children:   [
    const Image(image: AssetImage("images/icon_role.png"),width: 15,height:15),
    const Text("  角色名 ", style: TextStyle(color: Color(0xFF999999), fontSize: 14)),
    Text(orders[i].js, style: const TextStyle(color: Color(0xFF333333), fontSize: 14)),
    const Spacer(),
    const Spacer(),
    const Spacer(),
    ],
    )
    ),
    Container(
    decoration:   const BoxDecoration(
    border:  Border(bottom: BorderSide(width:1, color: Color.fromRGBO(247, 249, 253, 1))),
    ),
    margin:  const EdgeInsets.only(left: 0,top: 6),
    padding: const EdgeInsets.only(left: 10,bottom: 6),
    width: MediaQuery.of(context).size.width-20,
    height: 28,
    child: Row(
    children:   [
    const Image(image: AssetImage("images/icon_time.png"),width: 15,height:15),
    const Text("  总时间 ", style: TextStyle(color: Color(0xFF999999), fontSize: 14)),
    Text("${orders[i].dlsj}小时", style: const TextStyle(color: Color(0xFF333333), fontSize: 14)),
    const Spacer(),
    const Spacer(),
    const Spacer(),
    const Spacer(),
    const Spacer(),
    const Text("总保证金:", style: TextStyle(color: Color(0xFF999999), fontSize: 14)),
    const Text("￥", style: TextStyle(color: Color(0xFFff5201), fontSize: 12)),
    Text("${orders[i].aqbzj+orders[i].xlbzj}.00", style: const TextStyle(color: Color(0xFFff5201), fontSize: 14)),
    const Spacer(),
    ],
    )
    ),
    Container(
    // decoration:  const BoxDecoration(
    //   border:  Border(top:  BorderSide(width: 0.8, color: Colors.red),bottom: BorderSide(width: 0.8, color: Colors.red)),
    // ),
    margin:  const EdgeInsets.only(left: 0,top: 0),
    padding: const EdgeInsets.only(left: 10),
    width: MediaQuery.of(context).size.width-20,
    height: 28,
    child:
    Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
    const Image(image: AssetImage("images/icon_price.png"),width: 15,height:15),
    const Text("  发单价 ", style: TextStyle(color: Color(0xFF999999), fontSize: 14)),
    const Spacer(),
    const Spacer(),
    const Spacer(),
    const Spacer(),  const Spacer(),  const Spacer(),  const Spacer(),  const Spacer(),
    const Text("￥",style: TextStyle(color: Color(0xFFff5201), fontSize: 12,fontWeight: FontWeight.w600)),

    Text("${orders[i].zc}",style: const TextStyle(color: Color(0xFFff5201), fontSize: 22,fontWeight: FontWeight.w600)),
    const Spacer(),
    ]
    )
    ),
    Container(
    decoration:   const BoxDecoration(
    color:  Color(0xFFF5F5F5),
    borderRadius: BorderRadius.all(Radius.circular(5)),
    ),
    margin:  const EdgeInsets.only(left: 10,top: 6,right: 10),
    padding: const EdgeInsets.only(left: 0),
    width: MediaQuery.of(context).size.width-20,
    height: 28,
    child:
    Row(
    children: [
    const Spacer(),
    const Spacer(),
    const Spacer(),
    const Spacer(),
    const Spacer(),
    const Spacer(),
    const Spacer(),   const Spacer(),   const Spacer(),
    const Spacer(),   const Spacer(),   const Spacer(),
    const Text("接单价:", style: TextStyle(color: Color(0xFF999999), fontSize: 14)),
    Text("￥${"${orders[i].sr}.00"}", style: const TextStyle(color: Color(0xFFFF5201), fontSize: 14)),
    const Spacer(),
    const Text("利润:", style: TextStyle(color: Color(0xFF999999), fontSize: 14)),
    Text("￥${"${orders[i].lr}.00"}", style: const TextStyle(color: Color(0xFFFF5201), fontSize: 14)),
    const Spacer()
    ]
    )
    ),
    Container(
    margin:  const EdgeInsets.only(left: 10,top: 2,right: 10),
    padding: const EdgeInsets.only(left: 0),
    width: MediaQuery.of(context).size.width-20,
    height: 40,
    child:  orderWidget(i)
    ),
    Container(
    decoration:  const BoxDecoration(
    border:  Border(
    top: BorderSide(width:1, color: Color.fromRGBO(247, 249, 253, 1)),
    bottom: BorderSide(width:1, color: Color.fromRGBO(247, 249, 253, 1))
    ),
    ),
    margin:  const EdgeInsets.only(left: 0,top: 2),
    padding: const EdgeInsets.all(0),
    width: MediaQuery.of(context).size.width-20,
    height: 36,
    child: Row(
    children:   [
    const Spacer(),
    SizedBox(width: 30,height: 30,
    child:IconButton(onPressed: () {
    String qjSTR="${orders[i].yxmc}/${orders[i].dq}/${orders[i].qh}";
    qjSTR+="\n代练任务：${orders[i].yq}";
    qjSTR+="\n订单价格：${orders[i].zc}元";
    qjSTR+="\n代练时间：${orders[i].dlsj}小时";
    Clipboard.setData(ClipboardData(text:qjSTR));
    EasyLoading.showSuccess("已复制粘贴板");
    }, icon:const Image(image: AssetImage("images/btn_copy.png"),width: 30,height:30))
    ),
    const Text("复制订单信息",style: TextStyle(color: Color(0xFF999999), fontSize: 12)),
    const Spacer(),
    SizedBox(width: 30,height: 30,
    child:IconButton(
    onPressed: () {
    if(orders[i].zdyys.isNotEmpty)
    {
    currentColor=Color(hexStringToHexInt(orders[i].zdyys));
    }
    showDialog(
    context: context,
    builder: (BuildContext ctx) {
    return AlertDialog(
    titlePadding: const EdgeInsets.all(0),
    contentPadding: const EdgeInsets.all(0),
    content: BlockPicker(
    pickerColor: currentColor,
    onColorChanged: changeColor
    ), actions: <Widget>[
    ElevatedButton(
    child: const Text('确定'),
    onPressed: () {
    setState((){
    orders[i].zdyys=currentColor.toHexTriplet();
    //logger.d("orders[${i}].zdyys=${orders[i].zdyys}");
    });
    setColor(orders[i].id);
    Navigator.of(ctx).pop();
    },
    ),
    ]
    );
    },
    );
    } ,
    icon:Image(image: const AssetImage("images/btn_ling.png"),
    color:orders[i].zdyys==""?null:Color(hexStringToHexInt(orders[i].zdyys)),
    width: 30,height:30)
    )
    ),
    const Text("更改标题颜色",style: TextStyle(color: Color(0xFF999999), fontSize: 12)),
    const Spacer(),
    SizedBox(width: 30,height: 30,
    child:IconButton(onPressed: () async{
    final textInput = await showTextInputDialog(
    context: context,title: '备注',okLabel: "确定",cancelLabel: "取消",
    textFields:  [
    DialogTextField(hintText: '请输入订单备注',
    initialText: orders[i].bzxx1,
    maxLength: 100,
    keyboardType: TextInputType.text,validator: (value) => value!.isEmpty ? '不能为空' : null)
    ]
    );
    String? bzxx=textInput?.elementAt(0).toString();
    if(bzxx!.isNotEmpty)
    {
    setState(() {
    orders[i].bzxx1=bzxx;
    });
    setRemark(orders[i].id,bzxx);
    }
    }, icon:const Image(image: AssetImage("images/btn_tag.png"),width: 28,height:28))
    ),
    const Text("添加订单备注",style: TextStyle(color: Color(0xFF999999), fontSize: 12)),
    const Spacer(),
    ],
    )
    ),
    Container(
    alignment:Alignment.centerLeft,
    margin:  const EdgeInsets.only(left: 0,top:1),
    padding: const EdgeInsets.only(top: 6,left: 6),
    width: MediaQuery.of(context).size.width,
    height: 40,
    child:Text(orders[i].zt=="代练中"? "接单平台:${orders[i].dlpt}":"发单平台:${orders[i].kfpt}",style: const TextStyle(color: Color(0xFF999999), fontSize: 13))
    ),
    ])
    )) ,
    itemCount: orders.length,
    ),
    ),
    )
    ]
    )
    );
  }
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}


class ButtonPopover extends StatefulWidget {
  final int selectedIndex2;
  final List<String> ztItems2;
  const ButtonPopover(this.selectedIndex2, this.ztItems2, {super.key}) ;

  @override
  State<ButtonPopover> createState() => _ButtonPopoverState();
}
class _ButtonPopoverState extends State<ButtonPopover> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: GestureDetector( onTap: ()async{
        var popIndex=await showPopover(
          context: context,
          bodyBuilder: (BuildContext context) {
            return  BtnMore(ztItems: widget.ztItems2,selectedIndex: widget.selectedIndex2);
          },
          direction: PopoverDirection.bottom,
          radius: 0,contentDyOffset:6,
          width: MediaQuery.of(context).size.width,
          height: 280,
          arrowHeight: 0,
          arrowWidth: 0,
        );
        if(popIndex!=null)
        {
          bus.emit('doAction', popIndex.toString());
        }
      },child:Container(
        color: Colors.white,
        padding:  const EdgeInsets.all(0),
        margin:  const EdgeInsets.all(0),
        child: const Image(image:  AssetImage('images/btn_more.png'),width: 16,height: 14),
        )
      ),
    );
  }
}