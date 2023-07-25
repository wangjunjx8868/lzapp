import 'package:flutter/material.dart';

class UpdateDialog2 extends Dialog {
  final String upDateContent;
  final bool isForce;

  const UpdateDialog2({super.key, required this.upDateContent, required this.isForce});

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child:Container(
      width: 260,
      color: Colors.white,
      height: 360,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset("images/img_update.png"),
          Text(upDateContent,
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  decoration: TextDecoration.none)),
          Container(
            width: 200,
            height: 32,
            margin: const EdgeInsets.only(bottom: 12),
            child: TextButton(
                child: const Text(
                  '立即更新',
                  style:
                  TextStyle(fontSize: 20, color: Colors.white),
                ),
                onPressed: () {

                }),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Offstage(
              offstage: isForce,
              child: Container(
                  margin: const EdgeInsets.only(top: 30),
                  child:const Text("忽略")
              ),
            ),
          )
        ],
      ),
    ));
  }
}