

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lanzhong/model/api_response/list_data.dart';
import 'package:lanzhong/request/request_client.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'imagepreview.dart';
import 'model/api_response/api_response_entity.dart';
import 'model/message_entity.dart';
import 'model/orders_entity.dart';



class ChatPage extends StatefulWidget {
  final OrdersData order;
  final String ptddh;
  const ChatPage({super.key, required this.order,required this.ptddh});
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  late ScrollController scrollController;
  List<MessageEntity> messages=[];
  TextEditingController textContent= TextEditingController();
  var logger = Logger(printer: PrettyPrinter());
  void loadMessage() async{
    Map<String, dynamic>? formData = {"id": widget.order.id, "ptzt":  widget.order.zt,"ptName":  widget.order.dlpt};
    RequestClient requestClient = RequestClient();
    String url = "/Order/GetMessage";
    debugPrint("开始加载数据");
    Map<String, dynamic>? headers={"Content-type":"application/x-www-form-urlencoded"};
    ListData<MessageEntity>? pte = await requestClient.post<ListData<MessageEntity>>(url,data: formData,headers: headers,onError: (e){
      return e.code==0;
    }).whenComplete((){
      debugPrint("加载数据完成2");
    });
    debugPrint("加载数据完成1");
    if(pte!=null)
    {
      setState(() {
        messages=pte.data!;
      });
    }
  }
  Widget widChat(int index) {
    if(messages[index].nickName=="发单者:"||messages[index].nickName=="发单者")
    {
      return  Container(
        alignment: Alignment.centerRight,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(top: 10,left: 60,right: 16),
        padding: const EdgeInsets.all(0),
        child: Stack(
            alignment: AlignmentDirectional.topEnd,
            children: [
              Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              Expanded(
                flex: 8,
                child: Container(
                  height: 30.0,
                  alignment: Alignment.topRight,
                  padding: const EdgeInsets.only(left: 2,top: 6),
                  child: Text(messages[index].createTime,style: const TextStyle(color: Color(0xFF999999), fontSize: 12)),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  height: 30.0,
                  alignment: Alignment.topRight,
                  padding: const EdgeInsets.only(left: 2,top: 6,right: 10),
                  child:  Text(messages[index].nickName.replaceAll(":","")),
                ),
              ),
            ],
          ),
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                margin: const EdgeInsets.only(top: 32,right: 10),
                padding: const EdgeInsets.only(left: 10,top: 10,bottom: 10,right: 10),
                child:  messages[index].msgStr.contains(".png")|| messages[index].msgStr.contains(".jpg")|| messages[index].msgStr.contains(".jpeg")|| messages[index].msgStr.contains(".webp")?GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CommonRouteWrapper(
                            imageProvider:  NetworkImage(messages[index].msgStr),
                            loadingBuilder: (context, event) {
                              if (event == null) {
                                return const Center(
                                  child: Text("Loading"),
                                );
                              }

                              final value = event.cumulativeBytesLoaded /
                                  (event.expectedTotalBytes ??
                                      event.cumulativeBytesLoaded);

                              final percentage = (100 * value).floor();
                              return Center(
                                child: Text("$percentage%"),
                              );
                            },
                          ),
                        ),
                      );
                    },
                    child:Container(
                        padding: const EdgeInsets.all(0),
                        margin: const EdgeInsets.all(0),
                        width: 100,
                        child:Image.network(messages[index].msgStr,width: 100)) ): Text(messages[index].msgStr,style: const TextStyle(color: Color(0xFF333333), fontSize: 16)),
              )

        ]),
      );
    }
    else
    {
      return  Container(
        alignment: Alignment.centerLeft,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(top: 10,left: 16,right: 60),
        padding: const EdgeInsets.all(0),
        child: Stack(children: [
          Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  height: 30.0,
                  padding: const EdgeInsets.only(left: 2,top: 6),
                  child:  Text(messages[index].nickName.replaceAll(":","")),
                ),
              ),
              Expanded(
                flex: 8,
                child: Container(
                  height: 30.0,
                  padding: const EdgeInsets.only(left: 2,top: 6),
                  child: Text(messages[index].createTime,style: const TextStyle(color: Color(0xFF999999), fontSize: 12)),
                ),
              ),
            ],
          ),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFFFFFFF),
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            margin: const EdgeInsets.only(top: 32),
            padding: const EdgeInsets.only(left: 10,top: 10,bottom: 10,right: 10),
            child: messages[index].msgStr.contains(".png")|| messages[index].msgStr.contains(".jpg")|| messages[index].msgStr.contains(".jpeg")|| messages[index].msgStr.contains(".webp")?GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CommonRouteWrapper(
                      imageProvider:  NetworkImage(messages[index].msgStr),
                      loadingBuilder: (context, event) {
                        if (event == null) {
                          return const Center(
                            child: Text("Loading"),
                          );
                        }

                        final value = event.cumulativeBytesLoaded /
                            (event.expectedTotalBytes ??
                                event.cumulativeBytesLoaded);

                        final percentage = (100 * value).floor();
                        return Center(
                          child: Text("$percentage%"),
                        );
                      },
                    ),
                  ),
                );
              },
                child:Container(
                padding: const EdgeInsets.all(0),
                margin: const EdgeInsets.all(0),
                width: 100,
                child:Image.network(messages[index].msgStr,width: 100)) ) :
            Text(messages[index].msgStr,style: const TextStyle(color: Color(0xFF333333), fontSize: 16))
          )

        ]),
      );
    }
  }
  void addMessage() async{
    if(textContent.text=="")
    {
      await showOkAlertDialog(
          context: context,
          title: '提示',
          message: '留言不能为空！');
      return;
    }
    Map<String, dynamic>? formData = {
      "id": widget.order.id,
      "ptzt":  widget.order.zt,
      "ptName": widget.order.dlpt,
      "content": textContent.text
    };
    RequestClient requestClient = RequestClient();
    String url = "/Order/AddChat";
    Map<String, dynamic>? headers={"Content-type":"application/x-www-form-urlencoded"};
    MessageEntity? pte = await requestClient.post<MessageEntity>(url,data: formData,headers: headers,onError: (e){
      return e.code==0;
    });
    if(pte!=null)
    {
      setState(() {
        messages.add(pte);
      });
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      Future.delayed(const Duration(milliseconds: 600), () {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      });
      textContent.text="";
    }
  }
  bool isHaveText=false;
  double extendHeight=0;
  final ImagePicker _picker = ImagePicker();
  String userToken="";
  void loadUserData () {
    Future<SharedPreferences> prefs =  SharedPreferences.getInstance();
    prefs.then((fpv){
      userToken= fpv.getString("token")!;
    });
  }
  late FocusNode focusNode;
  Timer? _timer;
  late double _progress;
  @override
  void initState() {

    focusNode = FocusNode();
    scrollController = ScrollController();
    loadUserData ();
    textContent.addListener(() {
      setState(() {
        isHaveText=textContent.text.isNotEmpty;
        extendHeight=100;
      });
    });
    loadMessage();
    Future.delayed(const Duration(milliseconds: 600), () {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            // 触摸收起键盘
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child:Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 68,
            padding: const EdgeInsets.only(left: 0,top: 32),
            child: Row(children: [
              IconButton(onPressed: () {
                Navigator.pop(context);
              }, icon:  Image.asset("images/arrow_left.png",width: 32,height: 54)),
              const Text('订单留言', style: TextStyle(color: Color(0xFF333333), fontSize: 18), textAlign: TextAlign.left)
            ]
            ),
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.topLeft,
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.all(0),
              margin:  const EdgeInsets.only(top: 68,left: 0,right: 0,bottom: 50),
              child:SingleChildScrollView(
                controller: scrollController,
                child: MediaQuery.removePadding(
                removeTop: true, context: context,removeBottom: true,
                child:ListView.builder(
                    scrollDirection:Axis.vertical,
                    itemCount: messages.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return  widChat(index);
                    }
                ) ,
              ),)
          ),

          Positioned(
            bottom: 0,
            left:0,
            right:0,
            child: Container(
              color: const Color(0xFFF7F7F7),
              width: MediaQuery.of(context).size.width,
              constraints: const BoxConstraints(minHeight: 50.0, maxHeight: 160.0),
              padding: const EdgeInsets.only(left: 0,right: 0,top:2,bottom: 2),
              child: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  Expanded(
                    flex: 85,
                    child: Container(
                      margin: const EdgeInsets.only(left:6,right: 6),
                      padding: const EdgeInsets.only(left: 6,top: 3,bottom: 3),
                      child:  TextField(
                        maxLines: null,
                        controller: textContent,
                        focusNode: focusNode,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 6),
                            hintText: '', isDense: true,
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                BorderRadius.all(Radius.circular(3)))),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 15,
                    child:Stack(children: [
                      Visibility(
                          visible: !isHaveText,
                          child:GestureDetector(
                              onTap: ()async {
                                final selectResult= await showModalActionSheet<String>(
                                  context: context,
                                  actions: [
                                    const SheetAction(
                                      icon: Icons.photo,
                                      label: '相册',
                                      key: 'photo',
                                    ),
                                    const SheetAction(
                                      icon: Icons.camera_enhance,
                                      label: '相机',
                                      key: 'camera',
                                    ),
                                  ],
                                );
                                if(context.mounted)
                                {
                                  FocusScope.of(context).requestFocus(FocusNode());
                                }
                                XFile? pickedFile;
                                if(selectResult=="photo")
                                {
                                  try {
                                    pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                                  } catch (e) {
                                    EasyLoading.dismiss();
                                  }
                                }
                                else if(selectResult=="camera")
                                {
                                  try {
                                    pickedFile = await _picker.pickImage(source: ImageSource.camera);
                                  } catch (e) {
                                    EasyLoading.dismiss();
                                  }
                                }
                                if(pickedFile!=null)
                                {
                                  //XFile? compressFile= await FlutterImageCompress.compressWithFile(pickedFile.path,quality: 90);
                                  Uint8List? compressFile= await FlutterImageCompress.compressWithFile(pickedFile.path,quality: 90);
                                  if(compressFile!=null)
                                  {
                                    String comPath=pickedFile.path;
                                    var name = comPath.substring(comPath.lastIndexOf("/") + 1, comPath.length);
                                    FormData imgData = FormData.fromMap(
                                      {
                                        "file1": await MultipartFile.fromBytes(compressFile,filename: name),
                                        "ptName":widget.order.dlpt,
                                        "ptddh":widget.ptddh
                                      },
                                    );
                                    BaseOptions option = BaseOptions(contentType: 'multipart/form-data', responseType: ResponseType.plain);
                                    if(userToken.isNotEmpty)
                                    {
                                      option.headers["Authorization"] = "Bearer $userToken";
                                    }
                                    Dio dio = Dio(option);
                                    try {
                                      var response = await dio.post<String>("https://appapi.lzsterp.com/api/Order/UploadFile",
                                          data: imgData,
                                          onSendProgress: (percent1,percent2)
                                          {
                                            int jd1= percent1*100~/percent2;
                                            double jd2= jd1/100;
                                            if(jd1<100)
                                            {
                                              EasyLoading.showProgress(jd2,status: "已上传$jd1%");
                                            }
                                            else
                                            {
                                              EasyLoading.dismiss();
                                            }
                                          }
                                      );
                                      EasyLoading.dismiss();
                                      if (response.statusCode == 200) {
                                        final jsonResponse = json.decode(response.data!);
                                        ApiResponse<MessageEntity> apiRes = ApiResponse.fromJson(jsonResponse);
                                        if(apiRes.code==0)
                                        {
                                          if(apiRes.data!=null)
                                          {
                                            setState(() {
                                              messages.add(apiRes.data!);
                                            });
                                            Future.delayed(const Duration(milliseconds: 600), () {
                                              scrollController.jumpTo(scrollController.position.maxScrollExtent);
                                            });
                                          }
                                        }
                                        else
                                        {
                                          EasyLoading.showError(apiRes.message!);
                                        }
                                      }
                                    } catch (e) {
                                      //print("e:" + e.toString() + "   head=" + dio.options.headers.toString());
                                      EasyLoading.showError(e.toString());
                                    }
                                  }

                                }
                              },
                              child:
                              Container(
                                height: 32.0,
                                width: 40,
                                margin:const EdgeInsets.only(right: 6,top: 0,left: 6),
                                padding: const EdgeInsets.all(0),
                                child: const Image(image: AssetImage('images/btn_add.png')),
                              )
                          )
                      ),
                      Visibility(
                          visible: isHaveText,
                          child:Container(
                            height: 36.0,
                            width: 60,
                            decoration: const BoxDecoration(
                              color:  Color(0xFF05C160),
                              borderRadius: BorderRadius.all(Radius.circular(2)),
                            ),

                            margin:const EdgeInsets.only(right: 6,top: 0,left: 2),
                            padding: const EdgeInsets.all(0),
                            child:  TextButton(onPressed: (){
                              addMessage();
                              // _progress = 0;
                              // _timer?.cancel();
                              // _timer = Timer.periodic(const Duration(milliseconds: 100),
                              //         (Timer timer) {
                              //       EasyLoading.showProgress(_progress,
                              //           status: '${(_progress * 100).toStringAsFixed(0)}%');
                              //       _progress += 0.03;
                              //
                              //       if (_progress >= 1) {
                              //         _timer?.cancel();
                              //         EasyLoading.dismiss();
                              //       }
                              //     });
                            }, child: const Text("发送",style: TextStyle(color: Color(0xFFffffff), fontSize: 14)),
                            ),
                          )
                      )
                    ]),
                  ),
                ],
              ),
            ) ,
          ),
        ],
      )),
    );
  }
}
