import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';

class ImportPage extends StatefulWidget {

  const ImportPage({super.key});
  @override
  State<ImportPage> createState() => _ImportPageState();
}
class _ImportPageState extends State<ImportPage> {
  TextEditingController mbController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: const Color.fromRGBO(247, 249, 253, 1),
        body:SingleChildScrollView(child: Column(
          children: [
            Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(left: 10,top: 20),
                child: Row(children: [
                  IconButton(onPressed: () {
                    Navigator.pop(context);
                  }, icon:  Image.asset("images/arrow_left.png",width: 20,height: 36)),
                  const Spacer(),
                  const Text('快捷导入', style: TextStyle(color: Color(0xFF333333), fontSize: 20,fontWeight: FontWeight.bold), textAlign: TextAlign.left),
                  const Spacer(),    const Spacer(),
                ])
            ),
            Container(
              height: 500,
              width: MediaQuery.of(context).size.width-20,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: const Color(0xFFFFFFFF)
              ),
              padding:  const EdgeInsets.all(6),
              margin:  const EdgeInsets.all(0),
              child:  TextField(
                maxLines: 36,
                controller: mbController,
                decoration: const InputDecoration(
                    hintText: "导入框", border: InputBorder.none),
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width-20,
                height: 46,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  gradient: const LinearGradient(colors: [
                    Color(0xffFFBF3A),
                    Color(0xffFF5100),
                  ]),
                ),
                margin: const EdgeInsets.only(left: 20,right: 20,top: 20),
                padding:const EdgeInsets.only(left: 10,top: 2,bottom: 2,right: 10),
                child: TextButton(onPressed: () async{
                  if(mbController.text.trim()=="")
                  {
                    await showOkAlertDialog(context: context, title: '提示', message: '模板内容不能为空.').then((value) {
                    });
                    return;
                  }
                  Navigator.of(context).pop(mbController.text.trim());
                },
                    child: const Text("读取",style:  TextStyle(color:Colors.white, fontSize: 16), textAlign: TextAlign.center)
                )
            )
          ],
        )
        )
    );
  }
}
