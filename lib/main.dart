import 'dart:ui';
import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lanzhong/model/api_response/api_response_entity.dart';
import 'package:lanzhong/regpage.dart';
import 'package:lanzhong/request/request_client.dart';
import 'PanPage.dart';
import 'home.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'model/login_entity.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Launch());
}


class Launch extends StatelessWidget {
  const Launch({super.key});
  static const MaterialColor redYellow = MaterialColor(
    _bluePrimaryValue,
    <int, Color>{
      50: Color(0xFFE3F2FD),
      100: Color(0xFFFFBC39),
      200: Color(0xFFFFB837),
      300: Color(0xFFBF7A21),
      400: Color(0xFFBD6B19),
      500: Color(0xFFFF891D),
      600: Color(0xFFF87313),
      700: Color(0xFFFF6A0D),
      800: Color(0xFFFF5C06),
      900: Color(0xFFFF5100),
    },
  );
  static const int _bluePrimaryValue = 0xFFFF891D;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '代练',
      theme: ThemeData(
        // This is the theme of your application.
        //fontFamily: "PingFang_Regular",
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: redYellow,
      ),
      home: const LaunchPage(),
      builder: EasyLoading.init(),
    );
  }
}

class LaunchPage extends StatefulWidget {
  const LaunchPage({super.key});

