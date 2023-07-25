

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lanzhong/request/request_client.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:logger/logger.dart';

import 'model/api_response/api_response_entity.dart';
import 'model/api_response/list_data.dart';
import 'model/game2_entity.dart';
import 'model/insert_entity.dart';
import 'model/kfpt_entity.dart';
import 'model/tb_game_entity.dart';
import 'model/tbgame.dart';

class EditGame extends StatefulWidget {
  final int tgid;
  final int tgindex;
  const EditGame({super.key,required this.tgid,required this.tgindex});

  @override
  State<EditGame> createState() => _EditGameState();
}

class _EditGameState extends State<EditGame> {
  final List<String> gameItems = ['请选择'];
  List<String> kfptItems = ['请选择'];
  final List<String> sendItems = ['否', '是'];
  String? selectedGameValue="请选择";
  String? selectedKfptValue="请选择";
  List<String> selectedKfptItems = [];
  TextEditingController lxrController= TextEditingController();
  TextEditingController lxdhController = TextEditingController();
  TextEditingController lxqqController = TextEditingController();
  TextEditingController aqjController = TextEditingController();
  TextEditingController xljController = TextEditingController();
  TextEditingController jdsmController = TextEditingController();
  TextEditingController jdyqController = TextEditingController();
  late FocusNode lxrFocus;
  late FocusNode lxdhFocus;
  late FocusNode lxqqFocus;
  late FocusNode aqjFocus;
  late FocusNode xljFocus;
  late FocusNode jdsmFocus;
  late FocusNode jdyqFocus;
  var logger = Logger(printer: PrettyPrinter());
  void loadData() async{
    RequestClient requestClient = RequestClient();
    String url = "/Personal/LoadGame";
    ListData<Game2Entity>? pte = await requestClient.get<ListData<Game2Entity>>(url,onError: (e){
      return e.code==0;
    });
    if(pte!=null)
    {
      setState(() {
        for(int i=0;i<pte.data!.length;i++)
        {
          gameItems.add(pte.data![i].gameName);
        }
      });
    }
  }
  void loadAll() async{
    RequestClient requestClient = RequestClient();
    String url = "/Personal/LoadGame";
    ListData<Game2Entity>? pte = await requestClient.get<ListData<Game2Entity>>(url,onError: (e){
      return e.code==0;
    }).then((value){
      setState(() {
        for(int i=0;i<value!.data!.length;i++)
        {
          gameItems.add(value.data![i].gameName);
        }
      });
      return value;
    }).then((value)async{
      RequestClient requestClient = RequestClient();
      String url = "/Personal/GetTbGame?id=${widget.tgid}";
      TbGameEntity? tge = await requestClient.get<TbGameEntity>(url,onError: (e){
        return e.code==0;
      }).then((value2){
        if(value2!=null)
        {
          setState(() {
            selectedGameValue=value2.yxmc;
            selectedKfptValue=value2.kfpt;
            lxrController.text=value2.lxr??"";
            lxdhController.text=value2.lxdh??"";
            lxqqController.text=value2.lxqq??"";
            aqjController.text=value2.aqbzj.toString();
            xljController.text=value2.xlbzj.toString();
            jdyqController.text=value2.jdyq;
            jdsmController.text=value2.jdsm;
          });
          loadKf2();
        }
        return value2;
      });
      return value;
    });
  }
  void loadTbGame() async{
    RequestClient requestClient = RequestClient();
    String url = "/Personal/GetTbGame?id=${widget.tgid}";
    TbGameEntity? tge = await requestClient.get<TbGameEntity>(url,onError: (e){
      return e.code==0;
    });
    if(tge!=null)
    {
      setState(() {
       selectedGameValue=tge.yxmc;
       if(tge.kfpt!="")
       {
         selectedKfptValue=tge.kfpt;
         if(tge.kfpt!.contains(","))
         {
           selectedKfptItems=tge.kfpt.split(",");
         }
         else
         {
           selectedKfptItems=[tge.kfpt];
         }
       }
       lxrController.text=tge.lxr??"";
       lxdhController.text=tge.lxdh??"";
       lxqqController.text=tge.lxqq??"";
       aqjController.text=tge.aqbzj.toString();
       xljController.text=tge.xlbzj.toString();
       jdyqController.text=tge.jdyq;
       jdsmController.text=tge.jdsm;
      });
    }
  }
  void loadKf() async{
    RequestClient requestClient = RequestClient();
    String url = "/Personal/GetKfpt";
    Map<String, dynamic>? formData = {"yxmc": selectedGameValue};
    Map<String, dynamic>? headers={"Content-type":"application/x-www-form-urlencoded"};
    KfptEntity? ket = await requestClient.post<KfptEntity>(url,data: formData,headers: headers,onError: (e){
      return e.code==0;
    });
    if(ket!=null)
    {
      setState(() {
        selectedKfptItems.clear();
        selectedKfptValue="请选择";
        if(ket.kfpts.isNotEmpty)
        {
          kfptItems=ket.kfpts.split(",");
        }
        else
        {
          kfptItems.clear();
        }
      });
    }
  }
  void loadKf2() async{
    RequestClient requestClient = RequestClient();
    String url = "/Personal/GetKfpt";
    Map<String, dynamic>? formData = {"yxmc": selectedGameValue};
    Map<String, dynamic>? headers={"Content-type":"application/x-www-form-urlencoded"};
    KfptEntity? ket = await requestClient.post<KfptEntity>(url,data: formData,headers: headers,onError: (e){
      return e.code==0;
    });
    if(ket!=null)
    {
      setState(() {
        if(ket.kfpts.isNotEmpty)
        {
          kfptItems=ket.kfpts.split(",");
        }
        else
        {
          kfptItems.clear();
        }
        selectedKfptItems=selectedKfptValue!.split(",");
      });
    }
  }
  @override
  void initState() {
    super.initState();
    lxrFocus = FocusNode();
    lxdhFocus = FocusNode();
    lxqqFocus = FocusNode();
    aqjFocus = FocusNode();
    xljFocus = FocusNode();
    jdsmFocus=FocusNode();
    jdyqFocus=FocusNode();
    loadKf();
    loadAll();
    // setState(() {
    //   selectedGameValue="战火勋章";
    // });
  }
  Widget wGame(){
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        alignment:AlignmentDirectional.centerEnd ,
        isExpanded: true,
        hint: SizedBox(
            width: 160,
            child:Text(
              selectedGameValue!,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 14,  color: Theme.of(context).hintColor,
              ),
            ) ) ,
        items: gameItems.map((item) => DropdownMenuItem<String>(value: item,
            child: SizedBox(width: 160,child: Text(item,  textAlign: TextAlign.right)))
        ).toList(),
        onChanged: (value) {
          setState(() {
            selectedGameValue = value as String;
            loadKf();
          });
        },
        buttonStyleData: const ButtonStyleData(
            height: 32,
            width: 160,
            padding: EdgeInsets.only(left: 0, right:0)
        ),
        iconStyleData: const IconStyleData(
          iconSize: 32,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 300,
          width: 160,
          elevation: 8,
          offset: const Offset(136, 0),
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
  Widget wKfpt(){
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        alignment:AlignmentDirectional.centerEnd ,
        isExpanded: true,
        hint: SizedBox(
            width: MediaQuery.of(context).size.width-132,
            child:Text(
              selectedKfptValue!,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 14,  color: Theme.of(context).hintColor,
              ),
            ) ) ,
        items: kfptItems.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            //disable default onTap to avoid closing menu when selecting an item
            enabled: false,
            child: StatefulBuilder(
              builder: (context, menuSetState) {
                final _isSelected = selectedKfptItems.contains(item);
                return InkWell(
                  onTap: () {
                    _isSelected
                        ? selectedKfptItems.remove(item)
                        : selectedKfptItems.add(item);
                    //This rebuilds the StatefulWidget to update the button's text
                    setState(() {});
                    //This rebuilds the dropdownMenu Widget to update the check mark
                    menuSetState(() {});
                  },
                  child: Container(
                    height: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      children: [
                        _isSelected
                            ? const Icon(Icons.check_box_outlined)
                            : const Icon(Icons.check_box_outline_blank),
                        const SizedBox(width: 14),
                        Text(
                          item,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }).toList(),
        value:  selectedKfptItems.isEmpty ? null : selectedKfptItems.last,
        onChanged: (value) {

        }, selectedItemBuilder: (context) {
        return kfptItems.map((item) {
          return Container(
            alignment: AlignmentDirectional.centerEnd,
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Text(
              selectedKfptItems.join(','),
              style: const TextStyle(
                fontSize: 14,
                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 1,
            ),
          );
        },
        ).toList();
      },
        buttonStyleData: const ButtonStyleData(
            height: 32,
            padding: EdgeInsets.only(left: 0, right:0)
        ),
        iconStyleData: const IconStyleData(
          iconSize: 32,
        ),
        dropdownStyleData: DropdownStyleData(

          maxHeight: 300,
          width: 160,
          elevation: 8,
          offset: const Offset(136, 0),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(247, 249, 253, 1),
        body:SingleChildScrollView(
        child: Container(
            alignment: Alignment.topCenter,
            decoration: const BoxDecoration(
              color: Color(0xFFF7F9FD),
            ),
            width: MediaQuery.of(context).size.width,
            child: Column(children: [
              Row(
                children: [
                  Container(
                    width: 26,
                    height: 45,
                    padding: const EdgeInsets.all(0),
                    margin: const  EdgeInsets.only(left: 20,top:36),
                    child: GestureDetector(
                        onTap: (){
                          if (context.mounted) {
                            Navigator.of(context).pop(TbGame(-1,"","",0));
                          }
                        },
                        child: Image.asset("images/arrow_left.png",width: 21,height: 36))
                  ),
                  Container(
                    width: 120,
                    height: 32,
                    margin: const  EdgeInsets.only(left: 10,top:36),
                    child: const Text("编辑游戏",style: TextStyle(color: Color(0xFF333333), fontSize: 20)),
                  ),
                ]
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
                      child: Text("游戏名称",
                          style:
                          TextStyle(color: Color(0xff333333), fontSize: 16)),
                    ),
                    Expanded(
                        flex: 76,
                        child: wGame()
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
                      child: Text("可发平台",
                          style:
                          TextStyle(color: Color(0xff333333), fontSize: 16)),
                    ),
                    Expanded(
                        flex: 76,
                        child: wKfpt()
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
                      child: Text("发单名称",
                          style:
                          TextStyle(color: Color(0xff333333), fontSize: 16)),
                    ),
                    Expanded(
                        flex: 76,
                        child:  TextField(
                          controller: lxrController,
                          focusNode: lxrFocus,
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            //内容的内边距
                              contentPadding: EdgeInsets.only(right: 10),
                              hintText: '请输入发单名称',
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
                      child: Text("发单电话",
                          style:
                          TextStyle(color: Color(0xff333333), fontSize: 16)),
                    ),
                    Expanded(
                        flex: 76,
                        child:  TextField(
                            controller: lxdhController,
                            focusNode: lxdhFocus,
                            textAlign: TextAlign.right,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              //内容的内边距
                                contentPadding: EdgeInsets.all(2.0),
                                hintText: '请输入发单电话',
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
                      child: Text("发单QQ",
                          style:
                          TextStyle(color: Color(0xff333333), fontSize: 16)),
                    ),
                    Expanded(
                        flex: 76,
                        child: TextField(
                            controller: lxqqController,
                            focusNode: lxqqFocus,
                            textAlign: TextAlign.right,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              //内容的内边距
                                contentPadding: EdgeInsets.only(right: 10),
                                hintText: '请输入发单QQ',
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
                      child: Text("安全保证金",
                          style:
                          TextStyle(color: Color(0xff333333), fontSize: 16)),
                    ),
                    Expanded(
                        flex: 76,
                        child: TextField(
                            controller: aqjController,
                            focusNode: aqjFocus,
                            textAlign: TextAlign.right,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              //内容的内边距
                                contentPadding: EdgeInsets.all(2.0),
                                hintText: '请输入安全保证金',
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
                      child: Text("效率保证金",
                          style:
                          TextStyle(color: Color(0xff333333), fontSize: 16)),
                    ),
                    Expanded(
                        flex: 76,
                        child:  TextField(
                            controller: xljController,
                            focusNode: xljFocus,
                            textAlign: TextAlign.right,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              //内容的内边距
                                contentPadding: EdgeInsets.all(2.0),
                                hintText: '请输入效率保证金',
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
                      child: Text("发单说明",
                          style:
                          TextStyle(color: Color(0xff333333), fontSize: 16)),
                    ),
                    Expanded(
                        flex: 76,
                        child:  TextField(
                            controller: jdsmController,
                            focusNode: jdsmFocus,
                            textAlign: TextAlign.right,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              //内容的内边距
                                contentPadding: EdgeInsets.all(2.0),
                                hintText: '请输入',
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
                padding: const EdgeInsets.only(bottom: 2),
                child: Flex(
                  direction: Axis.horizontal,
                  children: const <Widget>[
                    Expanded(
                      flex: 2,
                      child: Text("*",
                          style:
                          TextStyle(color: Color(0xFFFF1717), fontSize: 16),
                          textAlign: TextAlign.end),
                    ),
                    Expanded(
                      flex: 98,
                      child: Text("发单要求",
                          style:
                          TextStyle(color: Color(0xff333333), fontSize: 16)),
                    ),
                  ],
                ),
              ),
              Container(
                  width: MediaQuery.of(context).size.width-10,
                  height: 160,
                  padding: const EdgeInsets.only(left: 10,top: 3,right: 10),
                  margin: const EdgeInsets.only(left: 2,top: 6,right: 2,bottom:10),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF7F9FD),  border:  Border(bottom: BorderSide(width: 1, color: Color(0xfff7f9fd))),
                  ),
                  child:  TextField(
                    maxLines: 10,
                    controller: jdyqController,
                    focusNode: jdyqFocus,
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.left,
                    keyboardType: TextInputType.text,
                    maxLength: 1200,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(6),
                        hintText: '请输入代练要求信息',helperStyle:  TextStyle(fontSize: 16),
                        filled: true,
                        fillColor: Color(0xfff5f5f5),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(6))
                        )
                    ),
                  )
              ),

              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9),
                    gradient: const LinearGradient(colors: [
                      Color(0xffFFBF3A),
                      Color(0xffFF5100),
                    ]),
                  ),
                  width: MediaQuery.of(context).size.width-20,
                  height: 46,
                  margin: const EdgeInsets.only(left: 20,right: 20,top: 10),
                  padding:const EdgeInsets.only(left: 10,top: 2,bottom: 2,right: 10),
                  child: TextButton(onPressed: () async{
                    if(selectedGameValue=="请选择")
                    {
                      await showOkAlertDialog(
                          context: context, title: '提示', message: '请选择一个游戏');
                      return;
                    }
                    if(lxrController.text=="")
                    {
                      await showOkAlertDialog(
                          context: context, title: '提示', message: '发单名称不能为空').then((value) {lxrFocus.requestFocus();});
                      return;
                    }
                    if(lxdhController.text=="")
                    {
                      await showOkAlertDialog(
                          context: context,
                          title: '提示',
                          message: '发达电话不能为空').then((value) {lxdhFocus.requestFocus();});
                      return;
                    }
                    if(lxqqController.text=="")
                    {
                      await showOkAlertDialog(
                          context: context,
                          title: '提示',
                          message: '发达qq不能为空').then((value) {lxqqFocus.requestFocus();});
                      return;
                    }
                    if(aqjController.text=="")
                    {
                      await showOkAlertDialog(
                          context: context,
                          title: '提示',
                          message: '安全金不能为空').then((value) {aqjFocus.requestFocus();});
                      return;
                    }
                    if(xljController.text=="")
                    {
                      await showOkAlertDialog(
                          context: context,
                          title: '提示',
                          message: '效率金不能为空').then((value) {xljFocus.requestFocus();});
                      return;
                    }
                    if(jdsmController.text=="")
                    {
                      await showOkAlertDialog(
                          context: context,
                          title: '提示',
                          message: '接单说明不能为空').then((value) {jdsmFocus.requestFocus();});
                      return;
                    }
                    if(jdyqController.text=="")
                    {
                      await showOkAlertDialog(
                          context: context,
                          title: '提示',
                          message: '接单要求不能为空').then((value) {jdyqFocus.requestFocus();});
                      return;
                    }
                    //logger.d("selectedKfptValue=${selectedKfptItems.join(',')}");
                    Map<String, dynamic>? formData = {
                      "Id": widget.tgid,
                      "yxmc": selectedGameValue,
                      "kfpt": selectedKfptItems.join(','),
                      "sfxs":'是',
                      "lxr": lxrController.text,
                      "lxdh":lxdhController.text,
                      "lxqq":lxqqController.text,
                      "aqbzj":aqjController.text,
                      "xlbzj":xljController.text,
                      "jdyq":jdyqController.text,
                      "jdsm":jdsmController.text,
                    };
                    await EasyLoading.show(status: '验证中...', maskType: EasyLoadingMaskType.black);
                    String url="/Personal/TbGameUpdate";
                    RequestClient requestClient = RequestClient();
                    await requestClient.post<ApiResponse>(url,data: formData,onError: (e){
                      EasyLoading.showError(e.message!);
                      return e.code==0;
                    },onSuccess: (ApiResponse response){
                      if (context.mounted) {
                        Navigator.of(context).pop(TbGame(widget.tgid,selectedGameValue,selectedKfptItems.join(','),widget.tgindex));
                      }
                    });
                  }, child: const Text("保存",style:  TextStyle(color:Colors.white, fontSize: 16), textAlign: TextAlign.center)
                  )
              )
            ])
        ) ));
  }
}
