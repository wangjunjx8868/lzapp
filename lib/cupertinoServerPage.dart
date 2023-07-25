import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'model/dq_entity.dart';

@immutable
//用来显示底部弹出 可滚动视图的
class ShowServerDialog extends StatefulWidget {
  //内容
  final  List<DqServers> items;
  //选中回调 (int,String) 对应的下标和对应的值
  final  Function onTap;

  const ShowServerDialog({super.key,
    required this.items,
    required this.onTap,
  });
  @override
  State<ShowServerDialog> createState() => _ShowServerDialogState();
}

class _ShowServerDialogState extends State<ShowServerDialog> {

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
                return Text(item.gameServerName);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
