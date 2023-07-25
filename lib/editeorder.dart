
import 'package:flutter/material.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lanzhong/request/request_client.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/api_response/list_data.dart';
import 'model/dq_entity.dart';
import 'model/game_entity.dart';
import 'model/orders_entity.dart';
import 'model/xq_entity.dart';
class EditOrderPage extends StatefulWidget {
  final int id;
  final int oindex;
  const EditOrderPage({Key? key, required this.id, required this.oindex}) : super(key: key);
  @override
  State<EditOrderPage> createState() => _EditOrderPageState();
}


class _EditOrderPageState extends State<EditOrderPage> {
  late OrdersData  order=OrdersData();
  void loadData() async{
    RequestClient requestClient = RequestClient();
    String url = "/Order/GetDetailView?id=${widget.id}";
    OrdersData? pte = await requestClient.get<OrdersData>(url,onError: (e){
      return e.code==0;
    });
    if(pte!=null)
    {
      setState(() {
        order=pte;
        yxid=order.yxid;
        selectGame=order.yxmc;
      });
      yqController.text=order.yq;
      zcController.text=order.zc.toString();
      srController.text=order.sr.toString();
      dlsjController.text=order.dlsj.toString();
      aqjController.text=order.aqbzj.toString();
      xljController.text=order.xlbzj.toString();
      zhController.text=order.zh;
      mmController.text=order.mm;
      jsController.text=order.js;

      ddlyController.text=order.ddly;
      ddhController.text=order.ddh;
      sjController.text=order.sj;
      wwController.text=order.ww;
      bzxxController.text=order.bzxx1;
      loadServers2(order.yxid);
    }
  }
  List<GameEntity>? lsGame=[];
  List<DqDllxs>? dllx=[];
  List<DqServers>? dqs=[];
  List<XqAreas>? xqs=[];
  RequestClient requestClient = RequestClient();
  var logger = Logger(printer: PrettyPrinter());
  late FocusNode yqFocus;
  late FocusNode zcFocus;
  late FocusNode srFocus;
  late FocusNode dlsjFocus;
  late FocusNode aqjFocus;
  late FocusNode xljFocus;
  late FocusNode zhFocus;
  late FocusNode mmFocus;
  late FocusNode jsFocus;
  late FocusNode yxbtnFocus;

