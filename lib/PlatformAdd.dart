import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lanzhong/request/request_client.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:logger/logger.dart';

import 'model/fhpt.dart';
import 'model/person_entity.dart';
class PlatformAdd extends StatefulWidget {
  const PlatformAdd({super.key});

  @override
  State<PlatformAdd> createState() => _PlatformAddPageState();
}

class _PlatformAddPageState extends State<PlatformAdd> {
  final List<String> platItems = ['代练通', '代练妈', '趣代练','易代练','代练丸子','咕噜373','代练多','代练宝','私有平台'];
  final List<String> sendItems = ['否', '是'];
  String? selectedPlatValue="代练通";
  String? selectedSendValue="否";
  TextEditingController platformAccount = TextEditingController();
  TextEditingController platformNick = TextEditingController();
  TextEditingController payPwdController = TextEditingController();
  late FocusNode accountFocus;
  late FocusNode nickFocus;
  late FocusNode pwdFocus;
  String ptName="";
  String ptAccount="";
  String ptNick="";
  String payPwd="";
  var logger = Logger(printer: PrettyPrinter());

  @override
  void initState() {
    super.initState();
    accountFocus = FocusNode();
    nickFocus = FocusNode();
    pwdFocus = FocusNode();
  }
  Widget wpt(){
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        alignment:AlignmentDirectional.centerEnd ,
        isExpanded: true,
        hint: SizedBox(
          width: 120,
            child:Text(selectedPlatValue!,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize:16,  color: Theme.of(context).hintColor,
            ),
          )
        ) ,
        items: platItems.map((item) => DropdownMenuItem<String>(value: item,
            child: SizedBox(width: 120,child: Text(item,  textAlign: TextAlign.right)))
        ).toList(),
        onChanged: (value) {
          setState(() {
            selectedPlatValue = value as String;
          });
        },
        buttonStyleData: const ButtonStyleData(
            height: 32,
            width: 120,
            padding: EdgeInsets.only(left: 0, right:0)
        ),
        iconStyleData: const IconStyleData(
          iconSize: 32,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 300,
          width: 120,
          elevation: 8,
          offset: const Offset(160, 0),
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
  Widget wSend(){
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        alignment:AlignmentDirectional.centerEnd ,
        isExpanded: true,
        hint: SizedBox(
            width: 120,
            child:Text(
              selectedSendValue!,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 16,  color: Theme.of(context).hintColor,
              ),
            )
        ) ,
        items: sendItems.map((item) => DropdownMenuItem<String>(value: item,
            child: SizedBox(width: 120,child: Text(item,  textAlign: TextAlign.right)))
        ).toList(),
        onChanged: (value) {
          setState(() {
            selectedSendValue = value as String;
          });
        },
        buttonStyleData: const ButtonStyleData(
            height: 28,
            width: 120,
            padding: EdgeInsets.only(left: 0, right:0)
        ),
        iconStyleData: const IconStyleData(
          iconSize: 28,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 300,
          width: 120,
          elevation: 8,
          offset: const Offset(160, 0),
          scrollbarTheme: ScrollbarThemeData(
            thickness: MaterialStateProperty.all<double>(2),
            thumbVisibility: MaterialStateProperty.all<bool>(true),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 28,
          padding: EdgeInsets.only(left: 14, right: 14),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(body:Container(
        alignment: Alignment.topCenter,
        decoration: const BoxDecoration(
          color: Color(0xFFFFffff),
        ),
        width: MediaQuery.of(context).size.width,
        child: Column(children: [
          Row(children: [
            Container(
              width: 26,
              height: 45,
              padding: const EdgeInsets.all(0),
              margin: const  EdgeInsets.only(left: 20,top:36),
              child:GestureDetector(
                onTap: (){
                  Navigator.of(context).pop(null);
                },
                  child: Image.asset("images/arrow_left.png",width: 21,height: 36))
            ),
            const Spacer(),
            Container(
              width: 120,
              height: 32,
              margin: const  EdgeInsets.only(left: 50,top:36),
              child: const Text("添加平台",style: TextStyle(color: Color(0xFF333333),fontWeight: FontWeight.bold, fontSize: 20)),
            ),
            const Spacer(),const Spacer(),
          ]),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 15, right: 2, top: 10),
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
                  flex: 22,
                  child: Text("平台名称",
                      style:
                      TextStyle(color: Color(0xff333333), fontSize: 16)),
                ),
                Expanded(
                    flex: 76,
                    child: wpt()
                )
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 15, right: 2, top: 0),
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
                  child: Text("平台账号",
                      style:
                      TextStyle(color: Color(0xff333333), fontSize: 16)),
                ),
                Expanded(
                    flex: 76,
                    child:  TextField(
                      controller: platformAccount,
                      focusNode: accountFocus,
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontSize: 16),
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        //内容的内边距
                          contentPadding: EdgeInsets.only(right: 10),
                          hintText: '请输入账号',
                          border:InputBorder.none
                      ),
                    )
                )
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 15, right: 2, top: 0),
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
                  child: Text("平台昵称",
                      style:
                      TextStyle(color: Color(0xff333333), fontSize: 16)),
                ),
                Expanded(
                    flex: 76,
                    child:  TextField(
                        controller: platformNick,
                        focusNode: nickFocus,
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontSize: 16),
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          //内容的内边距
                            contentPadding: EdgeInsets.only(right: 10),
                            hintText: '请输入昵称',
                            border:InputBorder.none
                        )
                    )
                )
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 15, right: 2, top: 0),
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
                  child: Text("支付密码",
                      style:
                      TextStyle(color: Color(0xff333333), fontSize: 16)),
                ),
                Expanded(
                    flex: 76,
                    child:  TextField(
                        controller: payPwdController,
                        focusNode: pwdFocus,
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontSize: 16),
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          //内容的内边距
                            contentPadding: EdgeInsets.only(right: 10),
                            hintText: '请输入支付密码',
                            border:InputBorder.none
                        )
                    )
                )
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 15, right: 2, top: 10),
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
                  flex: 22,
                  child: Text("平台名称",
                      style:
                      TextStyle(color: Color(0xff333333), fontSize: 16)),
                ),
                Expanded(
                    flex: 76,
                    child: wSend()
                )
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
                    if(platformAccount.text=="")
                    {
                      await showOkAlertDialog(
                          context: context,
                          title: '提示',
                          message: '平台账号不能为空');
                      return;
                    }
                    if(platformNick.text=="")
                    {
                      await showOkAlertDialog(
                          context: context,
                          title: '提示',
                          message: '平台昵称不能为空');
                      return;
                    }
                    if(payPwdController.text=="")
                    {
                      await showOkAlertDialog(
                          context: context,
                          title: '提示',
                          message: '支付密码不能为空');
                      return;
                    }
                    Map<String, dynamic>? formData = {
                      "PlatformName": selectedPlatValue,
                      "PlatformAccount": platformAccount.text,
                      "PlatformNick": platformNick.text,
                      "PayPwd": payPwdController.text,
                      "IsSend":selectedSendValue,
                    };
                    await EasyLoading.show(status: '验证中...', maskType: EasyLoadingMaskType.black);
                    String url="/Personal/AddPlat";
                    RequestClient requestClient = RequestClient();
                    await requestClient.post<PersonPlats>(url,data: formData,onError: (e){
                      return e.code==0;
                    },onSuccess: (res)async{
                      if(res.code==0)
                      {
                        if (context.mounted) {
                          Navigator.of(context).pop(res.data);
                        }
                      }
                      else
                      {
                        await  EasyLoading.showError(res.message!);
                      }
                    }).whenComplete(()  {
                      EasyLoading.dismiss();
                    });

                    // Navigator.of(context).pushAndRemoveUntil( PanPageRouteBuilder(builder: (context) => const MyApp(),transitionDuration: const Duration(milliseconds: 300),popDirection: AxisDirection.left), (route) => false);
                  },
                  style: ButtonStyle(
                    //去除阴影
                    elevation: MaterialStateProperty.all(0),
                    //将按钮背景设置为透明
                    backgroundColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  child: const Text("保存",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center)
              )
          ),
        ])
    ) );
  }
}
