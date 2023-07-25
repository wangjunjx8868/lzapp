
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lanzhong/request/request_client.dart';


class InvokePage extends StatefulWidget {
  final int aqbzj;
  final int xlbzj;
  final String tbid;
  final String dlzt;
  final String ptName;
  const InvokePage({Key? key,required this.aqbzj, required this.xlbzj, required this.tbid, required this.dlzt, required this.ptName }) : super(key: key);
  @override
  State<InvokePage> createState() => _InvokePageState();
}
class _InvokePageState extends State<InvokePage> {
  TextEditingController dlfController =TextEditingController(text: "0");
  TextEditingController pcjController =TextEditingController(text: "0");
  TextEditingController cxlyController =TextEditingController();
  String dlf="0";//代练费
  @override
  void initState() {
    super.initState();
    dlfController.addListener((){
       setState(() {
         dlf=dlfController.text;
       });
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: const Color.fromRGBO(247, 249, 253, 1),
        body:SingleChildScrollView(child:Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height:36,
              margin: const EdgeInsets.only(left: 10,top: 46),
              child: Row(children: [
                IconButton(onPressed: () {
                  Navigator.pop(context,"0");
                }, icon:  Image.asset("images/arrow_left.png",width: 32,height: 54)),
                const Text('申请撤销订单', style: TextStyle(color: Color(0xFF333333), fontSize: 18), textAlign: TextAlign.left)
              ]
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width-40,
              height: 40,
              padding: const EdgeInsets.only(left: 10,top: 10),
              margin: const EdgeInsets.only(left: 20,top: 10,right: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                border:  Border(bottom: BorderSide(width: 1, color: Color(0xfff7f9fd))),
              ),
              child:const Text('我的收入', style: TextStyle(color: Color(0xFF333333), fontSize: 16), textAlign: TextAlign.left),
            ),
            Container(
              width: MediaQuery.of(context).size.width-40,
              height: 60,
              padding: const EdgeInsets.only(left: 10,top: 3),
              margin: const EdgeInsets.only(left: 20,top: 0,right: 20),
              decoration: const BoxDecoration(
                color: Colors.white,  border:  Border(bottom: BorderSide(width: 1, color: Color(0xfff7f9fd))),
              ),
              child:Row(children:   [
                const Text('需要对方赔付的保证金（元）', style: TextStyle(color: Color(0xFF333333), fontSize: 14), textAlign: TextAlign.left),
                const Spacer(),
                Container(width: 100,
                  height: 36,
                  margin:  const EdgeInsets.only(right: 10),
                  child:  TextField(
                    maxLines: 1,
                    controller: pcjController,
                    textAlign: TextAlign.right,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(fontSize: 14),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(6),
                      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                    ],
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 6.0,vertical: 1),
                        hintText: '请输入金额',
                        filled: true,
                        fillColor: Color(0xfff7f9fd),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(6))
                        )
                    ),
                  ),
                )
              ],),
            ),
            Container(
              width: MediaQuery.of(context).size.width-40,
              height: 36,
              padding: const EdgeInsets.only(left: 10,top: 0),
              margin: const EdgeInsets.only(left: 20,top: 0,right: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child:Row(
                children:  [
                  Text('对方冻结安全保证金¥${widget.aqbzj}', style: const TextStyle(color: Color(0xFF999999), fontSize: 12), textAlign: TextAlign.left),
                  const Spacer(),
                  const Spacer(),
                  Text('对方冻结效率保证金¥${widget.xlbzj}', style: const TextStyle(color: Color(0xFF999999), fontSize: 12), textAlign: TextAlign.left),
                  const Spacer()
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width-40,
              height: 36,
              padding: const EdgeInsets.only(left: 10,top: 6),
              margin: const EdgeInsets.only(left: 20,top: 10,right: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                border:  Border(bottom: BorderSide(width: 1, color: Color(0xfff7f9fd))),
              ),
              child:const Text('我的支出', style: TextStyle(color: Color(0xFF333333), fontSize: 16), textAlign: TextAlign.left),
            ),
            Container(
              width: MediaQuery.of(context).size.width-40,
              height: 60,
              padding: const EdgeInsets.only(left: 10,top: 3),
              margin: const EdgeInsets.only(left: 20,top: 0,right: 20),
              decoration: const BoxDecoration(
                color: Colors.white,  border:  Border(bottom: BorderSide(width: 1, color: Color(0xfff7f9fd))),
              ),
              child:Row(children:   [
                const Text('我愿意支付代练费 (元)', style: TextStyle(color: Color(0xFF333333), fontSize: 14), textAlign: TextAlign.left),
                const Spacer(),
                Container(width: 100,
                  height: 36,
                  margin:  const EdgeInsets.only(right: 10),
                  child:  TextField(
                    maxLines: 1,
                    controller: dlfController,
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.right,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(6),
                      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                    ],
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 6.0,vertical: 1),
                        hintText: '请输入金额',
                        filled: true,
                        fillColor: Color(0xfff7f9fd),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(6))
                        )
                    ),
                  ),
                )
              ]),
            ),
            Container(
              width: MediaQuery.of(context).size.width-40,
              height: 36,
              padding: const EdgeInsets.only(left: 10,top: 0),
              margin: const EdgeInsets.only(left: 20,top: 0,right: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child:Row(
                children:   [
                  Text('我已预付的代练费¥$dlf', style: const TextStyle(color: Color(0xFFFF8D56), fontSize: 12), textAlign: TextAlign.left),
                  const Spacer(),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width-40,
              height: 36,
              padding: const EdgeInsets.only(left: 10,top: 6,bottom: 6),
              margin: const EdgeInsets.only(left: 20,top: 10,right: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                border:  Border(bottom: BorderSide(width: 1, color: Color(0xfff7f9fd))),
              ),
              child:const Text('撤销原因', style: TextStyle(color: Color(0xFF333333), fontSize: 16), textAlign: TextAlign.left),
            ),
            Container(
                width: MediaQuery.of(context).size.width-40,
                height: 136,
                padding: const EdgeInsets.only(left: 10,top: 3,right: 10),
                margin: const EdgeInsets.only(left: 20,top: 0,right: 20),
                decoration: const BoxDecoration(
                  color: Colors.white,  border:  Border(bottom: BorderSide(width: 1, color: Color(0xfff7f9fd))),
                ),
                child: TextField(
                  maxLines: 6,
                  controller: cxlyController,
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.left,
                  keyboardType: TextInputType.text,
                  maxLength: 100,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 6.0,vertical: 3),
                      hintText: '请输入撤销原因',
                      filled: true,
                      fillColor: Color(0xfff7f9fd),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(6))
                      )
                  ),
                )
            ),
            Container(
              width: MediaQuery.of(context).size.width-40,
              height: 46,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                gradient: const LinearGradient(colors: [
                  Color(0xffFFBF3A),
                  Color(0xffFF5100),
                ]),
              ),
              padding: const EdgeInsets.only(left: 0,top: 0),
              margin: const EdgeInsets.only(left: 20,top: 10,right: 20),
              child:ElevatedButton(
                  onPressed: () async  {
                    if (pcjController.text == "") {
                      await showOkAlertDialog(
                      context: context,
                      title: '提示',
                      message: '赔偿金不能为空！');
                      return;
                    }
                    if (dlfController.text == "") {
                      await showOkAlertDialog(
                          context: context,
                          title: '提示',
                          message: '代理费不能为空！');
                      return;
                    }
                    Map<String, dynamic>? formData = {
                      "id": widget.tbid,
                      "ptzt": widget.dlzt,
                      "ptName": widget.ptName,
                      "dlf": dlfController.text,
                      "pcj":pcjController.text,
                      "cxly": cxlyController.text,
                    };
                    await EasyLoading.show(status: '验证中...', maskType: EasyLoadingMaskType.black);
                    String url="/Order/ApplyRevoke";
                    Map<String, dynamic>? headers={"Content-type":"application/x-www-form-urlencoded"};
                    RequestClient requestClient = RequestClient();
                    await requestClient.post(url,data: formData,headers: headers,onError: (e){
                      EasyLoading.showError(e.message!);
                      return e.code==0;
                    },onSuccess: (res)async{
                      if(res.code==0)
                      {
                        EasyLoading.showSuccess("操作成功！");
                        if(context.mounted)
                        {
                          Navigator.pop(context,"1");
                        }
                      }
                      else
                      {
                        EasyLoading.showError(res.message!);
                      }
                    });
                    await  EasyLoading.dismiss();
                  },
                style: ButtonStyle(
                  //去除阴影
                  elevation: MaterialStateProperty.all(0),
                  //将按钮背景设置为透明
                  backgroundColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  child: const Text("立即提交",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center)),
            ),
          ],
        ))
    );
  }
}
