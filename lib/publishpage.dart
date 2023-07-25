import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lanzhong/request/request_client.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:collection/collection.dart';
import 'Importpage.dart';
import 'cupertinoAreaPage.dart';
import 'cupertinoGamePage.dart';
import 'cupertinoServerPage.dart';
import 'cupertinoTypePage.dart';
import 'event_bus.dart';
import 'func.dart';
import 'model/api_response/list_data.dart';
import 'model/dq_entity.dart';
import 'model/game_entity.dart';
import 'model/xq_entity.dart';

class PublishPage extends StatefulWidget {
  const PublishPage({Key? key}) : super(key: key);
  @override
  State<PublishPage> createState() => _PublishPageState();
}

class _PublishPageState extends State<PublishPage>
    with AutomaticKeepAliveClientMixin {
  List<GameEntity>? lsGame = [];
  List<DqDllxs>? dllx = [];
  List<DqServers>? dqs = [];
  List<XqAreas>? xqs = [];
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
  @override
  void initState() {
    super.initState();
    yqFocus = FocusNode();
    zcFocus = FocusNode();
    srFocus = FocusNode();
    dlsjFocus = FocusNode();
    aqjFocus = FocusNode();
    xljFocus = FocusNode();
    zhFocus = FocusNode();
    mmFocus = FocusNode();
    jsFocus = FocusNode();
    yxbtnFocus = FocusNode();
    Future.delayed(const Duration(milliseconds: 200)).then((value) async {
      String url = "/Order/LoadGames";
      ListData<GameEntity>? games = await requestClient
          .get<ListData<GameEntity>>(url, showLoading: true, onError: (e) {
        return e.code == 0;
      });
      if (games != null) {
        lsGame = games.data;
      }
    });
    bus.on("setGames", (arg) async {
      String url2 = "/Order/LoadGames";
      ListData<GameEntity>? games2 =
          await requestClient.get<ListData<GameEntity>>(url2, onError: (e) {
        return e.code == 0;
      });
      if (games2 != null) {
        setState(() {
          lsGame = games2.data;
        });
      }
    });
    bus.on("setDllx", (arg) async {
      debugPrint("代练类型更新");
      if (yxid > 0) {
        String url2 = "/Order/Dllx?gid=$yxid";
        ListData<DqDllxs>? dllx2 =
            await requestClient.get<ListData<DqDllxs>>(url2, onError: (e) {
          return e.code == 0;
        });
        if (dllx2 != null) {
          dllx = dllx2.data!;
        }
      }
    });
  }

  String selectGame = "请选择";
  String selectServer = "请选择";
  String selectArea = "请选择";
  String selectDllx = "请选择";
  int yxid = 0;
  int userGameTypeId = 0;
  Map<String, dynamic> dicZdy = {};
  //
  void loadServers(int gid) async {
    String url = "/Order/DLAndServer";
    Map<String, dynamic> dic = {"gid": gid};
    await requestClient.get<DqEntity>(url, queryParameters: dic,
        onError: (e) {return e.code == 0;},
        onSuccess: (dqe2){
          dllx = dqe2.data!.dllxs;
          dqs = dqe2.data!.servers;
          if (dqe2.data!.zdygs != "") {
            var kvs = dqe2.data!.zdygs.split("：");
            dicZdy.clear();
            for (var k = 0; k < kvs.length; k++) {
              var _kv = kvs[k].split("=");
              dicZdy[_kv[1].trim().replaceAll(":", "")] = _kv[0];
            }
          }
          FunctionUtil.bottomSheetDialog(
            context,
            ShowServerDialog(
              items: dqs!,
              onTap: (int index, DqServers res) {
                setState(() {
                  selectServer =res.gameServerName;
                  selectArea = "请选择";
                });
                loadAreas(res.id);
              },
            ),
          );
        });

  }

  void loadAreas(int serverId) async {
    String url = "/Order/LoadAreas";
    Map<String, dynamic> dic = {"serverId": serverId};
     await requestClient.get<XqEntity>(url, queryParameters: dic,
        onError: (e) {return e.code == 0;},onSuccess: (xqe2){
          xqs = xqe2.data!.areas;
          FunctionUtil.bottomSheetDialog(
            context,
            ShowAreaDialog(
              items: xqs!,
              onTap: (int index, XqAreas res) {
                setState(() {
                  selectArea = res.gameAreaName;
                });
              },
            ),
          );
     });
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
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        selectGame = lsGame![index].yxmc;
                        selectServer = "请选择";
                        selectArea = "请选择";
                        selectDllx = "请选择";
                        yxid = lsGame![index].id;
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
          title: const Text("请选择一个大区"),
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (ctx, index) {
                  return SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        selectServer = dqs![index].gameServerName;
                        selectArea = "请选择";
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
          title: const Text("请选择一个小区"),
          children: [
            SingleChildScrollView(
                child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 360,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (ctx, index) {
                        return SimpleDialogOption(
                          onPressed: () {
                            Navigator.pop(context);
                            setState(() {
                              selectArea = xqs![index].gameAreaName;
                            });
                          },
                          child: Center(
                            child: Text(xqs![index].gameAreaName),
                          ),
                        );
                      },
                      itemCount: xqs!.length,
                      itemExtent: 36,
                    )))
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
          title: const Text("请选择一个代练类型"),
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (ctx, index) {
                  return SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        selectDllx = dllx![index].dllx;
                        userGameTypeId = dllx![index].id;
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

  TextEditingController yqController = TextEditingController();
  TextEditingController zcController = TextEditingController();
  TextEditingController srController = TextEditingController();
  TextEditingController dlsjController = TextEditingController();
  TextEditingController aqjController = TextEditingController();
  TextEditingController xljController = TextEditingController();
  TextEditingController zhController = TextEditingController();
  TextEditingController mmController = TextEditingController();
  TextEditingController jsController = TextEditingController(); //游戏角色
  TextEditingController ddlyController = TextEditingController(); //来源
  TextEditingController ddhController = TextEditingController(); //订单号
  TextEditingController sjController = TextEditingController(); //买家手机
  TextEditingController wwController = TextEditingController(); //旺旺
  TextEditingController bzxxController = TextEditingController(); //旺旺

  Future<void> saveAsyncMethod(BuildContext context, int sffd) async {
    if (context.mounted) {
      if (yxid == 0) {
        await showOkAlertDialog(
                context: context, title: '提示', message: '请选择一个游戏.')
            .then((value) {});
        return;
      }
      if (selectServer == "请选择") {
        await showOkAlertDialog(
                context: context, title: '提示', message: '请选择一个大区')
            .then((value) {});
        return;
      }
      if (selectArea == "请选择") {
        await showOkAlertDialog(
                context: context, title: '提示', message: '请选择一个小区')
            .then((value) {});
        return;
      }
      if (userGameTypeId == 0) {
        await showOkAlertDialog(
                context: context, title: '提示', message: '请选择一个代练类型.')
            .then((value) {});
        return;
      }
      if (yqController.text.trim() == "") {
        await showOkAlertDialog(
                context: context, title: '提示', message: '代练内容不能为空.')
            .then((value) {
          yqFocus.requestFocus();
        });
        return;
      }
      if (zcController.text.trim() == "") {
        await showOkAlertDialog(
                context: context, title: '提示', message: '发单价不能为空.')
            .then((value) {
          zcFocus.requestFocus();
        });
        return;
      }
      if (srController.text.trim() == "") {
        await showOkAlertDialog(
                context: context, title: '提示', message: '接单价不能为空.')
            .then((value) {
          srFocus.requestFocus();
        });
        return;
      }
      if (dlsjController.text.trim() == "") {
        await showOkAlertDialog(
                context: context, title: '提示', message: '代练时间不能为空.')
            .then((value) {
          dlsjFocus.requestFocus();
        });
        return;
      }
      if (aqjController.text.trim() == "") {
        await showOkAlertDialog(
                context: context, title: '提示', message: '安全金不能为空.')
            .then((value) {
          aqjFocus.requestFocus();
        });
        return;
      }
      if (xljController.text.trim() == "") {
        await showOkAlertDialog(
                context: context, title: '提示', message: '效率金不能为空.')
            .then((value) {
          xljFocus.requestFocus();
        });
        return;
      }
      if (zhController.text.trim() == "") {
        await showOkAlertDialog(
                context: context, title: '提示', message: '效率金不能为空.')
            .then((value) {
          zhFocus.requestFocus();
        });
        return;
      }
      if (mmController.text.trim() == "") {
        await showOkAlertDialog(
                context: context, title: '提示', message: '密码不能为空.')
            .then((value) {
          mmFocus.requestFocus();
        });
        return;
      }
      if (jsController.text.trim() == "") {
        await showOkAlertDialog(
                context: context, title: '提示', message: '角色不能为空.')
            .then((value) {
          jsFocus.requestFocus();
        });
        return;
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Map<String, dynamic> dic = {
        "yxid": yxid,
        "dq": selectServer,
        "qh": selectArea,
        "userGameTypeId": userGameTypeId,
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
        "sffd": sffd,
        "yhid": prefs.getString("yhid"),
      };
      await EasyLoading.show(
          status: '验证中...', maskType: EasyLoadingMaskType.black);
      String url = "http://lz.lzsterp.com/App/AddPub";
      Map<String, dynamic>? headers = {
        "content-type": "application/x-www-form-urlencoded"
      };
      await requestClient.post(url, data: dic, headers: headers, onError: (e) {
        EasyLoading.dismiss();
        EasyLoading.showError(e.message!);
        return e.code == 0;
      }, onSuccess: (res) async {
        await EasyLoading.dismiss();
        if (context.mounted) {
          var result = await showOkAlertDialog(
              context: context, title: '提示', message: res.message);
          if (result == OkCancelResult.ok) {
            setState(() {
              yxid = 0;
              userGameTypeId = 0;
              selectGame = "请选择";
              selectServer = "请选择";
              selectArea = "请选择";
              selectDllx = "请选择";
            });

            yqController.text = "";
            zcController.text = "";
            srController.text = "";
            dlsjController.text = "";
            aqjController.text = "";
            xljController.text = "";
            zhController.text = "";
            mmController.text = "";
            jsController.text = "";
            ddlyController.text = "";
            ddhController.text = "";
            sjController.text = "";
            wwController.text = "";
            bzxxController.text = "";
            yxbtnFocus.requestFocus();
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(body:
    SingleChildScrollView(
        child: SafeArea(child:Column(children: [
          Container(
              alignment: Alignment.topLeft,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xffFFEBE5),
                      Color(0xffFFFFFF),
                    ]),
              ),
              width: MediaQuery.of(context).size.width,
              child: Column(children: [
                Container(
                  height: 39,
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(left: 0, top: 0),
                  child: Row(children: [
                    IconButton(onPressed: () {
                      Navigator.pop(context);
                    },iconSize: 36, icon:const Image(image: AssetImage("images/arrow_left.png"),width: 20,height:36)),
                    const Spacer(),
                    const Spacer(),
                    const Spacer(),
                    const Spacer(),      const Spacer(),      const Spacer(),
                    const Text("商户发单",
                        style: TextStyle(
                            color: Color(0xFF333333),
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                    const Spacer(),
                    const Spacer(),
                    const Spacer(),
                    const Spacer(),
                    GestureDetector(
                        onTap: () async{
                          if(selectGame=="请选择")
                          {
                            await showOkAlertDialog(context: context, title: '提示', message: '请选择一个游戏');
                            return;
                          }
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>  const ImportPage())).then((mbValue) {
                            if(mbValue!=null)
                            {
                              String yx=mbValue.toString();
                              yx=yx.replaceAll(":", "：");
                              var games = yx.split("\n");
                              debugPrint("games.length=${games.length}");
                              String dlxt="";
                              for (var key in dicZdy.keys){
                                if(dicZdy[key]=="26")
                                {
                                  dlxt=key;
                                  break;
                                }
                              }
                              for (var g = 0; g < games.length; g++) {
                                var kv = games[g].split("：");
                                if (dlxt ==kv[0].trim())
                                {
                                  dlxt = kv[1].trim();
                                  break;
                                }
                              }
                              String prdllx="";
                              String yxdq = "";
                              String yxxq = "";
                              String yxsl = "";
                              String mwdj = "";
                              String dlyq="";
                              for (var g = 0; g < games.length; g++) {
                                var kv = games[g].split("：");
                                var zid = dicZdy[kv[0].trim()];//获得id
                                debugPrint("kv="+kv[0]+";zid="+zid);
                                if (zid.toString() == "1") {
                                  ddhController.text=kv[1].trim();
                                }
                                if (zid == "2") {
                                  ddlyController.text=kv[1].trim();
                                }
                                if (zid == "6") {
                                  jsController.text=kv[1].trim();
                                }
                                if (zid == "7") {
                                  zhController.text=kv[1].trim();
                                }
                                if (zid == "8") {
                                  mmController.text=kv[1].trim();
                                }
                                if (zid == "9") {
                                  yqController.text=kv[1].trim().replaceAll("☆", ":");
                                }
                                if (zid == "10") {
                                  sjController.text=kv[1].trim();
                                }
                                if (zid == "11") {
                                  //补单单号
                                }
                                if (zid == "12") {
                                  srController.text=kv[1].trim();
                                }
                                if (zid == "13") {
                                  zcController.text=kv[1].trim();
                                }
                                if (zid == "14") {
                                  //下单时间
                                }
                                if (zid == "15") {
                                  wwController.text=kv[1].trim();
                                }
                                if (zid == "16") {
                                  prdllx =kv[1].trim();
                                }
                                if (zid == "17") {
                                  //ddlx
                                }
                                if (zid == "18") {
                                  dlsjController.text=kv[1].trim();
                                }
                                if (zid == "19") {
                                  aqjController.text=kv[1].trim();
                                }
                                if (zid == "20") {
                                  xljController.text=kv[1].trim();
                                }
                                if (zid == "22") {
                                  bzxxController.text=kv[1].trim();
                                }
                                if (zid == "4") {
                                  yxdq =kv[1].trim();
                                  yxdq = yxdq.replaceAll("扣扣", "QQ");
                                  yxdq = yxdq.replaceAll("扣", "QQ");
                                  yxdq = yxdq.replaceAll("qq", "QQ");
                                  yxdq = yxdq.replaceAll("q", "QQ");
                                  yxdq = yxdq.replaceAll("VX", "微信");
                                  yxdq = yxdq.replaceAll("vx", "微信");
                                  yxdq = yxdq.replaceAll("Vx", "微信");
                                  if (dlxt != "") {
                                    yxdq = dlxt + yxdq;
                                  }
                                }
                                if (zid == "5") {
                                  yxxq =kv[1].trim();
                                }
                                if (zid == "23") {
                                  yxsl =kv[1].trim();
                                }
                                if (zid == "24") {
                                  mwdj =kv[1].trim();
                                }
                                if (zid == "9") {
                                  dlyq =kv[1].trim().replaceAll('☆',':');
                                }
                              }
                              DqServers? dqServer=dqs!.firstWhereOrNull((v) =>v.gameServerName==yxdq);
                              if(dqServer!=null)
                              {
                                setState(() {
                                  selectServer=dqServer.gameServerName;
                                  selectArea="请选择";
                                });

                                String xurl="/Order/LoadAreas";
                                Map<String,dynamic> dic={"serverId":dqServer.id};
                                requestClient.get<XqEntity>(xurl,queryParameters: dic,onError: (e){
                                  return e.code==0;
                                },onSuccess: (xqResponse){
                                  if(xqResponse.code==0)
                                  {
                                    xqs=xqResponse.data!.areas;
                                    XqAreas? xqArea=xqs!.firstWhereOrNull((v) =>v.gameAreaName==yxxq);
                                    if(xqArea!=null)
                                    {
                                      setState(() {
                                        selectArea=xqArea.gameAreaName;
                                      });
                                    }
                                    else
                                    {
                                      XqAreas? xqArea2=xqs!.firstWhereOrNull((v1) =>v1.gameAreaName=="默认服");
                                      if(xqArea2!=null)
                                      {
                                        setState(() {
                                          selectArea="默认服";
                                        });
                                      }
                                    }
                                  }
                                });
                              }

                              DqDllxs? gameType=dllx!.firstWhereOrNull((v) =>v.dllx==prdllx);
                              if(gameType!=null)
                              {
                                setState(() {
                                  selectDllx=gameType.dllx;
                                  userGameTypeId=gameType.id;
                                });
                              }
                            }
                          });
                        },
                        child: const Image(
                            image: AssetImage("images/btn_recon.png"),
                            width: 16,
                            height: 16)
                    ),
                    GestureDetector(
                      onTap: () async{
                        if(selectGame=="请选择")
                        {
                          await showOkAlertDialog(context: context, title: '提示', message: '请选择一个游戏');
                          return;
                        }
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>  const ImportPage())).then((mbValue) {
                          if(mbValue!=null)
                          {
                            String yx=mbValue.toString();
                            yx=yx.replaceAll(":", "：");
                            var games = yx.split("\n");
                            debugPrint("games.length=${games.length}");
                            String dlxt="";
                            for (var key in dicZdy.keys){
                              if(dicZdy[key]=="26")
                              {
                                dlxt=key;
                                break;
                              }
                            }
                            for (var g = 0; g < games.length; g++) {
                              var kv = games[g].split("：");
                              if (dlxt ==kv[0].trim())
                              {
                                dlxt = kv[1].trim();
                                break;
                              }
                            }
                            String prdllx="";
                            String yxdq = "";
                            String yxxq = "";
                            String yxsl = "";
                            String mwdj = "";
                            String dlyq="";
                            for (var g = 0; g < games.length; g++) {
                              var kv = games[g].split("：");
                              var zid = dicZdy[kv[0].trim()];//获得id
                              debugPrint("kv="+kv[0]+";zid="+zid);
                              if (zid.toString() == "1") {
                                ddhController.text=kv[1].trim();
                              }
                              if (zid == "2") {
                                ddlyController.text=kv[1].trim();
                              }
                              if (zid == "6") {
                                jsController.text=kv[1].trim();
                              }
                              if (zid == "7") {
                                zhController.text=kv[1].trim();
                              }
                              if (zid == "8") {
                                mmController.text=kv[1].trim();
                              }
                              if (zid == "9") {
                                yqController.text=kv[1].trim().replaceAll("☆", ":");
                              }
                              if (zid == "10") {
                                sjController.text=kv[1].trim();
                              }
                              if (zid == "11") {
                                //补单单号
                              }
                              if (zid == "12") {
                                srController.text=kv[1].trim();
                              }
                              if (zid == "13") {
                                zcController.text=kv[1].trim();
                              }
                              if (zid == "14") {
                                //下单时间
                              }
                              if (zid == "15") {
                                wwController.text=kv[1].trim();
                              }
                              if (zid == "16") {
                                prdllx =kv[1].trim();
                              }
                              if (zid == "17") {
                                //ddlx
                              }
                              if (zid == "18") {
                                dlsjController.text=kv[1].trim();
                              }
                              if (zid == "19") {
                                aqjController.text=kv[1].trim();
                              }
                              if (zid == "20") {
                                xljController.text=kv[1].trim();
                              }
                              if (zid == "22") {
                                bzxxController.text=kv[1].trim();
                              }
                              if (zid == "4") {
                                yxdq =kv[1].trim();
                                yxdq = yxdq.replaceAll("扣扣", "QQ");
                                yxdq = yxdq.replaceAll("扣", "QQ");
                                yxdq = yxdq.replaceAll("qq", "QQ");
                                yxdq = yxdq.replaceAll("q", "QQ");
                                yxdq = yxdq.replaceAll("VX", "微信");
                                yxdq = yxdq.replaceAll("vx", "微信");
                                yxdq = yxdq.replaceAll("Vx", "微信");
                                if (dlxt != "") {
                                  yxdq = dlxt + yxdq;
                                }
                              }
                              if (zid == "5") {
                                yxxq =kv[1].trim();
                              }
                              if (zid == "23") {
                                yxsl =kv[1].trim();
                              }
                              if (zid == "24") {
                                mwdj =kv[1].trim();
                              }
                              if (zid == "9") {
                                dlyq =kv[1].trim().replaceAll('☆',':');
                              }
                            }
                            DqServers? dqServer=dqs!.firstWhereOrNull((v) =>v.gameServerName==yxdq);
                            if(dqServer!=null)
                            {
                              setState(() {
                                selectServer=dqServer.gameServerName;
                                selectArea="请选择";
                              });

                              String xurl="/Order/LoadAreas";
                              Map<String,dynamic> dic={"serverId":dqServer.id};
                              requestClient.get<XqEntity>(xurl,queryParameters: dic,onError: (e){
                                return e.code==0;
                              },onSuccess: (xqResponse){
                                if(xqResponse.code==0)
                                {
                                  xqs=xqResponse.data!.areas;
                                  XqAreas? xqArea=xqs!.firstWhereOrNull((v) =>v.gameAreaName==yxxq);
                                  if(xqArea!=null)
                                  {
                                    setState(() {
                                      selectArea=xqArea.gameAreaName;
                                    });
                                  }
                                  else
                                  {
                                    XqAreas? xqArea2=xqs!.firstWhereOrNull((v1) =>v1.gameAreaName=="默认服");
                                    if(xqArea2!=null)
                                    {
                                      setState(() {
                                        selectArea="默认服";
                                      });
                                    }
                                  }
                                }
                              });
                            }

                            DqDllxs? gameType=dllx!.firstWhereOrNull((v) =>v.dllx==prdllx);
                            if(gameType!=null)
                            {
                              setState(() {
                                selectDllx=gameType.dllx;
                                userGameTypeId=gameType.id;
                              });
                            }
                          }
                        });
                      },
                      child:  const Text("识别导入", style: TextStyle(color: Color(0xFFFF5201), fontSize: 16)),
                    ),

                    const Spacer()
                  ]),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, top: 0),
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.topLeft,
                  child: const Text("发单信息",
                      style: TextStyle(
                          color: Color(0xFF333333),
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 10, right: 2, top: 10),
                  padding: const EdgeInsets.only(bottom: 6),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 0.6, color: Color(0xFFE2E2E2)),
                    ),
                  ),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      const Expanded(
                        flex: 2,
                        child: Text("*",
                            style:
                            TextStyle(color: Color(0xFFFF1717), fontSize: 16),
                            textAlign: TextAlign.end),
                      ),
                      const Expanded(
                        flex: 60,
                        child: Text("游戏名称",
                            style:
                            TextStyle(color: Color(0xff333333), fontSize: 16)),
                      ),
                      Expanded(
                        flex: 30,
                        child: Container(
                            height: 32,
                            width: 100,
                            margin: const EdgeInsets.all(0),
                            padding: const EdgeInsets.all(0),
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              focusNode: yxbtnFocus,
                              style: ButtonStyle(
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                minimumSize:
                                MaterialStateProperty.all(const Size(0, 0)),
                                padding: MaterialStateProperty.all(EdgeInsets.zero),
                              ),
                              child: Text(selectGame,
                                  style: const TextStyle(color: Color(0xff333333), fontSize: 16)),
                              onPressed: () {
                                //showGames();
                                FunctionUtil.bottomSheetDialog(
                                  context,
                                  ShowGameDialog(
                                    items: lsGame!,
                                    onTap: (int index, GameEntity res) {
                                      setState(() {
                                        selectGame=res.yxmc;
                                        selectServer = "请选择";
                                        selectArea = "请选择";
                                        selectDllx = "请选择";
                                        yxid = res.id;
                                      });
                                      loadServers(yxid);
                                    },
                                  ),
                                );
                              },
                            )),
                      ),
                      const Expanded(
                          flex: 8,
                          child: Image(
                              image: AssetImage("images/arrow_right.png"),
                              width: 7,
                              height: 12.7)),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 10, right: 2, top: 6),
                  padding: const EdgeInsets.only(bottom: 6),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 0.6, color: Color(0xFFE2E2E2)),
                    ),
                  ),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      const Expanded(
                        flex: 2,
                        child: Text("*",
                            style:
                            TextStyle(color: Color(0xFFFF1717), fontSize: 16),
                            textAlign: TextAlign.end),
                      ),
                      const Expanded(
                        flex: 60,
                        child: Text("游戏大区", style: TextStyle(color: Color(0xff333333), fontSize: 16)),
                      ),
                      Expanded(
                        flex: 30,
                        child: Container(
                            height: 32,
                            width: 100,
                            margin: const EdgeInsets.all(0),
                            padding: const EdgeInsets.all(0),
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              style: ButtonStyle(
                                tapTargetSize: MaterialTapTargetSize
                                    .shrinkWrap, // 设置点击区域尺寸跟随内容大小
                                minimumSize:
                                MaterialStateProperty.all(const Size(0, 0)),
                                padding: MaterialStateProperty.all(EdgeInsets.zero),
                              ),
                              child: Text(selectServer, style: const TextStyle(color: Color(0xff333333), fontSize: 16)),
                              onPressed: () {
                                //showServers();
                                FunctionUtil.bottomSheetDialog(
                                  context,
                                  ShowServerDialog(
                                    items: dqs!,
                                    onTap: (int index, DqServers res) {
                                      setState(() {
                                        selectServer =res.gameServerName;
                                        selectArea = "请选择";
                                      });
                                      loadAreas(res.id);
                                    },
                                  ),
                                );
                              },
                            )),
                      ),
                      const Expanded(
                          flex: 8,
                          child: Image(
                              image: AssetImage("images/arrow_right.png"),
                              width: 7,
                              height: 12.7)),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 10, right: 2, top: 6),
                  padding: const EdgeInsets.only(bottom: 6),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 0.6, color: Color(0xFFE2E2E2)),
                    ),
                  ),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      const Expanded(
                        flex: 2,
                        child: Text("*",
                            style: TextStyle(color: Color(0xFFFF1717), fontSize: 16),
                            textAlign: TextAlign.end),
                      ),
                      const Expanded(
                        flex: 60,
                        child: Text("游戏小区",
                            style:
                            TextStyle(color: Color(0xff333333), fontSize: 16)),
                      ),
                      Expanded(
                        flex: 30,
                        child: Container(
                          height: 32,
                          width: 100,
                          margin: const EdgeInsets.all(0),
                          padding: const EdgeInsets.all(0),
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            style: ButtonStyle(
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap, // 设置点击区域尺寸跟随内容大小
                              minimumSize:
                              MaterialStateProperty.all(const Size(0, 0)),
                              padding: MaterialStateProperty.all(EdgeInsets.zero),
                            ),
                            child: Text(selectArea, style: const TextStyle(color: Color(0xff333333), fontSize: 16)),
                            onPressed: () {
                              //showAreas();
                              FunctionUtil.bottomSheetDialog(
                                context,
                                ShowAreaDialog(
                                  items: xqs!,
                                  onTap: (int index, XqAreas res) {
                                    setState(() {
                                      selectArea = res.gameAreaName;
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const Expanded(
                          flex: 8,
                          child: Image(image: AssetImage("images/arrow_right.png"), width: 7, height: 12.7)),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 10, right: 2, top: 6),
                  padding: const EdgeInsets.only(bottom: 6),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 0.6, color: Color(0xFFE2E2E2)),
                    ),
                  ),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      const Expanded(
                        flex: 2,
                        child: Text("*",
                            style: TextStyle(color: Color(0xFFFF1717), fontSize: 16),
                            textAlign: TextAlign.end),
                      ),
                      const Expanded(
                        flex: 60,
                        child: Text("代练类型",
                            style:
                            TextStyle(color: Color(0xff333333), fontSize: 16)),
                      ),
                      Expanded(
                        flex: 30,
                        child: Container(
                          height: 32,
                          width: 100,
                          margin: const EdgeInsets.all(0),
                          padding: const EdgeInsets.all(0),
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            style: ButtonStyle(
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap, // 设置点击区域尺寸跟随内容大小
                              minimumSize: MaterialStateProperty.all(const Size(0, 0)),
                              padding: MaterialStateProperty.all(EdgeInsets.zero),
                            ),
                            child: Text(selectDllx, style: const TextStyle(color: Color(0xff333333), fontSize: 16)),
                            onPressed: () {
                              //showDllx();
                              FunctionUtil.bottomSheetDialog(
                                context,
                                ShowTypeIdDialog(
                                  items: dllx!,
                                  onTap: (int index, DqDllxs res) {
                                    setState(() {
                                      selectDllx =res.dllx;
                                      userGameTypeId = res.id;
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const Expanded(
                          flex: 8,
                          child: Image(image: AssetImage("images/arrow_right.png"), width: 7, height: 12.7)),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 10, right: 2, top: 0),
                  padding: const EdgeInsets.only(bottom: 0),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 0.6, color: Color(0xFFE2E2E2)),
                    ),
                  ),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      const Expanded(
                        flex: 2,
                        child: Text("*",
                            style:
                            TextStyle(color: Color(0xFFFF1717), fontSize: 16),
                            textAlign: TextAlign.end),
                      ),
                      const Expanded(
                        flex: 22,
                        child: Text("代练内容",
                            style:
                            TextStyle(color: Color(0xff333333), fontSize: 16)),
                      ),
                      Expanded(
                          flex: 76,
                          child: TextField(
                            controller: yqController,
                            focusNode: yqFocus,
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontSize: 16),
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              //内容的内边距
                                contentPadding: EdgeInsets.only(right: 10),
                                hintText: '请输入代练内容',
                                border: InputBorder.none),
                          ))
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 10, right: 2, top: 0),
                  padding: const EdgeInsets.only(bottom: 0),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 0.6, color: Color(0xFFE2E2E2)),
                    ),
                  ),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      const Expanded(
                        flex: 2,
                        child: Text("*",
                            style:
                            TextStyle(color: Color(0xFFFF1717), fontSize: 16),
                            textAlign: TextAlign.end),
                      ),
                      const Expanded(
                        flex: 22,
                        child: Text("发单价格",
                            style:
                            TextStyle(color: Color(0xff333333), fontSize: 16)),
                      ),
                      Expanded(
                          flex: 76,
                          child: TextField(
                              controller: zcController,
                              focusNode: zcFocus,
                              textAlign: TextAlign.right,
                              style: const TextStyle(fontSize: 16),
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                //内容的内边距
                                  contentPadding: EdgeInsets.only(right: 10),
                                  hintText: '请输入金额',
                                  border: InputBorder.none),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(6),
                                FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                              ]))
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 10, right: 2, top: 0),
                  padding: const EdgeInsets.only(bottom: 0),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 0.6, color: Color(0xFFE2E2E2)),
                    ),
                  ),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      const Expanded(
                        flex: 2,
                        child: Text("*",
                            style:
                            TextStyle(color: Color(0xFFFF1717), fontSize: 16),
                            textAlign: TextAlign.end),
                      ),
                      const Expanded(
                        flex: 22,
                        child: Text("接单价格",
                            style:
                            TextStyle(color: Color(0xff333333), fontSize: 16)),
                      ),
                      Expanded(
                          flex: 76,
                          child: TextField(
                              controller: srController,
                              focusNode: srFocus,
                              textAlign: TextAlign.right,
                              style: const TextStyle(fontSize: 16),
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                //内容的内边距
                                  contentPadding: EdgeInsets.only(right: 10),
                                  hintText: '请输入金额',
                                  border: InputBorder.none),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(6),
                                FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                              ]))
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 10, right: 2, top: 0),
                  padding: const EdgeInsets.only(bottom: 0),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 0.6, color: Color(0xFFE2E2E2)),
                    ),
                  ),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      const Expanded(
                        flex: 2,
                        child: Text("*",
                            style:
                            TextStyle(color: Color(0xFFFF1717), fontSize: 16),
                            textAlign: TextAlign.end),
                      ),
                      const Expanded(
                        flex: 22,
                        child: Text("代练时间",
                            style:
                            TextStyle(color: Color(0xff333333), fontSize: 16)),
                      ),
                      Expanded(
                          flex: 76,
                          child: TextField(
                              controller: dlsjController,
                              focusNode: dlsjFocus,
                              textAlign: TextAlign.right,
                              style: const TextStyle(fontSize: 16),
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                //内容的内边距
                                  contentPadding: EdgeInsets.only(right: 10),
                                  hintText: '单位：小时',
                                  border: InputBorder.none),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(6),
                                FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                              ]))
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 10, right: 2, top: 0),
                  padding: const EdgeInsets.only(bottom: 0),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 0.6, color: Color(0xFFE2E2E2)),
                    ),
                  ),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      const Expanded(
                        flex: 2,
                        child: Text("*",
                            style:
                            TextStyle(color: Color(0xFFFF1717), fontSize: 16),
                            textAlign: TextAlign.end),
                      ),
                      const Expanded(
                        flex: 22,
                        child: Text("安全金额",
                            style:
                            TextStyle(color: Color(0xff333333), fontSize: 16)),
                      ),
                      Expanded(
                          flex: 76,
                          child: TextField(
                              controller: aqjController,
                              focusNode: aqjFocus,
                              textAlign: TextAlign.right,
                              style: const TextStyle(fontSize: 16),
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                //内容的内边距
                                  contentPadding: EdgeInsets.only(right: 10),
                                  hintText: '请输入金额',
                                  border: InputBorder.none),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(6),
                                FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                              ]))
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 10, right: 2, top: 0),
                  padding: const EdgeInsets.only(bottom: 0),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 0.6, color: Color(0xFFE2E2E2)),
                    ),
                  ),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      const Expanded(
                        flex: 2,
                        child: Text("*",
                            style:
                            TextStyle(color: Color(0xFFFF1717), fontSize: 16),
                            textAlign: TextAlign.end),
                      ),
                      const Expanded(
                        flex: 22,
                        child: Text("效率金额",
                            style:
                            TextStyle(color: Color(0xff333333), fontSize: 16)),
                      ),
                      Expanded(
                          flex: 76,
                          child: TextField(
                              controller: xljController,
                              focusNode: xljFocus,
                              textAlign: TextAlign.right,
                              style: const TextStyle(fontSize: 16),
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                //内容的内边距
                                  contentPadding: EdgeInsets.only(right: 10),
                                  hintText: '请输入金额',
                                  border: InputBorder.none),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(6),
                                FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                              ]))
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 10, right: 2, top: 0),
                  padding: const EdgeInsets.only(bottom: 0),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 0.6, color: Color(0xFFE2E2E2)),
                    ),
                  ),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      const Expanded(
                        flex: 2,
                        child: Text("*",
                            style:
                            TextStyle(color: Color(0xFFFF1717), fontSize: 16),
                            textAlign: TextAlign.end),
                      ),
                      const Expanded(
                        flex: 22,
                        child: Text("游戏账号",
                            style:
                            TextStyle(color: Color(0xff333333), fontSize: 16)),
                      ),
                      Expanded(
                          flex: 76,
                          child: TextField(
                            controller: zhController,
                            focusNode: zhFocus,
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontSize: 16),
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              //内容的内边距
                                contentPadding: EdgeInsets.only(right: 10),
                                hintText: '请输入账号',
                                border: InputBorder.none),
                          ))
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 10, right: 2, top: 0),
                  padding: const EdgeInsets.only(bottom: 0),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 0.6, color: Color(0xFFE2E2E2)),
                    ),
                  ),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      const Expanded(
                        flex: 2,
                        child: Text("*",
                            style:
                            TextStyle(color: Color(0xFFFF1717), fontSize: 16),
                            textAlign: TextAlign.end),
                      ),
                      const Expanded(
                        flex: 22,
                        child: Text("游戏密码",
                            style:
                            TextStyle(color: Color(0xff333333), fontSize: 16)),
                      ),
                      Expanded(
                          flex: 76,
                          child: TextField(
                            controller: mmController,
                            focusNode: mmFocus,
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontSize: 16),
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              //内容的内边距
                                contentPadding: EdgeInsets.only(right: 10),
                                hintText: '请输入密码',
                                border: InputBorder.none),
                          ))
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 10, right: 2, top: 0),
                  padding: const EdgeInsets.only(bottom: 0),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      const Expanded(
                        flex: 2,
                        child: Text("*",
                            style:
                            TextStyle(color: Color(0xFFFF1717), fontSize: 16),
                            textAlign: TextAlign.end),
                      ),
                      const Expanded(
                        flex: 22,
                        child: Text("游戏角色",
                            style:
                            TextStyle(color: Color(0xff333333), fontSize: 16)),
                      ),
                      Expanded(
                          flex: 76,
                          child: TextField(
                            controller: jsController,
                            focusNode: jsFocus,
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontSize: 16),
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              //内容的内边距
                                contentPadding: EdgeInsets.only(right: 10),
                                hintText: '请输入角色',
                                border: InputBorder.none),
                          ))
                    ],
                  ),
                )
              ])),
          Container(
              decoration: const BoxDecoration(color: Colors.white),
              margin: const EdgeInsets.only(left: 0, right: 0, top: 10),
              padding: const EdgeInsets.all(0),
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.topLeft,
              child: Column(children: [
                Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    margin: const EdgeInsets.only(left: 15, right: 0, top: 10),
                    width: MediaQuery.of(context).size.width - 20,
                    alignment: Alignment.topLeft,
                    child: Row(children: const [
                      Text("接单信息",
                          style: TextStyle(
                              color: Color(0xFF333333),
                              fontWeight: FontWeight.bold,
                              fontSize: 20)),
                      Text("(可不填)",
                          style: TextStyle(color: Color(0xFF999999), fontSize: 14)),
                    ])),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(width: 0.6, color: Color(0xFFE2E2E2)),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width - 16,
                  margin: const EdgeInsets.only(left: 15, right: 2, top: 0),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      const Expanded(
                        flex: 22,
                        child: Text("订单来源",
                            style:
                            TextStyle(color: Color(0xff333333), fontSize: 16)),
                      ),
                      Expanded(
                          flex: 76,
                          child: TextField(
                            controller: ddlyController,
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontSize: 16),
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              //内容的内边距
                                contentPadding: EdgeInsets.only(right: 10),
                                hintText: '请输入',
                                border: InputBorder.none),
                          ))
                    ],
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(width: 0.6, color: Color(0xFFE2E2E2)),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width - 16,
                  margin: const EdgeInsets.only(left: 15, right: 2, top: 0),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      const Expanded(
                        flex: 22,
                        child: Text("发单编号",
                            style:
                            TextStyle(color: Color(0xff333333), fontSize: 16)),
                      ),
                      Expanded(
                          flex: 76,
                          child: TextField(
                            controller: ddhController,
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontSize: 16),
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              //内容的内边距
                                contentPadding: EdgeInsets.only(right: 10),
                                hintText: '请输入',
                                border: InputBorder.none),
                          ))
                    ],
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(width: 0.6, color: Color(0xFFE2E2E2)),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width - 16,
                  margin: const EdgeInsets.only(left: 15, right: 2, top: 0),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      const Expanded(
                        flex: 22,
                        child: Text("买家手机",
                            style:
                            TextStyle(color: Color(0xff333333), fontSize: 16)),
                      ),
                      Expanded(
                          flex: 76,
                          child: TextField(
                            controller: sjController,
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontSize: 16),
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              //内容的内边距
                                contentPadding: EdgeInsets.only(right: 10),
                                hintText: '请输入',
                                border: InputBorder.none),
                          ))
                    ],
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(width: 0.6, color: Color(0xFFE2E2E2)),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width - 16,
                  margin: const EdgeInsets.only(left: 15, right: 2, top: 0),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      const Expanded(
                        flex: 22,
                        child: Text("买家旺旺",
                            style:
                            TextStyle(color: Color(0xff333333), fontSize: 16)),
                      ),
                      Expanded(
                          flex: 76,
                          child: TextField(
                            controller: wwController,
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontSize: 16),
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              //内容的内边距
                                contentPadding: EdgeInsets.only(right: 10),
                                hintText: '请输入',
                                border: InputBorder.none),
                          ))
                    ],
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(width: 0.6, color: Color(0xFFE2E2E2)),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width - 16,
                  margin: const EdgeInsets.only(left: 15, right: 2, top: 0),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      const Expanded(
                        flex: 22,
                        child: Text("备注信息",
                            style:
                            TextStyle(color: Color(0xff333333), fontSize: 16)),
                      ),
                      Expanded(
                          flex: 76,
                          child: TextField(
                            controller: bzxxController,
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontSize: 16),
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              //内容的内边距
                                contentPadding: EdgeInsets.only(right: 10),
                                hintText: '请输入',
                                border: InputBorder.none),
                          ))
                    ],
                  ),
                ),
              ])),
          Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              margin: const EdgeInsets.only(left: 0, right: 0, top: 0),
              padding: const EdgeInsets.only(bottom: 10),
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.topLeft,
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Expanded(
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9),
                            gradient: const LinearGradient(colors: [
                              Color(0xff2D67E5),
                              Color(0xff4CC6F7),
                            ]),
                          ),
                          margin:
                          const EdgeInsets.only(left: 20, right: 20, top: 20),
                          child: ElevatedButton(
                              onPressed: () async {
                                await saveAsyncMethod(context, 0);
                              },
                              style: ButtonStyle(
                                //去除阴影
                                elevation: MaterialStateProperty.all(0),
                                //将按钮背景设置为透明
                                backgroundColor:
                                MaterialStateProperty.all(Colors.transparent),
                              ),
                              child: const Text("创建订单", style: TextStyle(color: Color(0xffffffff), fontSize: 16))
                          )
                      )
                  ),
                  const SizedBox(width: 2),
                  Expanded(
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9),
                            gradient: const LinearGradient(colors: [
                              Color(0xffFFBF3A),
                              Color(0xffFF5100),
                            ]),
                          ),
                          margin:
                          const EdgeInsets.only(left: 20, right: 20, top: 20),
                          child: ElevatedButton(
                              onPressed: () async {
                                await saveAsyncMethod(context, 1);
                              },
                              style: ButtonStyle(
                                //去除阴影
                                elevation: MaterialStateProperty.all(0),
                                //将按钮背景设置为透明
                                backgroundColor:
                                MaterialStateProperty.all(Colors.transparent),
                              ),
                              child: const Text("创建并发单", style: TextStyle(color: Color(0xffffffff), fontSize: 16))
                          )
                      )
                  ),
                  const SizedBox(width: 10),
                ],
              ))
        ]))
    )
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
