import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lanzhong/request/request_client.dart';
import 'package:lanzhong/settingpage.dart';
import 'package:lanzhong/subpage.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'PanPage.dart';
import 'PlatformAdd.dart';
import 'addgame.dart';
import 'PlatformEdit.dart';
import 'editgame.dart';
import 'event_bus.dart';
import 'model/person_entity.dart';
import 'dart:math' as math;

import 'model/tbgame.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with AutomaticKeepAliveClientMixin{
    var logger = Logger(printer: PrettyPrinter());
    // final GlobalKey kjKey1=  GlobalKey(debugLabel: "__JosKey1__");
    // final GlobalKey kjKey2=  GlobalKey(debugLabel: "__JosKey2__");
    // final GlobalKey kjKey3=  GlobalKey(debugLabel: "__JosKey3__");
    // final GlobalKey kjKey4=  GlobalKey(debugLabel: "__JosKey4__");
    // final GlobalKey kjKey5=  GlobalKey(debugLabel: "__JosKey5__");
    // final GlobalKey kjKey6=  GlobalKey(debugLabel: "__JosKey6__");
    // final GlobalKey kjKey7=  GlobalKey(debugLabel: "__JosKey7__");
    // final GlobalKey kjKey8=  GlobalKey(debugLabel: "__JosKey8__");
    // final GlobalKey kjKey9=  GlobalKey(debugLabel: "__JosKey9__");
     final GlobalKey kjKey10=  GlobalKey(debugLabel: "__JosKey10__");
    String nickName="";
    String userId="";
    String smsCount="0";
    String balance="￥0.00";
    List<PersonPlats> plats=[];
    List<PersonGames> games=[];
    void loadData() async{
    RequestClient requestClient = RequestClient();
    String url = "/Personal/LoadData";
    await EasyLoading.show(status: '加载中...');
    PersonEntity? perEntity = await requestClient.get<PersonEntity>(url,onError: (e){
      EasyLoading.dismiss();
      return e.code==0;
    });
    EasyLoading.dismiss();
    if(perEntity!=null)
    {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("nickName", perEntity.ygnc);
      setState(() {
        nickName=perEntity.ygnc;
        userId=perEntity.yhid.toString();
        smsCount=perEntity.dxCount.toString();
        balance="￥${perEntity.price}";
        plats=perEntity.plats;
        games=perEntity.games;
      });
    }
  }
  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children:  [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xffFFEBE5),
                      Color(0xffFAFAFA),
                    ]),
              ),
              child: Column(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: 36,
                      padding: const EdgeInsets.only(left: 20),
                      margin: const EdgeInsets.only(top: 46),
                      child:  Stack(
                        children:  [
                          const Text('我的', style: TextStyle(color: Color(0xFF333333), fontSize: 20,fontWeight: FontWeight.bold), textAlign: TextAlign.left),
                          Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(onPressed: () {
                                Navigator.push(context, PanPageRouteBuilder(builder: (context) {return const SettingPage();}, transitionDuration: const Duration(milliseconds: 300),
                                    popDirection: AxisDirection.left));
                              },iconSize: 36, icon:const Image(image: AssetImage("images/btn_setting.png"),width: 38,height:34)
                              )
                          )
                        ],
                      )
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: 80,
                      padding: const EdgeInsets.all(0),
                      margin: const EdgeInsets.only(top: 10,left: 20),
                      child: Row(
                        children:  [
                          Image.asset("images/img_avatar.png",width: 80,height:80),
                          Container(
                            width: 200,
                            height: 80,
                            padding: const EdgeInsets.all(0),
                            margin: const EdgeInsets.only(top: 10,left: 10),
                            child: Column(
                              children:  [
                                Container(
                                  padding: const EdgeInsets.all(0),
                                  margin: const EdgeInsets.all(0),
                                  width: 200,
                                  height: 26,
                                  child:  Text(nickName, style: const TextStyle(color: Color(0xFF333333), fontSize: 20), textAlign: TextAlign.left),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.all(0),
                                  margin: const EdgeInsets.all(0),
                                  width: 200,
                                  height: 36,
                                  child: Row(
                                      crossAxisAlignment:CrossAxisAlignment.center,
                                      children: [
                                        Image.asset("images/img_id.png",width: 26,height:18),
                                        Container(
                                          width: 100,
                                          height: 28,
                                          alignment: Alignment.topLeft,
                                          padding: const EdgeInsets.all(0),
                                          margin: const EdgeInsets.only(left: 10),
                                          child: Text(userId, style: const TextStyle(color: Color(0xFF333333), fontSize: 18), textAlign: TextAlign.start),
                                        ),
                                      ])
                                ),

                              ],
                            ),
                          )

                        ],
                      )
                  ),
                ],
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                height: 96,
                decoration:  const BoxDecoration(
                  color:Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                padding: const EdgeInsets.only(top: 10,bottom: 10),
                margin: const EdgeInsets.only(top: 10,left: 10,right: 10),
                child: Row(
                  children:  [
                    const Spacer(),
                    Container(
                      height: 70,
                      padding: const EdgeInsets.all(0),
                      margin: const EdgeInsets.only(top: 2,left: 20),
                      child: Column(
                        children:  [
                          const Image(image: AssetImage("images/img_yue.png"),width: 24,height:24),
                          Text(balance, style: const TextStyle(color:  Color(0xFF333333), fontSize: 18), textAlign: TextAlign.left),
                          const Text('账户余额', style: TextStyle(color:  Color(0xFF999999), fontSize: 14), textAlign: TextAlign.start),
                        ],
                      ),
                    ),
                    const Spacer(), const Spacer(),
                    const VerticalDivider(
                      indent: 6,
                      color: Colors.grey,
                      width: 1,
                    ),
                    const Spacer(), const Spacer(),
                    Container(
                      height: 70,
                      padding: const EdgeInsets.only(top:6),
                      margin: const EdgeInsets.only(top: 6,left: 2,right: 60),
                      child: Column(
                        children:  [
                          const Image(image: AssetImage("images/img_sms.png"),width: 24,height:20),
                          Text(smsCount, style: const TextStyle(color:  Color(0xFF333333), fontSize: 18), textAlign: TextAlign.left),
                          const Text('短信条数', style: TextStyle(color: Color(0xFF999999), fontSize: 14), textAlign: TextAlign.start),
                        ],
                      ),
                    ),
                    const Spacer()
                  ],
                )
            ),
            Container(
              width: MediaQuery.of(context).size.width-20,
              decoration:  const BoxDecoration(
                color:Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
              ),
              height: 50,
              padding: const EdgeInsets.only(left: 0,right: 0,top:6),
              margin: const EdgeInsets.only(left: 10,right: 10,top:10),
              child: Column(
                children: [
                  Row(
                    children:  [
                      Container(
                          width: 80,
                          height: 36,
                          padding: const EdgeInsets.all(0),
                          margin: const EdgeInsets.only(left: 10,right: 10,top:6),
                          child:   const Text('发单平台', style: TextStyle(color: Color(0xFF333333),fontWeight: FontWeight.bold, fontSize: 16))
                      ),
                      const Spacer(),
                      const Spacer(),
                      const Spacer(),
                      const Spacer(),
                      const Spacer(),
                      const Spacer(),
                      const Spacer(),
                      const Spacer(),
                      const Spacer(),
                      const Spacer(),
                      const Spacer(),
                      const Spacer(),
                      Container(
                          width: 60,
                          height: 36,
                          padding: const EdgeInsets.all(0),
                          margin: const EdgeInsets.only(left: 10,right: 0,top:8),
                          child:   GestureDetector(
                              onTap: () async{
                                var result=await Navigator.push(context, PanPageRouteBuilder(builder: (context) {return const PlatformAdd();}, transitionDuration: const Duration(milliseconds: 300),
                                    popDirection: AxisDirection.left));
                                if(result!=null)
                                {
                                  setState(() {
                                    PersonPlats ppa=result as PersonPlats;
                                    plats.insert(0, ppa);
                                  });
                                }
                              }, child: const Text('添加平台', style: TextStyle(color: Color(0xFF999999), fontSize: 14)))
                      ),
                      Container(
                          width: 7,
                          height: 22,
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.all(0),
                          margin: const EdgeInsets.only(left: 2,right: 10,top:2),
                          child:  const Image(image: AssetImage("images/arrow_right.png"),width: 7,height:12)
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
                color: Colors.white,
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(left: 10,right: 10,top:0),
                child:  ListView.builder(
                    itemCount: plats.length,
                    shrinkWrap:true,
                    padding: const EdgeInsets.only(top: 0),
                    physics:const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                          margin: const EdgeInsets.only(left: 0,right: 0,bottom:20),
                          padding: const EdgeInsets.only(left: 0,right: 0,top:0),
                          child:Row(
                            children: [
                              Container(
                                width: 46,height: 46,padding: const EdgeInsets.all(0),
                                margin: const EdgeInsets.only(left: 10),
                                child:  Image.asset("images/platform/${plats[index].platformPicture}",width: 46,height: 46),
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(width: 0.6, color: Color(0xFFE2E2E2)),
                                  ),
                                ),
                                height: 50,width:MediaQuery.of(context).size.width-110, padding: const EdgeInsets.all(0),
                                margin: const EdgeInsets.only(left: 20),
                                child: Row(children: [
                                  Container(
                                    width: 70,height: 24,
                                    padding: const EdgeInsets.all(0),
                                    margin: const EdgeInsets.only(bottom:0),
                                    child: Text(plats[index].platformName!, style: const TextStyle(color: Color(0xFF333333),fontWeight: FontWeight.bold, fontSize: 16)),
                                  ),
                                  const Spacer(),const Spacer(),  const Spacer(),
                                  const Spacer(),
                                  const Spacer(),
                                  const Spacer(),
                                  Container(
                                      width: 60,
                                      height: 26.4,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        gradient: const LinearGradient(colors: [
                                          Color(0xffFFBF3A),
                                          Color(0xffFF5100),
                                        ]),
                                      ),
                                      margin: const EdgeInsets.only(left: 10, right: 10, top: 0),
                                      child: ElevatedButton(
                                          onPressed: () async {
                                            var result=await Navigator.push(context, PanPageRouteBuilder(builder: (context) {return PlatformPage(findex: index,ptid:plats[index].id.toString());}, transitionDuration: const Duration(milliseconds: 300),
                                                popDirection: AxisDirection.left));

                                            // Navigator.of(context).pushAndRemoveUntil( PanPageRouteBuilder(builder: (context) => const MyApp(),transitionDuration: const Duration(milliseconds: 300),popDirection: AxisDirection.left), (route) => false);
                                          },
                                          style: ButtonStyle(
                                            //去除阴影
                                            elevation: MaterialStateProperty.all(0),
                                            //将按钮背景设置为透明
                                            backgroundColor: MaterialStateProperty.all(Colors.transparent),
                                          ),
                                          child: const Text("修改",
                                              style: TextStyle(color: Colors.white, fontSize: 14),
                                              textAlign: TextAlign.center))),
                                ])
                              ),
                            ])
                      );
                    })
            ),
            Container(
              decoration:  const BoxDecoration(
                color:Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
              ),
              width: MediaQuery.of(context).size.width-20,
              height: 36,
              padding: const EdgeInsets.all(0),
              margin: const EdgeInsets.only(left: 10,right: 10,top:10),
              child: Column(
                children: [
                  Row(
                    children:  [
                      Container(
                          width: 80,
                          height: 26,
                          padding: const EdgeInsets.all(0),
                          margin: const EdgeInsets.only(left: 10,right: 10,top:6),
                          child:  const Text('发单游戏', style: TextStyle(color: Color(0xFF333333),fontWeight: FontWeight.bold, fontSize: 16))
                      ),
                      const Spacer(),
                      const Spacer(),
                      const Spacer(),
                      const Spacer(),
                      const Spacer(),
                      const Spacer(),
                      const Spacer(),
                      const Spacer(),
                      const Spacer(),
                      const Spacer(),
                      const Spacer(),
                      const Spacer(),
                      Container(
                          width: 60,
                          height: 26,
                          padding: const EdgeInsets.all(0),
                          margin: const EdgeInsets.only(left: 10,right: 0,top:8),
                          child:   GestureDetector(
                            onTap: () async{
                              var result=await Navigator.push(context, PanPageRouteBuilder(builder: (context) {return const GamePage();}, transitionDuration: const Duration(milliseconds: 300),
                                  popDirection: AxisDirection.left));
                              if(result!=null)
                              {
                                bus.emit("setGames", "1");
                                setState(() {
                                  TbGame igame=result as TbGame;
                                  if(igame.yxmc!="")
                                  {
                                    PersonGames pg=PersonGames();
                                    pg.id=igame.id;
                                    pg.yxmc=igame.yxmc!;
                                    pg.kfpt=igame.kfpt!;
                                    games.insert(0,pg);
                                  }
                                });
                              }
                            }, child: const Text('添加游戏', style: TextStyle(color: Color(0xFF999999), fontSize: 14)))
                      ),
                      Container(
                          width: 7,
                          height: 12,
                          padding: const EdgeInsets.all(0),
                          margin: const EdgeInsets.only(left: 2,right: 10,top:2),
                          child:  const Image(image: AssetImage("images/arrow_right.png"),width: 7,height:12)
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
                color: Colors.white,
                padding: const EdgeInsets.all(0),
                alignment: Alignment.centerLeft,
                width: MediaQuery.of(context).size.width-20,
                margin: const EdgeInsets.only(left: 10,right: 10,top:0),
                child: ListView.builder(
                    itemCount: games.length,
                    shrinkWrap:true,
                    padding: const EdgeInsets.all(0),
                    physics:const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: ()async{
                          int tgid=games[index].id;
                          var result=await Navigator.push(context, PanPageRouteBuilder(builder: (context) {return  EditGame(tgid: tgid,tgindex: index,);}, transitionDuration: const Duration(milliseconds: 300),
                              popDirection: AxisDirection.left));
                          if(result!=null)
                          {
                            bus.emit("setGames", "1");
                            setState(() {
                              TbGame igame=result as TbGame;
                              if(igame.id>-1)
                              {
                                games[igame.index].kfpt=igame.kfpt!;
                                games[igame.index].yxmc=igame.yxmc!;
                              }
                            });
                          }
                        },
                          child: Container(
                        decoration:  const BoxDecoration(
                          color: Colors.white,
                          border:  Border(bottom: BorderSide(width: 1, color:Color.fromRGBO(247, 249, 253, 1))),
                        ),
                        alignment: Alignment.centerLeft,
                        width: MediaQuery.of(context).size.width-20,
                        padding: const EdgeInsets.only(left: 10,top: 6,bottom: 6),
                        margin: const EdgeInsets.all(0),
                        child: Column(children:  [
                          Flex(
                            direction: Axis.horizontal,
                            children: <Widget>[
                              Expanded(
                                flex: 68,
                                child:Container(
                                    padding:const EdgeInsets.all(0),
                                    margin: const EdgeInsets.all(0),
                                    height: 24,
                                    child:Text(games[index].yxmc, style: const TextStyle(color: Color(0xFF333333), fontSize: 16,fontWeight: FontWeight.bold))),
                              ),
                              Expanded(
                                flex: 32,
                                child: GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, PanPageRouteBuilder(builder: (context) {return SubPage(gid:games[index].id);}, transitionDuration: const Duration(milliseconds: 300),
                                          popDirection: AxisDirection.left));
                                    },
                                    child:Row(
                                      children: [
                                        Container(
                                            padding:const EdgeInsets.all(0),
                                            margin: const EdgeInsets.only(top: 3),
                                            height: 24,
                                            child:const Text("代练类型配置", style: TextStyle(color: Color(0xFF999999), fontSize: 14))
                                        ),
                                        Container(
                                            width: 7,
                                            height: 24,
                                            padding: const EdgeInsets.all(0),
                                            margin: const EdgeInsets.only(left: 2,right: 10,top:0),
                                            child:  const Image(image: AssetImage("images/arrow_right.png"),width: 7,height:12)
                                        ),
                                      ]
                                    )
                                ) ,
                              ),
                            ],
                          ),
                          Container(
                              padding:const EdgeInsets.all(0),
                              margin: const EdgeInsets.all(0),
                              width: MediaQuery.of(context).size.width-10,
                              child:Text(games[index].kfpt, style: const TextStyle(color: Color(0xFF999999), fontSize: 12))),
                        ]),
                      ));
                    }
                )
            ),
          ],
        )
      )
    );
  }
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

