
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'main.dart';


class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}
class _SettingPageState extends State<SettingPage> {

  String? nickName="";
  String? userName="";
  String? versionName="";
  void loadUserData () {
     Future<SharedPreferences> prefs =  SharedPreferences.getInstance();
     prefs.then((fpv){
       setState(() {
         nickName= fpv.getString("nickName");
         userName= fpv.getString("userName");
       });
     });
     Future<PackageInfo> packageInfo =  PackageInfo.fromPlatform();
     packageInfo.then((fpi){
       setState(() {
         versionName = fpi.version;
       });
     });
  }
  @override
  void initState() {
    super.initState();
    loadUserData ();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor:   Colors.white,
        body:Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(left:0,top: 30),
              child: Row(children: [
                  IconButton(onPressed: () {
                    Navigator.pop(context);
                  }, icon:  Image.asset("images/arrow_left.png",width: 20,height: 36)),
                const Spacer(),
                const Text('系统设置', style: TextStyle(color: Color(0xFF333333), fontSize: 20,fontWeight: FontWeight.bold), textAlign: TextAlign.left),
                const Spacer(),    const Spacer(),
              ])
            ),
            Container(
              width: MediaQuery.of(context).size.width-20,
              decoration:  const BoxDecoration(
                color: Colors.white,
                border:  Border(bottom: BorderSide(width: 0.8, color: Colors.black12)),
              ),
              margin: const EdgeInsets.only(left: 10,right: 10,top: 0),
              padding:  const EdgeInsets.only(left: 10,top: 10,bottom: 10,right: 10),
              child: Row(children:  [
                  const Text('头像', style: TextStyle(color: Color(0xFF333333), fontSize: 16), textAlign: TextAlign.left),
                  const Spacer(),
                  Image.asset("images/img_avatar.png",width: 46,height: 46),
              ]
              ),
            ),
            Container(
              decoration:  const BoxDecoration(
                color: Colors.white,
                border:  Border(bottom: BorderSide(width: 0.8, color: Colors.black12)),
              ),
              width: MediaQuery.of(context).size.width-20,
              height: 54,
              margin: const EdgeInsets.only(left: 10,right: 10,top: 1),
              padding:const EdgeInsets.only(left: 10,top: 8,bottom: 8,right: 10),
              child: Row(children:  [
                const Text('用户昵称', style: TextStyle(color: Color(0xFF333333), fontSize: 16), textAlign: TextAlign.left),
                const Spacer(),
                Text(nickName!, style: const TextStyle(color: Color(0xFF999999), fontSize: 16), textAlign: TextAlign.left),
                Image.asset("images/arrow_right.png",width: 8,height: 14)
              ]
              ),
            ),
            Container(
              decoration:  const BoxDecoration(
                color: Colors.white,
                border:  Border(bottom: BorderSide(width: 0.8, color: Colors.black12)),
              ),
              width: MediaQuery.of(context).size.width-20,
              height: 54,
              margin: const EdgeInsets.only(left: 10,right: 10,top: 1),
              padding:const EdgeInsets.only(left: 10,top: 8,bottom: 8,right: 10),
              child: Row(children:  [
                const Text('登录手机', style: TextStyle(color: Color(0xFF333333), fontSize: 16), textAlign: TextAlign.left),
                const Spacer(),
                Text(userName!, style: const TextStyle(color: Color(0xFF999999), fontSize: 16), textAlign: TextAlign.left),
                Image.asset("images/arrow_right.png",width: 8,height: 14)
              ])
            ),
            Container(
              decoration:  const BoxDecoration(
                color: Colors.white,
                border:  Border(bottom: BorderSide(width: 0.8, color: Colors.black12)),
              ),
              width: MediaQuery.of(context).size.width-20,
              height: 54,
              margin: const EdgeInsets.only(left: 10,right: 10,top: 1),
              padding:const EdgeInsets.only(left: 10,top: 8,bottom: 8,right: 10),
              child: Row(children:  [
                const Text('实名认证', style: TextStyle(color: Color(0xFF333333), fontSize: 16), textAlign: TextAlign.left),
                const Spacer(),
                const Text("已实名", style: TextStyle(color: Color(0xFFFF8D57), fontSize: 16), textAlign: TextAlign.left),
                Image.asset("images/arrow_right.png",width: 8,height: 14)
              ]
              ),
            ),
            Container(
              decoration:  const BoxDecoration(
                color: Colors.white,
                border:  Border(bottom: BorderSide(width: 0.8, color: Colors.black12)),
              ),
              width: MediaQuery.of(context).size.width-20,
              height: 54,
              margin: const EdgeInsets.only(left: 10,right: 10,top: 1),
              padding:const EdgeInsets.only(left: 10,top: 8,bottom: 8,right: 10),
              child: Row(children:  [
                const Text('登录密码', style: TextStyle(color: Color(0xFF333333), fontSize: 16), textAlign: TextAlign.left),
                const Spacer(),
                Image.asset("images/arrow_right.png",width: 8,height: 14)
              ]
              ),
            ),
            Container(
                decoration:  const BoxDecoration(
                  color: Colors.white,
                  border:  Border(bottom: BorderSide(width: 0.8, color: Colors.black12)),
                ),
                width: MediaQuery.of(context).size.width-20,
                height: 54,
                margin: const EdgeInsets.only(left: 10,right: 10,top: 1),
                padding:const EdgeInsets.only(left: 10,top: 8,bottom: 8,right: 10),
                child:GestureDetector(
                  onTap: (){
                    launchUrl(Uri.parse('https://appapi.lzsterp.com/protocol.html'));
                  },
                    child: Row(children:  [
                  const Text('用户协议', style: TextStyle(color: Color(0xFF333333), fontSize: 16), textAlign: TextAlign.left),
                  const Spacer(),
                  Image.asset("images/arrow_right.png",width: 8,height: 14)
                ]))
            ),
            Container(
                decoration:  const BoxDecoration(
                  color: Colors.white,
                  border:  Border(bottom: BorderSide(width: 0.8, color: Colors.black12)),
                ),
                width: MediaQuery.of(context).size.width-20,
                height: 54,
                margin: const EdgeInsets.only(left: 10,right: 10,top: 1),
                padding:const EdgeInsets.only(left: 10,top: 8,bottom: 8,right: 10),
                child: GestureDetector(
                  onTap: (){
                    launchUrl(Uri.parse('https://appapi.lzsterp.com/privacy.html'));
                  },
                    child:Row(children:  [
                  const Text('隐私政策', style: TextStyle(color: Color(0xFF333333), fontSize: 16), textAlign: TextAlign.left),
                  const Spacer(),
                  Image.asset("images/arrow_right.png",width: 8,height: 14)
                ]))
            ),
            Container(
              decoration:  const BoxDecoration(
                color: Colors.white,
                border:  Border(bottom: BorderSide(width: 0.8, color: Colors.black12)),
              ),
              width: MediaQuery.of(context).size.width-20,
              height: 54,
              margin: const EdgeInsets.only(left: 10,right: 10,top: 1),
              padding:const EdgeInsets.only(left: 10,top: 8,bottom: 8,right: 10),
              child: Row(children:  [
                const Text('版本号', style: TextStyle(color: Color(0xFF333333), fontSize: 16), textAlign: TextAlign.left),
                const Spacer(),
                Text("V${versionName!}", style: const TextStyle(color: Color(0xFFFF8D57), fontSize: 16), textAlign: TextAlign.left),
                Image.asset("images/arrow_right.png",width: 8,height: 14)
              ]
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width-20,
              height: 46,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFFF4F6F9)
                ),
              margin: const EdgeInsets.only(left: 20,right: 20,top: 60),
              padding:const EdgeInsets.only(left: 10,top: 2,bottom: 2,right: 10),
              child: TextButton(onPressed: () async{
                   final SharedPreferences btnPrefs =await  SharedPreferences.getInstance();
                   await btnPrefs.remove("token");
                   await btnPrefs.remove("userName");
                   await btnPrefs.remove("userPwd");
                   await btnPrefs.remove("yhid");
                   await btnPrefs.remove("Pid");
                   if(context.mounted)
                   {
                     Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => const Launch()), (route) => false);
                   }
                  },
                  child: const Text("退出登录",style:  TextStyle(color:Color(0xFF999999), fontSize: 16), textAlign: TextAlign.center)
                    )
            )
          ],
        )
    );
  }
}