  TextEditingController yqController = TextEditingController();
  TextEditingController zcController = TextEditingController();
  TextEditingController srController = TextEditingController();
  TextEditingController dlsjController = TextEditingController();
  TextEditingController aqjController = TextEditingController();
  TextEditingController xljController = TextEditingController();
  TextEditingController zhController = TextEditingController();
  TextEditingController mmController = TextEditingController();
  TextEditingController jsController = TextEditingController();//游戏角色
  TextEditingController ddlyController = TextEditingController();//来源
  TextEditingController ddhController = TextEditingController();//订单号
  TextEditingController sjController = TextEditingController();//买家手机
  TextEditingController wwController = TextEditingController();//旺旺
  TextEditingController bzxxController = TextEditingController();//旺旺
  @override
  void initState()  {
    super.initState();
    yqFocus=FocusNode();
    zcFocus=FocusNode();
    srFocus=FocusNode();
    dlsjFocus=FocusNode();
    aqjFocus=FocusNode();
    xljFocus=FocusNode();
    zhFocus=FocusNode();
    mmFocus=FocusNode();
    jsFocus=FocusNode();
    yxbtnFocus=FocusNode();
    Future.delayed(const Duration(milliseconds: 200)).then((value) async{
      String url="/Order/LoadGames";
      await requestClient.get<ListData<GameEntity>>(url,showLoading: true,onError: (e){
        return e.code==0;
      }).then((value) {
        if(value!=null)
        {
          lsGame=value.data;
          loadData();
        }
      });
    });
  }
  String selectGame="请选择";
  String selectServer="请选择";
  String selectArea="请选择";
  String selectDllx="请选择";
  int yxid=0;
  int userGameTypeId=0;
  //
  void loadServers(int gid) async {
    String url="/Order/DLAndServer";
    Map<String,dynamic> dic={"gid":gid};
    DqEntity? dqe = await requestClient.get<DqEntity>(url,queryParameters: dic,onError: (e){
      return e.code==0;
    });
    if(dqe!=null)
    {
      dllx=dqe.dllxs;
      dqs=dqe.servers;
    }
  }
  void loadServers2(int gid) async {
    String url="/Order/DLAndServer";
    Map<String,dynamic> dic={"gid":gid};
    DqEntity? dqe = await requestClient.get<DqEntity>(url,queryParameters: dic,onError: (e){
      return e.code==0;
    });
    if(dqe!=null)
    {
      setState(() {
        dllx=dqe.dllxs;
        dqs=dqe.servers;
        selectServer=order.dq;
        selectDllx=order.dllx;
        debugPrint("代练类型：$selectDllx");
        userGameTypeId=order.userGameTypeId;
        DqServers? dq=dqs!.where((element) => element.gameServerName==selectServer).first;
        loadAreas2(dq.id);
      });
    }
  }
  void loadAreas(int serverId) async {
    String url="/Order/LoadAreas";
    Map<String,dynamic> dic={"serverId":serverId};
    XqEntity? xqe = await requestClient.get<XqEntity>(url,queryParameters: dic,onError: (e){
      return e.code==0;
    });
    if(xqe!=null)
    {
      xqs=xqe.areas;
    }
  }
  void loadAreas2(int serverId) async {
    String url="/Order/LoadAreas";
    Map<String,dynamic> dic={"serverId":serverId};
    XqEntity? xqe = await requestClient.get<XqEntity>(url,queryParameters: dic,onError: (e){
      return e.code==0;
    });
    if(xqe!=null)
    {
      xqs=xqe.areas;
      setState(() {
        selectArea=order.qh;
      });
    }
  }
  void showGames() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text("请选择一个游戏"),
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (ctx, index) {
                  return SimpleDialogOption(
                    onPressed: (){
                      Navigator.pop(context);
                      setState(() {
                        selectGame=lsGame![index].yxmc;
                        selectServer="请选择";
                        selectArea="请选择";
                        selectDllx="请选择";
                        yxid= lsGame![index].id;
                        order.yxid=yxid;
                        order.yxmc=selectGame;
                      });
                      loadServers(yxid);
                    },
                    child: Center(
                      child: Text(lsGame![index].yxmc),
                    ),
                  );
                },
                itemCount: lsGame!.length,
              ),
            )
          ],
        );
      },
    );
  }
  void showServers() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title:  const Text("请选择一个大区"),
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (ctx, index) {
                  return SimpleDialogOption(
                    onPressed: (){
                      Navigator.pop(context);
                      setState(() {
                        selectServer=dqs![index].gameServerName;
                        selectArea="请选择";
                        order.dq=selectServer;
                      });
                      loadAreas(dqs![index].id);
                    },
                    child: Center(
                      child: Text(dqs![index].gameServerName),
                    ),
                  );
                },
                itemCount: dqs!.length,
              ),
            )
          ],
        );
      },
    );
  }
  void showAreas() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title:  const Text("请选择一个小区"),
          children: [
            SingleChildScrollView(child:  SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 360,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (ctx, index) {
                    return SimpleDialogOption(
                      onPressed: (){
                        Navigator.pop(context);
                        setState(() {
                          selectArea=xqs![index].gameAreaName;
                          order.qh=selectArea;
                        });
                      },
                      child: Center(
                        child: Text(xqs![index].gameAreaName),
                      ),
                    );
                  },
                  itemCount: xqs!.length,
                  itemExtent: 36,
                )
            ) )

          ],
        );
      },
    );
  }
  void showDllx() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title:  const Text("请选择一个代练类型"),
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (ctx, index) {
                  return SimpleDialogOption(
                    onPressed: (){
                      Navigator.pop(context);
                      setState(() {
                        selectDllx=dllx![index].dllx;
                        userGameTypeId=dllx![index].id;
                        order.userGameTypeId=userGameTypeId;
                      });
                    },
                    child: Center(
                      child: Text(dllx![index].dllx),
                    ),
                  );
                },
                itemCount: dllx!.length,
              ),
            )
          ],
        );
      },
    );
  }

  Future<void> saveAsyncMethod(BuildContext context,int sffd) async {
    if (context.mounted)
    {
      if(yxid==0)
      {
        await showOkAlertDialog(context: context, title: '提示', message: '请选择一个游戏.').then((value) {
        });
        return;
      }
      if(selectServer=="请选择")
      {
        await showOkAlertDialog(context: context, title: '提示', message: '请选择一个大区').then((value) {
        });
        return;
      }
      if(selectArea=="请选择")
      {
        await showOkAlertDialog(context: context, title: '提示', message: '请选择一个小区').then((value) {
        });
        return;
      }
      if(userGameTypeId==0)
      {
        await showOkAlertDialog(context: context, title: '提示', message: '请选择一个代练类型.').then((value) {
        });
        return;
      }
      if(yqController.text.trim()=="")
      {
        await showOkAlertDialog(context: context, title: '提示', message: '代练内容不能为空.').then((value) {
          yqFocus.requestFocus();
        });
        return;
      }
      if(zcController.text.trim()=="")
      {
        await showOkAlertDialog(context: context, title: '提示', message: '发单价不能为空.').then((value) {
          zcFocus.requestFocus();
        });
        return;
      }
      if(srController.text.trim()=="")
      {
        await showOkAlertDialog(context: context, title: '提示', message: '接单价不能为空.').then((value) {
          srFocus.requestFocus();
        });
        return;
      }
      if(dlsjController.text.trim()=="")
      {
        await showOkAlertDialog(context: context, title: '提示', message: '代练时间不能为空.').then((value) {
          dlsjFocus.requestFocus();
        });
        return;
      }
      if(aqjController.text.trim()=="")
      {
        await showOkAlertDialog(context: context, title: '提示', message: '安全金不能为空.').then((value) {
          aqjFocus.requestFocus();
        });
        return;
      }
      if(xljController.text.trim()=="")
      {
        await showOkAlertDialog(context: context, title: '提示', message: '效率金不能为空.').then((value) {
          xljFocus.requestFocus();
        });
        return;
      }
      if(zhController.text.trim()=="")
      {
        await showOkAlertDialog(context: context, title: '提示', message: '效率金不能为空.').then((value) {
          zhFocus.requestFocus();
        });
        return;
      }
      if(mmController.text.trim()=="")
      {
        await showOkAlertDialog(context: context, title: '提示', message: '密码不能为空.').then((value) {
          mmFocus.requestFocus();
        });
        return;
      }
      if(jsController.text.trim()=="")
      {
        await showOkAlertDialog(context: context, title: '提示', message: '角色不能为空.').then((value) {
          jsFocus.requestFocus();
        });
        return;
      }
      SharedPreferences prefs =await SharedPreferences.getInstance();
      Map<String, dynamic> dic = {
        "Id": order.id,
        "yxid": yxid,
        "dq": selectServer,
        "qh": selectArea,
        "UserGameTypeId": userGameTypeId,
        "yq": yqController.text.trim(),
        "zc": zcController.text.trim(),
        "sr": srController.text.trim(),
        "dlsj": dlsjController.text.trim(),
        "aqbzj": aqjController.text.trim(),
        "xlbzj": xljController.text.trim(),
        "zh": zhController.text.trim(),
        "mm": mmController.text.trim(),
        "js": jsController.text.trim(),
        "ddly": ddlyController.text.trim(),
        "ddh": ddhController.text.trim(),
        "sj": sjController.text.trim(),
        "ww": wwController.text.trim(),
        "bzxx1": bzxxController.text.trim(),
      };
      order.yxid=yxid;
      order.dq=selectServer;
      order.qh=selectArea;
      order.userGameTypeId=userGameTypeId;
      order.yq=yqController.text.trim();
      order.zc=int.parse(zcController.text.trim());
      order.sr=int.parse(srController.text.trim());
      order.lr= order.sr-order.zc;
      order.dlsj=int.parse(dlsjController.text.trim());
      order.aqbzj=int.parse(aqjController.text.trim());
      order.xlbzj=int.parse(xljController.text.trim());
      order.zh=zhController.text.trim();
      order.mm=mmController.text.trim();
      order.js=jsController.text.trim();
      order.ddly=ddlyController.text.trim();
      order.ddh=ddhController.text.trim();
      order.sj=sjController.text.trim();
      order.ww=wwController.text.trim();
      order.bzxx1=bzxxController.text.trim();
      await EasyLoading.show(status: '验证中...', maskType: EasyLoadingMaskType.black);
      String url="/Order/EditAll";
      await requestClient.post(url,data: dic,onError: (e){
        EasyLoading.showError(e.message!);
        return e.code==0;
      },onSuccess: (res)async{
        if(res.code==0)
        {
          await EasyLoading.showSuccess("编辑成功");
          Future.delayed(const Duration(milliseconds: 600), () {
            Navigator.of(context).pop(order);
          });
        }
        else
        {
          await EasyLoading.showSuccess("编辑失败");
        }
      });
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:SingleChildScrollView(child: Container(
        alignment: Alignment.topCenter,
        decoration: const BoxDecoration(
          color: Color(0xFFF7F9FD),
        ),
        width: MediaQuery.of(context).size.width,
        child: Column(children: [
          Stack(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width * 350 / 750,
                    alignment: Alignment.topCenter,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('images/main_cover.png'),
                          fit: BoxFit.fitWidth, // 完全填充
                        )
                    )
                ),
                Container(
                  width: 26,
                  height: 32,
                  padding: const EdgeInsets.all(0),
                  margin: const  EdgeInsets.only(left: 10,top:46),
                  child:  IconButton(onPressed: () {
                    Navigator.pop(context);
                  }, icon:  Image.asset("images/arrow_left.png",width: 21)),
                ),
                Container(
                  width: 100,
                  height: 32,
                  alignment: Alignment.centerLeft,
                  margin: const  EdgeInsets.only(left: 40,top:46),
                  child: const Text("编辑订单",style: TextStyle(color: Colors.white, fontSize: 20)),
                ),

                Container(
                    decoration:  const BoxDecoration(
                      color: Colors.white,
                      border:  Border(bottom: BorderSide(width: 0.6, color: Colors.black12)),
                    ),
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 80),
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.topLeft,
                    child: Stack(
                        children:  [
                          Container(
                            margin: const EdgeInsets.only(top: 10, left: 10,bottom: 10),
                            alignment: Alignment.topLeft,
                            child:  const Text("发单基本信息", style: TextStyle(color: Color.fromRGBO(51, 51, 51, 1), fontSize: 16)),
                          ),
                          const Positioned(
                            right: 16,
                            top: 16,
                            width: 12,
                            height: 12,
                            child: Image(image: AssetImage("images/arrow_down.png"), width: 20.0, height: 14.0),
                          )
                        ]
                    )
                ),
                Container(
                    decoration:  const BoxDecoration(
                      color: Colors.white,
                    ),
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 121.3),
                    padding: const EdgeInsets.only(bottom: 10),
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.topLeft,
                    child: Column(
                      children:  [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children:  [
                              Container(
                                width:20,
                                margin: const EdgeInsets.only(left: 1,top: 10),
                                child: const Text("*",style: TextStyle(color: Color.fromRGBO(255, 141, 87, 1), fontSize: 16),textAlign: TextAlign.end),
                              ),
                              Container(
                                width:70,
                                margin: const EdgeInsets.only(left: 2,top: 10),
                                child:const Text("游戏名称",style: TextStyle(color: Color(0xff333333), fontSize: 14)),
                              ),
                              const Spacer(),
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                child:  TextButton(
                                  focusNode: yxbtnFocus,
                                  style: ButtonStyle(
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap, // 设置点击区域尺寸跟随内容大小
                                    minimumSize: MaterialStateProperty.all( const Size(0, 0)),
                                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                                  ),
                                  child:  Text(selectGame,style: const TextStyle(color: Color(0xff333333), fontSize: 14)),
                                  onPressed: () {
                                    showGames();
                                  },
                                ),
                              ),
                              Container(
                                  margin: const EdgeInsets.only(left: 10,top: 10,right: 10),
                                  child: const Image(image: AssetImage("images/arrow_right.png"), width: 9.0, height: 15.0))
                            ]
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children:  [
                              Container(
                                width:20,
                                margin: const EdgeInsets.only(left: 1,top: 10),
                                child: const Text("*",style: TextStyle(color: Color.fromRGBO(255, 141, 87, 1), fontSize: 16),textAlign: TextAlign.end),
                              ),
                              Container(
                                width:70,
                                margin: const EdgeInsets.only(left: 2,top: 10),
                                child:const Text("游戏大区",style: TextStyle(color: Color(0xff333333), fontSize: 14)),
                              ),
                              const Spacer(),
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                child:  TextButton(
                                  style: ButtonStyle(
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap, // 设置点击区域尺寸跟随内容大小
                                    minimumSize: MaterialStateProperty.all( const Size(0, 0)),
                                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                                  ),
                                  child:  Text(selectServer,style: const TextStyle(color: Color(0xff333333), fontSize: 14)),
                                  onPressed: () {
                                    showServers();
                                  },
                                ),
                              ),

                              Container(
                                margin: const EdgeInsets.only(left: 10,top: 10,right: 10),
                                child: const Image(image: AssetImage("images/arrow_right.png"), width: 9.0, height: 15.0),
                              )
                            ]
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children:  [
                              Container(
                                width:20,
                                margin: const EdgeInsets.only(left: 1,top: 10),
                                child: const Text("*",style: TextStyle(color: Color.fromRGBO(255, 141, 87, 1), fontSize: 16),textAlign: TextAlign.end),
                              ),
                              Container(
                                width:70,
                                margin: const EdgeInsets.only(left: 2,top: 10),
                                child:const Text("游戏小区",style: TextStyle(color: Color(0xff333333), fontSize: 14)),
                              ),
                              const Spacer(),
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                child:  TextButton(
                                  style: ButtonStyle(
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap, // 设置点击区域尺寸跟随内容大小
                                    minimumSize: MaterialStateProperty.all( const Size(0, 0)),
                                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                                  ),
                                  child:  Text(selectArea,style: const TextStyle(color: Color(0xff333333), fontSize: 14)),
                                  onPressed: () {
                                    showAreas();
                                  },
                                ),
                              ),

                              Container(
                                margin: const EdgeInsets.only(left: 10,top: 10,right: 10),
                                child: const Image(image: AssetImage("images/arrow_right.png"), width: 9.0, height: 15.0),
                              )
                            ]
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:  [
                            Container(
                              width:20,
                              margin: const EdgeInsets.only(left: 1,top: 10),
                              child: const Text("*",style: TextStyle(color: Color.fromRGBO(255, 141, 87, 1), fontSize: 16),textAlign: TextAlign.end),
                            ),
                            Container(
                              width:70,
                              margin: const EdgeInsets.only(left: 2,top: 10),
                              child:const Text("代练类型",style: TextStyle(color: Color(0xff333333), fontSize: 14)),
                            ),
                            const Spacer(),
                            Container(
                              margin: const EdgeInsets.only(top: 6),
                              child:  TextButton(
                                style: ButtonStyle(
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap, // 设置点击区域尺寸跟随内容大小
                                  minimumSize: MaterialStateProperty.all( const Size(0, 0)),
                                  padding: MaterialStateProperty.all(EdgeInsets.zero),
                                ),
                                child:   Text(selectDllx,style: const TextStyle(color: Color(0xff333333), fontSize: 14)),
                                onPressed: () {
                                  showDllx();
                                },
                              ),
                            ),

                            Container(
                              margin: const EdgeInsets.only(left: 10,top: 6,right: 10),
                              child: const Image(image: AssetImage("images/arrow_right.png"), width: 9.0, height: 15.0),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:  [
                            Container(
                              width:20,
                              margin: const EdgeInsets.only(left: 1,top: 10),
                              child: const Text("*",style: TextStyle(color: Color.fromRGBO(255, 141, 87, 1), fontSize: 16),textAlign: TextAlign.end),
                            ),
                            Container(
                              width:70,
                              margin: const EdgeInsets.only(left: 2,top: 10),
                              child:const Text("代练内容",style: TextStyle(color: Color(0xff333333), fontSize: 14)),
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width-150,height: 32,
                                margin: const EdgeInsets.only(top: 2),
                                child:   TextField(
                                  controller: yqController,
                                  focusNode: yqFocus,
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(fontSize: 14),
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                    //内容的内边距
                                      contentPadding: EdgeInsets.all(2.0),
                                      hintText: '请输入',
                                      border:InputBorder.none
                                  ),
                                )
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:  [
                            Container(
                              width:20,
                              margin: const EdgeInsets.only(left: 1,top: 10),
                              child: const Text("*",style: TextStyle(color: Color.fromRGBO(255, 141, 87, 1), fontSize: 16),textAlign: TextAlign.end),
                            ),
                            Container(
                              width:70,
                              margin: const EdgeInsets.only(left: 2,top: 10),
                              child:const Text("发单价格",style: TextStyle(color:Color(0xff333333), fontSize: 14)),
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width-150,height: 32,
                                margin: const EdgeInsets.only(top: 2),
                                child:   TextField(
                                    controller: zcController,
                                    focusNode: zcFocus,
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(fontSize: 14),
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      //内容的内边距
                                        contentPadding: EdgeInsets.all(2.0),
                                        hintText: '请输入',
                                        border:InputBorder.none
                                    ),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(6),
                                      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                                    ]
                                )
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:  [
                            Container(
                              width:20,
                              margin: const EdgeInsets.only(left: 1,top: 10),
                              child: const Text("*",style: TextStyle(color: Color.fromRGBO(255, 141, 87, 1), fontSize: 16),textAlign: TextAlign.end),
                            ),
                            Container(
                              width:70,
                              margin: const EdgeInsets.only(left: 2,top: 10),
                              child:const Text("接单价格",style: TextStyle(color: Color(0xff333333), fontSize: 14)),
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width-150,height: 32,
                                margin: const EdgeInsets.only(top: 2),
                                child:   TextField(
                                    controller: srController,
                                    focusNode: srFocus,
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(fontSize: 14),
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      //内容的内边距
                                        contentPadding: EdgeInsets.all(2.0),
                                        hintText: '请输入',
                                        border:InputBorder.none
                                    ),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(6),
                                      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                                    ]
                                )
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:  [
                            Container(
                              width:20,
                              margin: const EdgeInsets.only(left: 1,top: 10),
                              child: const Text("*",style: TextStyle(color: Color.fromRGBO(255, 141, 87, 1), fontSize: 16),textAlign: TextAlign.end),
                            ),
                            Container(
                              width:70,
                              margin: const EdgeInsets.only(left: 2,top: 10),
                              child:const Text("代练时间",style: TextStyle(color: Color(0xff333333), fontSize: 14)),
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width-150,height: 32,
                                margin: const EdgeInsets.only(top: 2),
                                child:   TextField(
                                    controller: dlsjController,
                                    focusNode: dlsjFocus,
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(fontSize: 14),
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      //内容的内边距
                                        contentPadding: EdgeInsets.all(2.0),
                                        hintText: '请输入',
                                        border:InputBorder.none
                                    ),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(6),
                                      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                                    ]
                                )
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:  [
                            Container(
                              width:20,
                              margin: const EdgeInsets.only(left: 1,top: 10),
                              child: const Text("*",style: TextStyle(color: Color.fromRGBO(255, 141, 87, 1), fontSize: 16),textAlign: TextAlign.end),
                            ),
                            Container(
                              width:70,
                              margin: const EdgeInsets.only(left: 2,top: 10),
                              child:const Text("安全金额",style: TextStyle(color: Color(0xff333333), fontSize: 14)),
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width-150,height: 32,
                                margin: const EdgeInsets.only(top: 2),
                                child:   TextField(
                                    controller: aqjController,
                                    focusNode: aqjFocus,
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(fontSize: 14),
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      //内容的内边距
                                        contentPadding: EdgeInsets.all(2.0),
                                        hintText: '请输入',
                                        border:InputBorder.none
                                    ),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(6),
                                      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                                    ]
                                )
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:  [
                            Container(
                              width:20,
                              margin: const EdgeInsets.only(left: 1,top: 10),
                              child: const Text("*",style: TextStyle(color: Color.fromRGBO(255, 141, 87, 1), fontSize: 16),textAlign: TextAlign.end),
                            ),
                            Container(
                              width:70,
                              margin: const EdgeInsets.only(left: 2,top: 10),
                              child:const Text("效率金额",style: TextStyle(color: Color(0xff333333), fontSize: 14)),
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width-150,height: 32,
                                margin: const EdgeInsets.only(top: 2),
                                child:   TextField(
                                    controller: xljController,
                                    focusNode: xljFocus,
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(fontSize: 14),
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      //内容的内边距
                                        contentPadding: EdgeInsets.all(2.0),
                                        hintText: '请输入',
                                        border:InputBorder.none
                                    ),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(6),
                                      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                                    ]
                                )
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:  [
                            Container(
                              width:20,
                              margin: const EdgeInsets.only(left: 1,top: 10),
                              child: const Text("*",style: TextStyle(color: Color.fromRGBO(255, 141, 87, 1), fontSize: 16),textAlign: TextAlign.end),
                            ),
                            Container(
                              width:70,
                              margin: const EdgeInsets.only(left: 2,top: 10),
                              child:const Text("游戏账号",style: TextStyle(color: Color(0xff333333), fontSize: 14)),
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width-150,height: 32,
                                margin: const EdgeInsets.only(top: 2),
                                child:   TextField(
                                  controller: zhController,
                                  focusNode: zhFocus,
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(fontSize: 14),
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                    //内容的内边距
                                      contentPadding: EdgeInsets.all(2.0),
                                      hintText: '请输入',
                                      border:InputBorder.none
                                  ),
                                )
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:  [
                            Container(
                              width:20,
                              margin: const EdgeInsets.only(left: 1,top: 10),
                              child: const Text("*",style: TextStyle(color: Color.fromRGBO(255, 141, 87, 1), fontSize: 16),textAlign: TextAlign.end),
                            ),
                            Container(
                              width:70,
                              margin: const EdgeInsets.only(left: 2,top: 10),
                              child:const Text("游戏密码",style: TextStyle(color: Color(0xff333333), fontSize: 14)),
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width-150,height: 32,
                                margin: const EdgeInsets.only(top: 2),
                                child:   TextField(
                                  controller: mmController,
                                  focusNode: mmFocus,
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(fontSize: 14),
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                    //内容的内边距
                                      contentPadding: EdgeInsets.all(2.0),
                                      hintText: '请输入',
                                      border:InputBorder.none
                                  ),
                                )
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:  [
                            Container(
                              width:20,
                              margin: const EdgeInsets.only(left: 1,top: 10),
                              child: const Text("*",style: TextStyle(color: Color.fromRGBO(255, 141, 87, 1), fontSize: 16),textAlign: TextAlign.end),
                            ),
                            Container(
                              width:70,
                              margin: const EdgeInsets.only(left: 2,top: 10),
                              child:const Text("游戏角色",style: TextStyle(color:Color(0xff333333), fontSize: 14)),
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width-150,height: 32,
                                margin: const EdgeInsets.only(top: 2),
                                child:   TextField(
                                  controller: jsController,
                                  focusNode: jsFocus,
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(fontSize: 14),
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                    //内容的内边距
                                      contentPadding: EdgeInsets.all(2.0),
                                      hintText: '请输入',
                                      border:InputBorder.none
                                  ),
                                )
                            )
                          ],
                        ),
                      ],
                    )
                )
              ]
          ),
          Container(
              decoration:  const BoxDecoration(
                color: Colors.white,
                border:  Border(bottom: BorderSide(width: 0.5, color: Colors.black12)),
              ),
              margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.topLeft,
              child: Stack(
                  children:  [
                    Container(
                      margin: const EdgeInsets.only(top: 10, left: 10,bottom: 10),
                      alignment: Alignment.topLeft,
                      child:  const Text("接单信息(可不填)", style: TextStyle(color: Color.fromRGBO(51, 51, 51, 1), fontSize: 16)),
                    ),
                    const Positioned(
                      right: 16,
                      top: 16,
                      width: 12,
                      height: 12,
                      child: Image(image: AssetImage("images/arrow_down.png"), width: 12.0, height: 12.0),
                    )
                  ]
              )
          ),
          Container(
              decoration:  const BoxDecoration(
                color: Colors.white,
              ),
              margin: const EdgeInsets.only(left: 20, right: 20, top: 0),
              padding: const EdgeInsets.only(bottom: 10),
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.topLeft,
              child: Column(
                children:  [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:  [
                      Container(
                        width:70,
                        margin: const EdgeInsets.only(left: 10,top: 10),
                        child:const Text("订单来源",style: TextStyle(color: Color(0xff333333), fontSize: 14)),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width-160,height: 32,
                          margin: const EdgeInsets.only(top: 2),
                          child:   TextField(
                            controller: ddlyController,
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontSize: 14),
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              //内容的内边距
                                contentPadding: EdgeInsets.all(2.0),
                                hintText: '请输入',
                                border:InputBorder.none
                            ),
                          )
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:  [
                      Container(
                        width:70,
                        margin: const EdgeInsets.only(left: 10,top: 10),
                        child:const Text("发单编号",style: TextStyle(color: Color(0xff333333), fontSize: 14)),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width-160,height: 32,
                          margin: const EdgeInsets.only(top: 2),
                          child:   TextField(
                            controller: ddhController,
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontSize: 14),
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              //内容的内边距
                                contentPadding: EdgeInsets.all(2.0),
                                hintText: '请输入',
                                border:InputBorder.none
                            ),
                          )
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:  [
                      Container(
                        width:70,
                        margin: const EdgeInsets.only(left: 10,top: 10),
                        child:const Text("买家手机",style: TextStyle(color: Color(0xff333333), fontSize: 14)),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width-160,height: 32,
                          margin: const EdgeInsets.only(top: 2),
                          child:   TextField(
                            controller: sjController,
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontSize: 14),
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              //内容的内边距
                                contentPadding: EdgeInsets.all(2.0),
                                hintText: '请输入',
                                border:InputBorder.none
                            ),
                          )
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:  [
                      Container(
                        width:70,
                        margin: const EdgeInsets.only(left: 10,top: 10),
                        child:const Text("买家旺旺",style: TextStyle(color: Color(0xff333333), fontSize: 14)),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width-160,height: 32,
                          margin: const EdgeInsets.only(top: 2),
                          child:   TextField(
                            controller: wwController,
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontSize: 14),
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              //内容的内边距
                                contentPadding: EdgeInsets.all(2.0),
                                hintText: '请输入',
                                border:InputBorder.none
                            ),
                          )
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:  [
                      Container(
                        width:70,
                        margin: const EdgeInsets.only(left:10,top: 10),
                        child:const Text("备注信息",style: TextStyle(color:Color(0xff333333), fontSize: 14)),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width-160,height: 32,
                          margin: const EdgeInsets.only(top: 2),
                          child:   TextField(
                            controller: bzxxController,
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontSize: 14),
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              //内容的内边距
                                contentPadding: EdgeInsets.all(2.0),
                                hintText: '请输入',
                                border:InputBorder.none
                            ),
                          )
                      )
                    ],
                  )
                ],
              )
          ),
          Container(
              decoration:  const BoxDecoration(
                color: Colors.white,
              ),
              margin: const EdgeInsets.only(left: 20, right: 20, top: 0),
              padding: const EdgeInsets.only(bottom: 10),
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.topLeft,
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  Expanded(child:
                  ElevatedButton(onPressed: ()async {
                    await  saveAsyncMethod(context,0);
                  },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(255, 141, 87, 1),
                          disabledBackgroundColor:  const Color.fromRGBO(255, 141, 87, 1).withOpacity(0.5),
                          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0))
                      ),
                      child: const Text("保存修改")
                  )
                  ),
                  const SizedBox(width: 20),
                ],
              )
          )
        ])
    ) ));
  }
}

