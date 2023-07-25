import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//用来显示底部弹出 可滚动视图的
class ShowCupertinoDialog extends StatefulWidget {
  //内容
  List<String> items;
  //选中回调 (int,String) 对应的下标和对应的值
  Function onTap;

  ShowCupertinoDialog({super.key,
    required this.items,
    required this.onTap,
  });
  @override
  _ShowCupertinoDialogState createState() => _ShowCupertinoDialogState();
}

class _ShowCupertinoDialogState extends State<ShowCupertinoDialog> {

  int selectIndex=0;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      color:Colors.white,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              TextButton(
                child: const Text('取消'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('确定'),
                onPressed: () {
                  Navigator.pop(context);
                  if(widget.items.isNotEmpty){
                    selectIndex = 0;
                  }
                  widget.onTap(selectIndex, widget.items[selectIndex]);
                },
              ),
            ],
          ),
          Expanded(
            child: CupertinoPicker(
              backgroundColor:  Colors.white,
              onSelectedItemChanged: (index) {
                selectIndex = index;
              },
              itemExtent: 36,
              children: widget.items.map((item) {
                return Text(item);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
