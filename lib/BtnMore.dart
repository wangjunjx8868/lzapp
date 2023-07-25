
import 'package:flutter/material.dart';

class BtnMore extends StatefulWidget {
  final List<String> ztItems;
  final int selectedIndex;
  const BtnMore({super.key,required this.ztItems, required this.selectedIndex});
  @override
  State<BtnMore> createState() => _BtnMorePageState();
}
class _BtnMorePageState extends State<BtnMore> {
  int btnIndex=0;
  @override
  void initState() {
    super.initState();
    btnIndex=widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 3,
            mainAxisSpacing:10
        ),
        itemCount: widget.ztItems.length,
        padding: const EdgeInsets.only(top: 15,bottom: 15,right: 20),
        shrinkWrap:true,
        physics:const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            width:64,height: 32,
            decoration: BoxDecoration(
              border:btnIndex == index?null:Border.all(color: const Color(0xFFD0D0D0),width: 0.8),
              borderRadius: BorderRadius.circular(2),
              gradient:btnIndex == index? const LinearGradient(colors: [Color(0xffFFBF3A), Color(0xffFF5100)]):null,
            ),
            padding: const EdgeInsets.only(left:0),
            margin: const EdgeInsets.only(left:10),
            child:  TextButton (
              onPressed: (){
                setState(() {
                  btnIndex=index;
                });
                Navigator.of(context).pop(index);
              },
              style: ButtonStyle(
                //去除阴影
                elevation: MaterialStateProperty.all(0),
                //将按钮背景设置为透明
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
              ),
              child: Text(widget.ztItems[index],style:  TextStyle(color: btnIndex == index?const Color(0xFFFFFFFF):const Color(0xFF999999))),
            ),
          );
        });
  }
}
