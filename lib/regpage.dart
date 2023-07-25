
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lanzhong/model/api_response/api_response_entity.dart';
import 'package:lanzhong/request/request_client.dart';
import 'PanPage.dart';
import 'home.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/login_entity.dart';




class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isObscure = true;
  void setObscure() {
    setState(() {
      isObscure = !isObscure;
    });
  }
  bool isAgreed = true;
  TextEditingController textZh = TextEditingController();
  TextEditingController textPwd = TextEditingController();
  TextEditingController textYzm = TextEditingController();
  TextEditingController textNick = TextEditingController();
  late FocusNode zhFocus;
  late FocusNode pwdFocus;
  late FocusNode yzmFocus;
  late FocusNode nickFocus;
  var logger = Logger(printer: PrettyPrinter());
  @override
  void initState() {
    super.initState();
    zhFocus = FocusNode();
    pwdFocus = FocusNode();
    yzmFocus = FocusNode();
    nickFocus = FocusNode();
  }
  static const timeout2 = Duration(seconds: 1);
  late Timer soundTimer; // 定义定时器
  int yindex=60;
  String hqSTR="获取验证码";
  bool isHq=false;//是否获取中
  void startTimer(){
    setState(() {
      isHq=true;
    });// 器
    soundTimer = Timer.periodic(timeout2, (timer) {
      if(yindex>0)
      {
        setState(() {
          yindex--;
          hqSTR="${yindex}s后获取";
        });
      }
      else
      {
        soundTimer.cancel();
        setState(() {
          yindex=60;
          isHq=false;
          hqSTR="获取验证码";
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(child:Column(
          children: <Widget>[
            Container(
              height: 36,
              width: MediaQuery.of(context).size.width,
              alignment:Alignment.centerLeft ,
              margin: const EdgeInsets.only(left: 10, top: 60),
              child: GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                  child: Image.asset("images/arrow_left.png",width: 32,height: 54)),
            ),
            Container(
                height: 32,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(left: 20, top: 20),
                alignment:Alignment.centerLeft ,
                child: const Text('新用户注册',
                    style: TextStyle(color: Color(0xFF333333), fontSize: 24,fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left)
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(width:1, color: Color(0xFFE2E2E2)),
                ),
              ),
              child: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  const Expanded(
                    flex: 2,
                    child: Text("手机号", style: TextStyle(color: Color(0xff333333), fontSize: 16)),
                  ),
                  Expanded(
                    flex: 8,
                    child: TextField(
                      maxLines: 1,
                      controller: textZh,
                      focusNode: zhFocus,
                      textAlign: TextAlign.right,
                      style: const TextStyle(color: Color(0xff333333), fontSize: 16),
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        //内容的内边距
                          contentPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          hintText: '请输入手机号',
                          border: InputBorder.none
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(width:1, color: Color(0xFFE2E2E2)),
                ),
              ),
              child: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  const Expanded(
                    flex: 2,
                    child: Text("验证码", style: TextStyle(color: Color(0xff333333), fontSize: 16)),
                  ),
                  Expanded(
                    flex: 8,
                    child: Container(
                      padding: const EdgeInsets.all(0),
                      margin: const EdgeInsets.all(0),
                      child:Stack(children: [
                        TextField(
                          maxLines: 1,
                          controller: textYzm,
                          focusNode: yzmFocus,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.right,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(6),
                            FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                          ],
                          decoration: const InputDecoration(
                            //内容的内边距
                              contentPadding: EdgeInsets.symmetric(horizontal: 4.0),
                              fillColor: Color.fromRGBO(247, 249, 253, 1),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10))
                              )
                          ),
                        ),
                        Container(
                            height: 36,width:100,
                            padding: const EdgeInsets.all(0),
                            margin:  EdgeInsets.only(left: MediaQuery.of(context).size.width-210,top: 6),
                            child: TextButton(onPressed:()async{
                              if (textZh.text == "") {
                                await showOkAlertDialog(
                                    context: context,
                                    title: '提示',
                                    message: '手机号不能为空！')
                                    .then((value) => {zhFocus.requestFocus()});
                                return;
                              }
                              var matched = RegExp(r"^(13\d|14[01456879]|15[0-35-9]|16[2567]|17[0-8]|18\d|19[0-35-9])\d{8}$").hasMatch(textZh.text);
                              //logger.d("matched=$matched");
                              if(matched==false)
                              {
                                await showOkAlertDialog(
                                    context: context,
                                    title: '提示',
                                    message: '手机格式不正确！')
                                    .then((value) => {zhFocus.requestFocus()});
                                return;
                              }
                              if(isHq==false)
                              {
                                Map<String, dynamic> dic = {
                                  "phone": textZh.text
                                };
                                RequestClient requestClient = RequestClient();
                                String url = "/Staff/GetYzm";
                                Map<String, dynamic>? headers={"Content-type":"application/x-www-form-urlencoded"};
                                await requestClient.post<LoginEntity>(url, data: dic,headers: headers,onError: (e){
                                  EasyLoading.dismiss();
                                  return e.code==0;
                                },onSuccess: (ApiResponse<LoginEntity>? res) async{
                                  await  EasyLoading.dismiss();
                                  await  EasyLoading.showSuccess(res!.message!);
                                  startTimer();
                                });
                              }
                            },
                                child:  Text(hqSTR,
                                    style: TextStyle(color:isHq?
                                    const Color(0xFF9F9F9F):const Color(0xFFFF5201), fontSize: 16)
                                )
                            )
                        )
                      ]),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(width:1, color: Color(0xFFE2E2E2)),
                ),
              ),
              child: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  const Expanded(
                    flex: 2,
                    child: Text("密码", style: TextStyle(color: Color(0xff333333), fontSize: 16)),
                  ),
                  Expanded(
                    flex: 8,
                    child: TextField(
                      maxLines: 1,
                      controller: textPwd,
                      obscureText: isObscure,
                      focusNode: pwdFocus,
                      textAlign: TextAlign.right,
                      style: const TextStyle(color: Color(0xff333333), fontSize: 16),
                      decoration: InputDecoration(
                        //内容的内边距
                          contentPadding:
                          const EdgeInsets.symmetric(horizontal: 4.0),
                          hintText: '请输入密码',
                          filled: true,
                          fillColor: const Color.fromRGBO(247, 249, 253, 1),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                              BorderRadius.all(Radius.circular(10))),
                          suffixIcon: IconButton(
                              onPressed: setObscure,
                              icon: Icon(isObscure
                                  ? Icons.visibility_off
                                  : Icons.visibility))
                      ),

                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(width:1, color: Color(0xFFE2E2E2)),
                ),
              ),
              child: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  const Expanded(
                    flex: 2,
                    child: Text("昵称", style: TextStyle(color: Color(0xff333333), fontSize: 16)),
                  ),
                  Expanded(
                    flex: 8,
                    child: TextField(
                      maxLines: 1,
                      controller: textNick,
                      focusNode: nickFocus,
                      textAlign: TextAlign.right,
                      style: const TextStyle(color: Color(0xff333333), fontSize: 16),
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        //内容的内边距
                          contentPadding:
                          EdgeInsets.symmetric(horizontal: 4.0),
                          hintText: '请输入昵称',
                          border: InputBorder.none
                      ),
                    ),
                  ),
                ],
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
                      if (textYzm.text == "") {
                        await showOkAlertDialog(
                            context: context,
                            title: '提示',
                            message: '验证码不能为空！')
                            .then((value) => {yzmFocus.requestFocus()});
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
                      if (textNick.text == "") {
                        await showOkAlertDialog(
                            context: context,
                            title: '提示',
                            message: '昵称不能为空！')
                            .then((value) => {nickFocus.requestFocus()});
                        return;
                      }
                      Map<String, dynamic> dic = {
                        "UserName": textZh.text,
                        "UserPassword": textPwd.text,
                        "Yzm": textYzm.text,
                        "NickName": textNick.text
                      };
                      await EasyLoading.show(status: '验证中...', maskType: EasyLoadingMaskType.black);
                      RequestClient requestClient = RequestClient();
                      String url = "/Staff/CheckReg";
                      LoginEntity? loginRes = await requestClient.post<LoginEntity>(url, data: dic,onError: (e){
                        EasyLoading.dismiss();
                        return e.code==0;
                      },onSuccess: (ApiResponse<LoginEntity>? res) async{
                        await  EasyLoading.dismiss();
                        if(res!.code==0)
                        {
                          await  EasyLoading.showSuccess(res!.message!);
                          Future.delayed(const Duration(milliseconds: 600), (){
                            if (context.mounted) {
                              Navigator.of(context).pop(textZh.text);
                            }
                          });
                        }
                        else
                        {
                          await  EasyLoading.showError(res.message!);
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
                    child: const Text("立即注册",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center))),
            Row(children: [
              const Spacer(),
              const Text("已经有账号了?",
                  style: TextStyle(color: Color.fromRGBO(153, 153, 153, 1), fontSize: 14),
                  textAlign: TextAlign.center),
              TextButton(
                  onPressed: () {
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text("立即登录", style: TextStyle(color: Color(0xFF333333), fontSize: 14))
              ),
              const Spacer()
            ])
          ],
        ))
    );
  }
}
