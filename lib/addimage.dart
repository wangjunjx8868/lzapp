
import 'dart:convert';
import 'dart:typed_data';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lanzhong/model/api_response/list_data.dart';
import 'package:lanzhong/request/request_client.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'imagepreview.dart';
import 'model/UploadPoint.dart';
import 'model/image_url_entity.dart';
import 'model/orders_entity.dart';
import 'model/uploads_entity.dart';


class ImagePage extends StatefulWidget {
  final OrdersData order;
  const ImagePage({super.key, required this.order});

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  ScrollController scrollController = ScrollController();
  TextEditingController bzController = TextEditingController();
  List<ImageUrlEntity> messages=[];
  var logger = Logger(printer: PrettyPrinter());
  void loadMessage() async{
    RequestClient requestClient = RequestClient();
    String url = "/Order/GetImagesDesc";
    Map<String, dynamic>? formData = {"id": widget.order.id, "ptzt":  widget.order.zt,"ptName":  widget.order.dlpt};
    Map<String, dynamic>? headers={"Content-type":"application/x-www-form-urlencoded"};
    ListData<ImageUrlEntity>? pte = await requestClient.post<ListData<ImageUrlEntity>>(url,data: formData,headers: headers,onError: (e){
      return e.code==0;
    });
    if(pte!=null)
    {
      setState(() {
        messages=pte.data!;
      });
    }
  }
  final ImagePicker _picker = ImagePicker();
  List<UploadPoint> ups=[];
  //bool isSelectedFile=false;
  //File? compressFile;
  //CompressImagesFlutter compressImagesFlutter = CompressImagesFlutter();

