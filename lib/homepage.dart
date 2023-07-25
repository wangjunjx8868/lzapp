import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lanzhong/model/api_response/list_data.dart';
import 'package:lanzhong/request/request_client.dart';
import 'event_bus.dart';
import 'model/ptzt_entity.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  final List banners = ["images/banner1.png", "images/banner1.png"];
  late List<Widget> boxes=[];
  List<PtztEntity> zts=[];
  Future<void> _getData()  async {
    String url = "/Order/LoadZt";
    RequestClient requestClient = RequestClient();
    ListData<PtztEntity>? ptzt= await requestClient.get<ListData<PtztEntity>>(url,onError: (e){
      EasyLoading.dismiss();
      EasyLoading.showError(e.message!);
      return e.code==0;
    },onSuccess: (res){

    });
    if(ptzt!=null)
    {
         setState(() {
           zts=ptzt.data!;
         });
    }
  }
  late BuildContext dialogkf;
  void showKf()
  {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext  ctx) {
        dialogkf=ctx;
        return StatefulBuilder(builder: (BuildContext context, void Function(void Function()) setState) {
          return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
              child: Container(
                width: 280,
                height: 400,
                padding: const EdgeInsets.all(0),
                margin: const EdgeInsets.all(0),
                child: Column(children: [
                  Container(
                    height: 28,
                    width: MediaQuery.of(ctx).size.width,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 20),
                    margin: const EdgeInsets.only(top:10),
                    child:  const Text("客户经理",style:  TextStyle(color:Color(0xFF333333),fontWeight: FontWeight.bold,fontSize: 18)),
                  ),
                  Container(
                    height: 264,
                    width: MediaQuery.of(ctx).size.width,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 10),
                    margin: const EdgeInsets.only(top:10),
                    child:   Image.asset("images/weixin.jpg",width: 200,height: 264),
                  ),
                  Container(
                    height: 28,
                    width: MediaQuery.of(ctx).size.width,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 10),
                    margin: const EdgeInsets.only(top:10),
                    child:   Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:  [
                          const Spacer(),
                          const Text("微信号：",style:  TextStyle(color:Color(0xFF333333),fontSize: 14)),
                          const Text("lzst20220109",style:  TextStyle(color:Color(0xFF333333),fontSize: 14)),
                         GestureDetector(
                           onTap: (){
                             Clipboard.setData(const ClipboardData(text:"lzst20220109"));
                             EasyLoading.showSuccess("已复制到粘贴板");
                           },
                           child: Container(
                           height: 26,
                           alignment: Alignment.center,
                           padding: const EdgeInsets.all(0),
                           margin: const EdgeInsets.all(0),
                           child:const Text("  复制  ",style:  TextStyle(color:Color(0xFF333333),fontSize: 14)),
                         ),),
                          const Spacer(),
                    ]),
                  ),
                  Container(
                      width: MediaQuery.of(ctx).size.width,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(0),
                      margin: const EdgeInsets.only(top:10),
                      child: GestureDetector(
                          onTap: (){
                              Navigator.pop(dialogkf);
                          },
                          child:const Text("关闭",style:  TextStyle(color:Color(0xFF333333),fontSize: 16)))
                  )
                ]),
              )
          );
        });
      },
    );
  }
  @override
  void initState() {
    super.initState();
    _getData();
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
        child:Column(
            children: [
            Container(
              alignment: Alignment.topCenter,
              decoration:  const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xffFFEBE5),
                        Color(0xffFFFFFF),
                      ]),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
              ),
              width: MediaQuery.of(context).size.width,
              child: Column(
                  children: [
                    Container(
                      height: 43,
                      width: MediaQuery.of(context).size.width,
                      alignment:Alignment.centerLeft ,
                      margin: const EdgeInsets.only(left: 10, top: 30),
                      child:Image.asset("images/main_banner.png"),
                    ),
                    Container(
                        height: (MediaQuery.of(context).size.width-40)*388/960,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child:
                        Swiper(
                          itemBuilder: (BuildContext context,int index){
                            return Image.asset(banners[index], fit: BoxFit.fill);
                          },
                          itemCount: banners.length,
                          pagination: const SwiperPagination(),
                          control: const SwiperControl(),
                        )
                    ),
                    Container(
                        decoration:  BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xffFFEEEE),
                                Color(0xffFFFFFF),
                              ]),
                        ),
                        margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        alignment: Alignment.topLeft,
                        child: Row(children: [
                          Container(
                              margin: const EdgeInsets.only(top: 0, left: 12),
                              alignment: Alignment.centerLeft,
                              child: Image.asset("images/img_lan.png",width: 76,height: 19),
                          ),
                          // const Spacer(),
                          // Container(
                          //   margin: const EdgeInsets.only(top: 0, left: 12),
                          //   alignment: Alignment.centerLeft,
                          //     child: const Text('关于我们', style: TextStyle(color: Color(0xFF333333), fontSize: 14))
                          // ),
                          // Container(
                          //   margin: const EdgeInsets.only(top: 0, left: 10,right: 10),
                          //   alignment: Alignment.centerLeft,
                          //   child: Image.asset("images/arrow_right.png",width:8,height: 15),
                          // ),
                        ])
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 10),
                        alignment: Alignment.center,
                        child: Row(
                          children:  [
                            Expanded(child: GestureDetector(onTap: (){
                              EasyLoading.showToast("开发中");
                            }, child:const Image(image: AssetImage("images/lz1.png"), width: 29.0, height: 33.0))),
                            Expanded(child: GestureDetector(onTap: (){
                              EasyLoading.showToast("开发中");
                            }, child:const Image(image: AssetImage("images/lz2.png"), width: 33.0, height: 33.0))),
                            Expanded(child: GestureDetector(onTap: (){
                              EasyLoading.showToast("开发中");
                            }, child:const Image(image: AssetImage("images/lz3.png"), width: 29.0, height: 33.0))),
                            Expanded(child: GestureDetector(onTap: (){
                              showKf();
                            }, child:const Image(image: AssetImage("images/lz4.png"), width: 29.0, height: 33.0))),
                          ],
                        )
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 10,bottom: 20),
                        alignment: Alignment.center,
                        child: Row(
                          children:  [
                            Expanded(child: GestureDetector(
                              onTap: (){
                                EasyLoading.showToast("开发中");
                              },
                                child: const Text("发单攻略", textAlign: TextAlign.center,style: TextStyle(color: Color.fromRGBO(51, 51, 51, 1), fontSize: 12)))),
                            Expanded(child:GestureDetector(
                              onTap: (){
                                EasyLoading.showToast("开发中");
                              },
                                child: const Text("视频教程", textAlign: TextAlign.center,style: TextStyle(color: Color.fromRGBO(51, 51, 51, 1), fontSize: 12)))),
                            Expanded(child: GestureDetector(
                              onTap: (){
                                EasyLoading.showToast("开发中");
                              },
                                child: const Text("发单配置", textAlign: TextAlign.center,style: TextStyle(color: Color.fromRGBO(51, 51, 51, 1), fontSize: 12)))),
                            Expanded(child:GestureDetector(
                              onTap: (){
                                showKf();
                              },
                                child: const Text("客户经理", textAlign: TextAlign.center,style: TextStyle(color: Color.fromRGBO(51, 51, 51, 1), fontSize: 12))))
                          ],
                        ))
                  ])
          ),
              Container(
                  alignment:Alignment.centerLeft ,
                  margin: const EdgeInsets.only(top: 10, left: 20),
                  child: const Text('我的发单', style: TextStyle(color: Color(0xFF333333), fontSize: 20,fontWeight: FontWeight.bold))
              ),
              Container(
                  decoration:  BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
                  width: MediaQuery.of(context).size.width-30,
                  height: 160,
                  alignment: Alignment.topLeft,
                  child: Stack(children: [
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: 146,
                        margin: const EdgeInsets.only(top: 0),
                        child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                childAspectRatio: 1.2,
                                mainAxisSpacing:1
                            ),
                            itemCount: zts.length,
                            padding: const EdgeInsets.only(top: 10,bottom: 10,left: 10,right: 10),
                            shrinkWrap:true,
                            physics:const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return InkWell(
                                  onTap: (){
                                    bus.emit("pvChange", (index+1).toString());
                                  },
                                  child:  Container(
                                    width: 46,
                                    height: 46,
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(width:1, color: Color(0xFFE2E2E2)),
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(0),
                                    margin: const EdgeInsets.only(top: 0),
                                    child: Column(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(top:10,bottom: 6),
                                            child:   Text(zts[index].sl>1000?"999+":zts[index].sl.toString().replaceAll(".0",""), style: const TextStyle(color: Color(0xFF333333),fontFamily: "PangMen", fontSize: 20)),
                                          ),
                                          Row(children: [
                                            const Spacer(),
                                            Text(zts[index].ddzt, style: const TextStyle(color: Color(0xFF999999), fontSize: 12)),
                                            Container(
                                              margin: const EdgeInsets.only(left: 6),
                                              padding: const EdgeInsets.all(0),
                                              child: SizedBox(
                                                  width: 4.5,height:8 ,
                                                  child:Image.asset("images/arrow_right.png")
                                              )
                                            ),
                                            const Spacer()
                                          ])
                                        ]
                                    ),
                                  )
                              );
                            })
                    ),
                  ])
              ),

              Container(
                  margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
                  width: MediaQuery.of(context).size.width-30,
                  padding: const EdgeInsets.all(0),
                  height: 80,
                  alignment: Alignment.center,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:  [
                        Container(
                          width: (MediaQuery.of(context).size.width-50)/3,
                          decoration:  BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                            alignment:Alignment.center,
                          padding: const EdgeInsets.all(0),
                          margin: const EdgeInsets.all(0),
                          child: Row(
                              mainAxisAlignment:MainAxisAlignment.center,
                              crossAxisAlignment:CrossAxisAlignment.end,
                              children: [
                                Column(children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 10, left: 0),
                                    alignment: Alignment.centerLeft,
                                    child:  const Text("安全", style: TextStyle(color: Color(0xFF333333),fontWeight: FontWeight.bold, fontSize: 16)),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 6, left: 10),
                                    alignment: Alignment.centerLeft,
                                    child:  const Text("实力担保\n打坏包赔", style: TextStyle(color:  Color(0xFF999999), fontSize: 12)),
                                  )
                                ]),
                                Container(
                                    margin: const EdgeInsets.only(left: 10,bottom: 12,right: 10),
                                    alignment: Alignment.bottomLeft, width: 18.0, height: 20.0,
                                    child:  const Image(image: AssetImage("images/tip_1.png"), width: 18.0, height: 20.0)
                                )
                              ])
                        ),
                        Container(
                            width: (MediaQuery.of(context).size.width-50)/3,
                          decoration:  BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          padding: const EdgeInsets.all(0),
                          margin: const EdgeInsets.only(left: 2),
                            alignment:Alignment.center,
                          child:  Row(
                              mainAxisAlignment:MainAxisAlignment.center,
                              crossAxisAlignment:CrossAxisAlignment.end,
                              children: [
                                Column(children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 10, left: 0),
                                    alignment: Alignment.centerLeft,
                                    child:  const Text("快捷", style: TextStyle(color: Color(0xFF333333),fontWeight: FontWeight.bold, fontSize: 16)),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 6, left: 10),
                                    alignment: Alignment.centerLeft,
                                    child:  const Text("快速发单\n一秒查价", style: TextStyle(color:  Color(0xFF999999), fontSize: 12)),
                                  )
                                ]),
                                Container(
                                    margin: const EdgeInsets.only(left: 10,bottom: 12,right: 10),
                                    alignment: Alignment.bottomLeft,
                                    width: 20.0, height: 20.0,
                                    child:  const Image(image: AssetImage("images/tip_2.png"), width: 20.0, height: 20.0)
                                )
                              ])
                        ),
                        Container(
                            width: (MediaQuery.of(context).size.width-50)/3,
                          decoration:  BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          padding: const EdgeInsets.all(0),
                          margin: const EdgeInsets.only(left: 2),
                          alignment:Alignment.center,
                          child: Row(
                              mainAxisAlignment:MainAxisAlignment.center,
                              crossAxisAlignment:CrossAxisAlignment.end,
                              children: [
                                Column(children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 10, left: 0),
                                    alignment: Alignment.centerLeft,
                                    child:  const Text("极速", style: TextStyle(color: Color(0xFF333333),fontWeight: FontWeight.bold, fontSize: 16)),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 6, left: 10),
                                    alignment: Alignment.centerLeft,
                                    child:  const Text("海量打手\n极速上号", style: TextStyle(color:  Color(0xFF999999), fontSize: 12)),
                                  )
                                ]),
                                Container(
                                    margin: const EdgeInsets.only(left: 10,bottom: 12,right: 10),
                                    alignment: Alignment.bottomLeft,width: 20.0, height: 20.0,
                                    child:  const Image(image: AssetImage("images/tip_3.png"), width: 20.0, height: 20.0)
                                )
                              ])
                        )
                      ]
                  ),
              ),
              Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(0),
                  child:  const Image(image: AssetImage("images/home_bottom.png"), width: 116.0, height: 12.5)
              ),
        ])
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