  @override
  State<LaunchPage> createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  bool isObscure = true;
  void setObscure() {
    setState(() {
      isObscure = !isObscure;
    });
  }
  final TapGestureRecognizer _tgr1 =  TapGestureRecognizer();
  final TapGestureRecognizer _tgr2 =  TapGestureRecognizer();
  bool isAgreed = true;
  TextEditingController textZh = TextEditingController();
  TextEditingController textPwd = TextEditingController();
  late FocusNode zhFocus;
  late FocusNode pwdFocus;
  String agreeProtocol="";
  late BuildContext dialogContext;
  var logger = Logger(printer: PrettyPrinter());
  @override
  void initState() {
    super.initState();
    zhFocus = FocusNode();
    pwdFocus = FocusNode();

    Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    prefs.then((fcv) {
      String? userName = fcv.getString("userName");
      String? userPwd = fcv.getString("userPwd");
      if (userName != null && userName.isNotEmpty) {
        textZh.text = userName;
      }
      if (userPwd != null && userPwd.isNotEmpty) {
        textPwd.text = userPwd;
      }
      String? _agreeProtocol = fcv.getString("agreeProtocol");
      if(_agreeProtocol!=null&&_agreeProtocol.isNotEmpty)
      {
        agreeProtocol=_agreeProtocol;
      }
      if(agreeProtocol.isEmpty)
      {
        if(context.mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext  ctx) {
              dialogContext=ctx;
              return WillPopScope(
                  onWillPop: () async => false,
                  child:StatefulBuilder(builder: (BuildContext context, void Function(void Function()) setState) {
                    return Dialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
                        child: Container(
                          width: 280,
                          height: 360,
                          padding: const EdgeInsets.all(0),
                          margin: const EdgeInsets.all(0),
                          child: Column(children: [
                            Container(
                              height: 28,
                              width: MediaQuery.of(ctx).size.width,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.only(left: 20),
                              margin: const EdgeInsets.only(top:10),
                              child:  const Text("服务协议和隐私政策",style:  TextStyle(color:Color(0xFF333333),fontWeight: FontWeight.bold,fontSize: 18)),
                            ),
                            Container(
                              width: MediaQuery.of(ctx).size.width,
                              alignment: Alignment.topLeft,
                              padding: const EdgeInsets.only(left: 10,right: 10),
                              margin: const EdgeInsets.only(top:10),
                              child: RichText(text:
                               TextSpan(children:[
                                  const TextSpan(text: "感谢你使用揽众生态应用，请仔细阅读", style: TextStyle(color: Color(0xFF333333))),
                                  TextSpan(text: "《服务协议》", style: const TextStyle(color: Colors.blueAccent),recognizer: _tgr1..onTap=(){
                                    launchUrl(Uri.parse('https://appapi.lzsterp.com/protocol.html'));
                                  }),
                                  const TextSpan(text: "和", style: TextStyle(color: Color(0xFF333333))),
                                   TextSpan(text: "《隐私政策》", style: const TextStyle(color: Colors.blueAccent),recognizer: _tgr2..onTap=(){
                                     launchUrl(Uri.parse('https://appapi.lzsterp.com/privacy.html'));
                                  }),
                                  const TextSpan(text: "并充分了解一下信息/权限申请情况:", style: TextStyle(color: Color(0xFF333333))),
                              ])
                              ),
                            ),
                            Container(
                              height: 136,
                              width: MediaQuery.of(ctx).size.width,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.only(left: 10),
                              margin: const EdgeInsets.only(top:10),
                              child:  const Text("1:为了向你提交、服务等相关功能，我们会收集、使用你的必要信息\n2:摄像头、相册等敏感权限均不会默认开启，只有经过你的明确授权的前提下我们次啊会实现某项功能或服务\n3:未经你的同意，我们不会从第三方获取、共享或者对外提供你的个人信息",style:  TextStyle(color:Color(0xFF333333),fontSize: 14)),
                            ),
                            Container(
                              width: MediaQuery.of(ctx).size.width,
                              alignment: Alignment.center,
                              height: 36,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9),
                                gradient: const LinearGradient(colors: [
                                  Color(0xffFFBF3A),
                                  Color(0xffFF5100),
                                ]),
                              ),
                              padding: const EdgeInsets.only(left: 0),
                              margin: const EdgeInsets.only(top:10,left: 10,right: 10),
                              child: ElevatedButton(
                                  onPressed: () async {
                                    final SharedPreferences prefs = await SharedPreferences.getInstance();
                                    await prefs.setString('agreeProtocol',"1");
                                    if(context.mounted)
                                    {
                                      Navigator.pop(dialogContext);
                                    }
                                  },
                                  style: ButtonStyle(
                                    //去除阴影
                                    elevation: MaterialStateProperty.all(0),
                                    //将按钮背景设置为透明
                                    backgroundColor: MaterialStateProperty.all(Colors.transparent),
                                  ),
                                  child: const Text("同意", style: TextStyle(color: Colors.white, fontSize: 12.8),
                                      textAlign: TextAlign.center)),
                            ),
                            Container(
                              width: MediaQuery.of(ctx).size.width,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(0),
                              margin: const EdgeInsets.only(top:20),
                              child: GestureDetector(
                                onTap: (){
                                  if(Platform.isIOS){
                                    exit(0);
                                  }else if(Platform.isAndroid){
                                    SystemNavigator.pop();
                                  }
                                },
                                  child:const Text("不同意退出",style:  TextStyle(color:Color(0xFF999999),fontSize: 13)))
                            )
                          ]),
                        )
                    );
                  })
              );
            },
          );
          // Future<OkCancelResult> futureResult = showOkCancelAlertDialog(
          //   context: context,
          //   title: '检查更新',
          //   message: '发现新版本，现在要立即更新吗？',
          //   defaultType: OkCancelAlertDefaultType.cancel,
          // );
          // futureResult.then((value) async{
          //   if(value==OkCancelResult.ok)
          //   {
          //     downloadId = await RUpgrade.upgrade(
          //         'https://appapi.lzsterp.com/app-release.apk',
          //         fileName: 'app-release.apk',
          //         installType: installType,
          //         notificationStyle: notificationStyle,
          //         notificationVisibility: notificationVisibility,
          //         useDownloadManager: true);
          //     upgradeMethod = UpgradeMethod.all;
          //   }
          // });
        }
      }
      //Navigator.of(context).pushAndRemoveUntil( PanPageRouteBuilder(builder:  (context) => const MyApp(),transitionDuration: const Duration(milliseconds: 300),popDirection: AxisDirection.left), (route) => false);
      //Navigator.push(context, MaterialPageRoute(builder: (context) => const MyApp()));
    })
    .whenComplete(() {
      if( textZh.text!=""&& textPwd.text!=""&&agreeProtocol!="")
      {
        RequestClient requestClient = RequestClient();
        String url="/Staff/CheckLogin";
        Map<String,dynamic> dic={"UserName":textZh.text,"UserPassword":textPwd.text};
        requestClient.post<LoginEntity>(url,data: dic,showLoading: false,onSuccess: (ApiResponse<LoginEntity>? res)async{
          if(res!.code==0)
          {
            final SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('token', res.data!.accessToken);
            await prefs.setString('userName', textZh.text);
            await prefs.setString('userPwd', textPwd.text);
            await prefs.setString('yhid',  res!.data!.yhid.toString());
            await prefs.setString('Pid',  res!.data!.pid.toString());
            if (context.mounted)
            {
              Navigator.of(context).pushAndRemoveUntil(PanPageRouteBuilder(builder: (context) => const MyApp(), transitionDuration: const Duration(milliseconds: 300),
                  popDirection: AxisDirection.left), (route) => false);
            }
          }
          else
          {
            await  EasyLoading.showError(res!.message!);
          }
        });
        // fle.then((flv) {
        //   if (flv!=null&&context.mounted)
        //   {
        //     Navigator.of(context).pushAndRemoveUntil( PanPageRouteBuilder(builder:  (context) => const MyApp(),transitionDuration: const Duration(milliseconds: 300),popDirection: AxisDirection.left), (route) => false);
        //   }
        // });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(child:Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment:Alignment.centerLeft ,
                height: 32,
                margin: const EdgeInsets.only(left: 20, top: 120),
                width: MediaQuery.of(context).size.width,
                child:  SizedBox(
                  width: 106,height:26 ,
                    child:Image.asset("images/logo_login.png")
                )
            ),
            Container(
                height: 32,
                margin: const EdgeInsets.only(left: 20, top: 10),
                width: MediaQuery.of(context).size.width,
                alignment:Alignment.centerLeft ,
                child: const Text('登录后，体验专业服务',
                    style: TextStyle(color: Color(0xFF333333), fontSize: 22,fontWeight:FontWeight.bold ),
                    textAlign: TextAlign.left)
            ),
            Container(
                height: 32,
                alignment:Alignment.centerLeft ,
                margin: const EdgeInsets.only(left: 20, top: 10),
                width: MediaQuery.of(context).size.width,
                child: const Text('最专业的的订单管理系统',
                    style: TextStyle(color: Color(0xFF666666), fontSize: 14 ),
                    textAlign: TextAlign.left)
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
              height: 46,
              child: TextField(
                maxLines: 1,
                controller: textZh,
                focusNode: zhFocus,
                style: const TextStyle(fontSize: 16),
                decoration: const InputDecoration(
                  //内容的内边距
                    contentPadding: EdgeInsets.only(top: 10),
                    hintText: '请输入账号',
                    prefixIcon:Padding(
                        padding: EdgeInsets.all(12),
                        child:Image(height:14,width: 16,image: AssetImage('images/prefix_phone.png')),
                    ),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFE9E9E9),width: 1)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFE9E9E9),width: 1)),

                ),
              ),
            ),
            Container(
              height: 46,
              margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: TextField(
                maxLines: 1,
                controller: textPwd,
                obscureText: isObscure,
                focusNode: pwdFocus,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  //内容的内边距
                    contentPadding: const EdgeInsets.only(top: 10),
                    hintText: '请输入密码',
                    prefixIcon:const Padding(
                      padding: EdgeInsets.all(12),
                      child:Image(height:14,width: 16,image: AssetImage('images/prefix_password.png')),
                    ),
                    enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFE9E9E9),width: 1)),
                    focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFE9E9E9),width: 1)),

                      suffixIcon: IconButton(
                        onPressed: setObscure,
                        icon: Image(
                            image: AssetImage(isObscure ? 'images/safe_off.png' : 'images/safe_open.png'),
                            width: 18,
                            height: isObscure ?18:14)
                      )
                ),
              ),
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
                margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: ElevatedButton(
                    onPressed: () async {
                      if (textZh.text == "") {
                        await showOkAlertDialog(
                            context: context,
                            title: '提示',
                            message: '账号不能为空！')
                            .then((value) => {zhFocus.requestFocus()});
                        return;
                      }
                      if (textPwd.text == "") {
                        await showOkAlertDialog(
                            context: context,
                            title: '提示',
                            message: '密码不能为空！')
                            .then((value) => {pwdFocus.requestFocus()});
                        return;
                      }
                      Map<String, dynamic> dic = {
                        "UserName": textZh.text,
                        "UserPassword": textPwd.text
                      };
                      await EasyLoading.show(status: '验证中...', maskType: EasyLoadingMaskType.black);
                      RequestClient requestClient = RequestClient();
                      String url = "/Staff/CheckLogin";
                     await requestClient.post<LoginEntity>(url, data: dic,onError: (e){
                        EasyLoading.dismiss();
                        return e.code==0;
                      },onSuccess: (ApiResponse<LoginEntity>? res) async{
                        await  EasyLoading.dismiss();
                        //await  EasyLoading.showSuccess(res!.message!);
                        if(res!.code==0)
                        {
                          final SharedPreferences prefs = await SharedPreferences.getInstance();
                          await prefs.setString('token', res.data!.accessToken);
                          await prefs.setString('userName', textZh.text);
                          await prefs.setString('userPwd', textPwd.text);
                          await prefs.setString('yhid',  res!.data!.yhid.toString());
                          await prefs.setString('Pid',  res!.data!.pid.toString());
                          if (context.mounted)
                          {
                            Navigator.of(context).pushAndRemoveUntil(PanPageRouteBuilder(builder: (context) => const MyApp(), transitionDuration: const Duration(milliseconds: 300),
                                popDirection: AxisDirection.left), (route) => false);
                          }
                        }
                        else
                        {
                          await  EasyLoading.showError(res!.message!);
                        }
                      });
                      // Navigator.of(context).pushAndRemoveUntil( PanPageRouteBuilder(builder: (context) => const MyApp(),transitionDuration: const Duration(milliseconds: 300),popDirection: AxisDirection.left), (route) => false);
                    },
                    style: ButtonStyle(
                      //去除阴影
                      elevation: MaterialStateProperty.all(0),
                      //将按钮背景设置为透明
                      backgroundColor: MaterialStateProperty.all(Colors.transparent),
                    ),
                    child: const Text("立即登录",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center)
                )
            ),
            Container(
                margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: TextButton(onPressed:()async{
                  final result=await Navigator.push(context, PanPageRouteBuilder(builder: (context) {return  const RegisterPage(title: '注册');}, transitionDuration: const Duration(milliseconds: 300),
                      popDirection: AxisDirection.left));
                  if(result!=null)
                  {
                    setState(() {
                      textZh.text=result.toString();
                    });
                  }
                }, child: const Text("用户注册" ,style: TextStyle(color: Color(0xFF999999), fontSize: 14))),
            )
          ],
        ))
    );
  }
}
