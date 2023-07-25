
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lanzhong/request/request_client.dart';

import 'event_bus.dart';
import 'model/api_response/list_data.dart';
import 'model/insert_entity.dart';
import 'model/sub_entity.dart';

class SubPage extends StatefulWidget {
  final int gid;
  const SubPage({super.key, required this.gid});

  @override
  State<SubPage> createState() => _SubPageState();
}
class _SubPageState extends State<SubPage> {
  void addGameType(String dllx) async{
    var curDate= DateTime.now();
    Map<String, dynamic>? formData = {
      "id":  "0",
      "dllx":  dllx,
      "gid": widget.gid,
      "lrrq":"${curDate.year}-${curDate.month}-${curDate.day} ${curDate.hour}:${curDate.minute}:${curDate.second}",
      "kfpts":  "",
      "zdywz":  "",
    };
    String url="/Personal/SubAdd";
    RequestClient requestClient = RequestClient();
     await requestClient.post<InsertEntity>(url,data: formData,onError: (e){
      return e.code==0;
    },onSuccess: (res)async{
       debugPrint("inserid=$res");
      if(res.code==0)
      {
        bus.emit("setDllx", "1");
        setState(() {
          SubEntity sube=SubEntity();
          sube.gid=widget.gid;
          sube.lrrq="${curDate.year}-${curDate.month}-${curDate.day} ${curDate.hour}:${curDate.minute}:${curDate.second}";
          sube.dllx=dllx;
          sube.kfpts="";
          sube.zdywz="";
          sube.id=res.data!.insertid;
          if(subs.isNotEmpty)
          {
            subs.insert(0, sube);
          }
          else
          {
            subs.add(sube);
          }
        });
      }
      else
      {
        EasyLoading.showError(res.message!);
      }
    });
  }
  void delGameType(int id,int index) async{

    String url="/Personal/SubDel?id=$id";
    RequestClient requestClient = RequestClient();
    await requestClient.get(url,onError: (e){
      return e.code==0;
    },onSuccess: (res)async{
     if(res.code==0)
     {
       bus.emit("setDllx", "1");
       setState(() {
         subs.removeAt(index);
       });
     }
    });
  }
  List<SubEntity> subs=[];
  void loadData ()async {
    RequestClient requestClient = RequestClient();
    String url = "/Personal/GetSub?gid=${widget.gid}";
    ListData<SubEntity>? listSubs = await requestClient.get<ListData<SubEntity>>(url,onError: (e){
      return e.code==0;
    });
    if(listSubs!=null)
    {
      setState(() {
        subs=listSubs.data!;
      });
    }
  }
  Widget buildItem(int index) {
    //滑动组件
    return Slidable(
      key: ValueKey("slide$index"),
      //滑动方向
      direction: Axis.horizontal,
      //配置的是右侧
      endActionPane:ActionPane(
        extentRatio: 0.2,
        motion:  const ScrollMotion(),
        children: [
          CustomSlidableAction(
           onPressed: (ctx){
             delGameType(subs[index].id, index);
           },
            backgroundColor: const Color.fromRGBO(255, 141, 87, 1),
            foregroundColor: Colors.white,
            padding:  const EdgeInsets.all(0),
            child: Container(
              height: 26,width: 26,
                padding: const EdgeInsets.all(0),
                margin: const EdgeInsets.all(0),
                child: const Image(image: AssetImage('images/btn_del.png') ,height: 26,width: 26)),
          ),
        ],
      ),
      //列表显示的子Item
      child: Container(
        decoration:  const BoxDecoration(
          color: Colors.white,
          border:  Border(bottom: BorderSide(width: 1, color:Color.fromRGBO(247, 249, 253, 1))),
        ),
        alignment: Alignment.centerLeft,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(left: 10,top: 10,bottom: 10),
        margin: const EdgeInsets.only(left: 0,right: 0),
        child: Column(children:  [
          Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              Expanded(
                flex: 6,
                child:Container(
                    padding:const EdgeInsets.all(0),
                    margin: const EdgeInsets.all(0),
                    height: 24,
                    child:Text(subs[index].dllx, style: const TextStyle(color: Color(0xFF333333), fontSize: 18))),
              ),
            ],
          ),
          Container(
              width: MediaQuery.of(context).size.width-10,
              padding:const EdgeInsets.all(0),
              margin: const EdgeInsets.all(0),
              child:Text(subs[index].lrrq, style: const TextStyle(color: Color(0xFF999999), fontSize: 12))),
        ]),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadData ();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor:  const Color(0xFFf5f5f5),
        body:Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 46,
              margin: const EdgeInsets.only(top: 36),
              padding: const EdgeInsets.all(0),
              child: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 32.0,
                      child: IconButton(onPressed: () {
                        Navigator.pop(context);
                      }, icon:  Image.asset("images/arrow_left.png",width: 32,height: 54)),
                    ),
                  ),
                  const Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 22.0,
                      child: Text('代练类型', style: TextStyle(color: Color(0xFF333333), fontSize: 18), textAlign: TextAlign.left),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      height: 28.0,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      height: 46.0,
                      child:  UnconstrainedBox(
                          child: TextButton(
                              style: ButtonStyle(
                                  minimumSize: MaterialStateProperty.all(const Size(80, 36)),
                                  visualDensity: VisualDensity.compact,
                                  padding: MaterialStateProperty.all(const EdgeInsets.only(top: 2,bottom: 2)),
                                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(2))),
                                  backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(255, 141, 87, 1))
                              ),
                              onPressed: () async{
                                final textInput = await showTextInputDialog(
                                    context: context,title: '代练类型',okLabel: "确定",cancelLabel: "取消",
                                    textFields:  [
                                      DialogTextField(hintText: '请输入到代练类型', maxLength: 10,keyboardType: TextInputType.text,
                                          validator: (value) {
                                            if(value!.isEmpty)
                                            {
                                              return "代练类型不能为空";
                                            }
                                            return null;
                                          })
                                    ]
                                );
                                if(textInput!=null)
                                {
                                  //debugPrint("textInput:${textInput.elementAt(0).toString()}");
                                  addGameType(textInput.elementAt(0).toString());
                                }
                              },
                              child: const Text('添加',style: TextStyle(color: Colors.white, fontSize: 14))
                          )
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(top: 96),
              padding: const EdgeInsets.only(left: 10,right: 10),
              child:ListView.builder(
                  itemCount: subs.length,
                  shrinkWrap:true,
                  padding: const EdgeInsets.all(0),
                  physics:const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return buildItem(index);
                  }
              ),
            )
          ],
        )
    );
  }
}