  String userToken="";
  void loadUserData () {
    Future<SharedPreferences> prefs =  SharedPreferences.getInstance();
    prefs.then((fpv){
      userToken= fpv.getString("token")!;
    });
  }
  @override
  void initState() {
    super.initState();
    loadUserData ();
    loadMessage();
    ups.add(UploadPoint(false, null));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.white,
      body: SingleChildScrollView(child: Column(
        crossAxisAlignment:CrossAxisAlignment.start,
        verticalDirection: VerticalDirection.down,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 68,
            padding: const EdgeInsets.only(left: 0,top: 32),
            child: Row(children: [
              IconButton(onPressed: () {
                Navigator.pop(context);
              }, icon:  Image.asset("images/arrow_left.png",width: 20,height: 36)),
              const Spacer(),
              const Text('提交截图', style: TextStyle(color: Color(0xFF333333), fontSize: 18), textAlign: TextAlign.left),
              const Spacer(),
              const Spacer(),
            ]
            ),
          ),
          Container(
              decoration:  const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xffFFBF3A),
                      Color(0xffFF5100),
                    ]),
                borderRadius: BorderRadius.all( Radius.circular(10)),
              ),
              margin:  const EdgeInsets.only(left: 15,right: 15),
              height: 70,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(left: 0,top: 25,bottom: 10),
              child:  const Text('温馨提示    请上传聊天/进度截图', style: TextStyle(color: Colors.white, fontSize: 16), textAlign: TextAlign.center)
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 36, margin:  const EdgeInsets.only(left: 15,right: 15,top: 10),
            decoration:  const BoxDecoration(
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(0),
            child:const Text("截图说明",style: TextStyle(color: Color(0xFF333333),fontWeight: FontWeight.bold, fontSize: 16))
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              margin:  const EdgeInsets.only(left: 15,right: 15,top: 0),
              decoration:  const BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.all( Radius.circular(10)),
              ),
              padding: const EdgeInsets.all(0),
              child: Column(
                  children:  [
                    Container(
                        width: MediaQuery.of(context).size.width-30,height: 46,
                        margin: const EdgeInsets.only(left: 2,top: 0,bottom: 6),
                        child:   TextField(
                          controller: bzController,
                          textAlign: TextAlign.left,
                          style: const TextStyle(fontSize: 16),
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            //内容的内边距
                              contentPadding: EdgeInsets.all(6),
                              hintText: '请输入截图说明',
                              border:InputBorder.none
                          ),
                        )
                    )
                  ]
              )
          ),
          Container(
              color: const Color(0xFFFFFFFF),
              width: MediaQuery.of(context).size.width,
              height: 140,
              padding: const EdgeInsets.only(left: 0,top: 10,bottom: 10),
              margin: const EdgeInsets.only(top: 0,bottom: 0),
              child: ListView.builder(
                  scrollDirection:Axis.horizontal,
                  itemCount: ups.length,
                  shrinkWrap:true,
                  physics:const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return  Stack(
                        fit:StackFit.loose,
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            color: const Color(0xFFF7F9FD),
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.only(left: 10),
                            child:  Center(
                              child: ups[index].isSelectedFile?Image.memory(ups[index].ut8l!, width: 100, height: 100,fit: BoxFit.fill):
                              GestureDetector(onTap: ()async{
                                final selectResult= await showModalActionSheet<String>(
                                  context:context,
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
                                XFile? pickedFile;
                                if(selectResult=="photo")
                                {
                                  try {
                                    pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                                  } catch (e) {

                                  }
                                }
                                else if(selectResult=="camera")
                                {
                                  try {
                                    pickedFile = await _picker.pickImage(source: ImageSource.camera);
                                  } catch (e) {

                                  }
                                }
                                if(pickedFile!=null)
                                {
                                  //CompressImagesFlutter compressImagesFlutter = CompressImagesFlutter();
                                  //File? compressFile= await compressImagesFlutter.compressImage(pickedFile.path, quality: 70);
                                  String comPath=pickedFile.path;
                                  var filename = comPath.substring(comPath.lastIndexOf("/") + 1, comPath.length);
                                  Uint8List? compressFile= await FlutterImageCompress.compressWithFile(pickedFile.path,quality: 90);
                                  setState(() {
                                    ups[index].isSelectedFile=true;
                                    //ups[index].compressFile=compressFile;
                                    ups[index].ut8l=compressFile;
                                    ups[index].fileName=filename;
                                    if(ups.length<3)
                                    {
                                      ups.add(UploadPoint(false, null));
                                    }
                                  });
                                }
                              },child:Image.asset("images/btn_camera.png", width: 28, height: 28)) ,
                            ),
                          ),
                          Visibility(
                              visible:  ups[index].isSelectedFile,
                              child: Positioned(
                                right: -10,top: -10,
                                child: GestureDetector(
                                    onTap: (){
                                      debugPrint("取消11111111111111");
                                      setState(() {
                                        ups[index].isSelectedFile=false;
                                        try {
                                          //ups[index].compressFile?.delete();
                                          //ups[index].compressFile=null;
                                          ups[index].ut8l=null;
                                          if(ups.length>1)
                                          {
                                            ups.removeAt(index);
                                          }
                                        } catch (e) {
                                          debugPrint(e.toString());
                                        }
                                      });
                                    },
                                    child:Image.asset("images/btn_close.png", width: 22, height: 22)) ,
                              ))
                        ]);
                  }
              )
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                gradient: const LinearGradient(colors: [
                  Color(0xffFFBF3A),
                  Color(0xffFF5100),
                ]),
              ),
              margin: const EdgeInsets.only(left: 20, right: 20, top: 0),
              child: ElevatedButton(
                  onPressed: () async {
                    if(ups.any((element) => element.isSelectedFile==true))
                    {
                    }
                    else
                    {
                      await EasyLoading.showError("请至少选择一个图！");
                      return;
                    }
                    FormData imgData=FormData();
                    int findex=1;
                    for (var ufile in ups) {
                      if(ufile.isSelectedFile&&ufile.ut8l!=null)
                      {
                        //String upath=ufile.compressFile!.path;
                        //var fileName = upath.substring(upath.lastIndexOf("/") + 1, upath.length);
                        imgData.files.add(MapEntry("file$findex", await MultipartFile.fromBytes(ufile.ut8l!,filename:ufile.fileName )));
                        findex++;
                      }
                    }
                    imgData.fields.add( MapEntry("ptName",widget.order.dlpt));
                    imgData.fields.add( MapEntry("ptddh",widget.order.ptddh));
                    imgData.fields.add( MapEntry("remark",bzController.text));
                    BaseOptions option = BaseOptions(contentType: 'multipart/form-data', responseType: ResponseType.plain);
                    if(userToken.isNotEmpty)
                    {
                      option.headers["Authorization"] = "Bearer $userToken";
                    }
                    Dio dio = Dio(option);
                    try {
                      var response = await dio.post<String>("https://appapi.lzsterp.com/api/Order/UploadFiles",
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
                      if (response.statusCode == 200) {
                        EasyLoading.dismiss();
                        final jsonResponse = json.decode(response.data!);
                        UploadsEntity apiRes = UploadsEntity.fromJson(jsonResponse);
                        if(apiRes.code==0)
                        {
                          setState(() {
                            for(var item in apiRes.data)
                            {
                              ImageUrlEntity iue=ImageUrlEntity();
                              iue.createTime=item.createTime;
                              iue.imgUrl=item.msgStr;
                              iue.msg=item.remark;
                              iue.title=item.nickName;
                              messages.insert(0,iue);
                            }
                            for (var ufile in ups) {
                              if(ufile.isSelectedFile&&ufile.compressFile!=null)
                              {
                                ufile.isSelectedFile=false;
                                //ufile.compressFile!.delete();
                              }
                            }
                            ups.clear();
                            ups.add(UploadPoint(false, null));
                          });
                          if(apiRes.errStr!="")
                          {
                            EasyLoading.showError(apiRes.errStr!);
                          }
                        }
                        else
                        {
                          EasyLoading.showError(apiRes.message);
                        }
                      }
                    } catch (e) {
                      EasyLoading.dismiss();
                      //print("e:" + e.toString() + "   head=" + dio.options.headers.toString());
                      EasyLoading.showError(e.toString());
                    }
                  },
                  style: ButtonStyle(
                    //去除阴影
                    elevation: MaterialStateProperty.all(0),
                    //将按钮背景设置为透明
                    backgroundColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  child: const Text("提交",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center))),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(0),
            margin: const EdgeInsets.only(top: 20,left: 10,right: 10,bottom: 0),
            child:MediaQuery.removePadding(
              removeTop: true, context: context,
              child:ListView.builder(
                  scrollDirection:Axis.vertical,
                  itemCount: messages.length,
                  controller: scrollController,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return  Container(
                      margin: const EdgeInsets.only(top: 0,left: 10,right: 10),
                      padding: const EdgeInsets.all(0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Flex(
                          direction: Axis.horizontal,
                          children: <Widget>[
                            Expanded(
                              flex: 30,
                              child: Container(
                                height: 60.0,
                                padding: const EdgeInsets.only(right: 6,top: 6),
                                child: Text(messages[index].createTime.replaceAll("-", "."),style: const TextStyle(color: Color(0xFF999999), fontSize: 16), textAlign: TextAlign.left),
                              ),
                            ),
                            Expanded(
                              flex: 55,
                              child: Container(
                                height: 60.0,
                                padding: const EdgeInsets.only(left: 0,top: 6),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                  Text("上传者:${messages[index].title}",style: const TextStyle(color: Color(0xFF333333), fontSize: 14)),
                                  Text("备注:${messages[index].msg}",style: const TextStyle(color: Color(0xFF333333), fontSize: 14))
                                ]),
                              ),
                            ),
                            Expanded(
                              flex: 15,
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CommonRouteWrapper(
                                        imageProvider:  NetworkImage(messages[index].imgUrl),
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
                                width: 46,
                                height: 68,
                                padding: const EdgeInsets.only(left: 6,top: 6),
                                child:  const Text("查看",style:  TextStyle(color: Color(0xFF1B7AFF), fontSize: 14))
                              )) ,
                            ),
                          ]
                        )
                      ]),
                    );
                  }
              ) ,
            ),
          ),
        ],
      )),
    );
  }
}
