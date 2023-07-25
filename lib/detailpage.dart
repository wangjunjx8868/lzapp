
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lanzhong/addchat.dart';
import 'package:lanzhong/request/request_client.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'PanPage.dart';
import 'addchat2.dart';
import 'addimage.dart';
import 'applyinvoke.dart';
import 'model/orders_entity.dart';
import 'model/ptddh_entity.dart';
import 'model/ptresponse.dart';


class DetailPage extends StatefulWidget {
  final int tbid;
  final int oIndex;
  const DetailPage({super.key,required this.tbid, required this.oIndex});
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late OrdersData?  order=OrdersData();
  var logger = Logger(printer: PrettyPrinter());
  void loadData() async{
    RequestClient requestClient = RequestClient();
    String url = "/Order/GetDetailView?id=${widget.tbid}";
    OrdersData? pte = await requestClient.get<OrdersData>(url,onError: (e){
      return e.code==0;
    });
    if(pte!=null)
    {
      setState(() {
        order=pte;
      });
    }
  }
  @override
  void initState() {
    super.initState();
    loadData();
  }
  void applyAritrate() async{
    Map<String, dynamic>? formData = {
      "id": order!.id.toString(),
      "ptzt":  order!.zt,
      "ptName":  order!.dlpt,
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
          Navigator.pop(context,PtResponse(index: widget.oIndex,zt: "仲裁中"));
        }
      }
      else
      {
        EasyLoading.showError(res.message!);
      }
    });
    await  EasyLoading.dismiss();
  }
  void agreeInvoke(int tbId,String ptZt,String ptName,int index) async{
    Map<String, dynamic>? formData = {"id": tbId, "ptzt": ptZt,"ptName": ptName};
    await EasyLoading.show(status: '验证中...', maskType: EasyLoadingMaskType.black);
    String url="/Order/AgreeRevoke";
    Map<String, dynamic>? headers={"Content-type":"application/x-www-form-urlencoded"};
    RequestClient requestClient = RequestClient();
    await EasyLoading.show(status: '验证中...', maskType: EasyLoadingMaskType.black);
    await requestClient.post(url,data: formData,headers: headers,onError: (e){
      EasyLoading.showError(e.message!);
      return e.code==0;
    },onSuccess: (res)async{
      if(res.code==0)
      {
        if (context.mounted) {
          Navigator.of(context).pop(PtResponse(index: index,zt: "已撤销"));
        }
      }
      else
      {
        EasyLoading.showError(res.message!);
      }
    });
    await  EasyLoading.dismiss();
  }
  void cancelInvoke(int tbId,String ptZt,String ptName,int index) async{
    Map<String, dynamic>? formData = {"id": tbId, "ptzt": ptZt,"ptName": ptName};
    await EasyLoading.show(status: '验证中...', maskType: EasyLoadingMaskType.black);
    String url="/Order/CancelRevoke";
    Map<String, dynamic>? headers={"Content-type":"application/x-www-form-urlencoded"};
    RequestClient requestClient = RequestClient();
    await EasyLoading.show(status: '验证中...', maskType: EasyLoadingMaskType.black);
    await requestClient.post(url,data: formData,headers: headers,onError: (e){
      EasyLoading.showError(e.message!);
      return e.code==0;
    },onSuccess: (res)async{
      if(res.code==0)
      {
        if (context.mounted) {
          Navigator.of(context).pop(PtResponse(index: index,zt: "代练中"));
        }
      }
      else
      {
        EasyLoading.showError(res.message!);
      }
    });
    await  EasyLoading.dismiss();
  }
  void cancelArbitrate(int tbId,String ptZt,String ptName,int index) async{
    Map<String, dynamic>? formData = {"id": tbId, "ptzt": ptZt,"ptName": ptName};
    await EasyLoading.show(status: '验证中...', maskType: EasyLoadingMaskType.black);
    String url="/Order/CancelArbitrate";
    Map<String, dynamic>? headers={"Content-type":"application/x-www-form-urlencoded"};
    RequestClient requestClient = RequestClient();
    await EasyLoading.show(status: '验证中...', maskType: EasyLoadingMaskType.black);
    await requestClient.post(url,data: formData,headers: headers,onError: (e){
      EasyLoading.showError(e.message!);
      return e.code==0;
    },onSuccess: (res)async{
      if(res.code==0)
      {
        if (context.mounted) {
          Navigator.of(context).pop(PtResponse(index: index,zt: "代练中"));
        }
      }
      else
      {
        EasyLoading.showError(res.message!);
      }
    });
    await  EasyLoading.dismiss();
  }
  void agreeOver() async{
    Map<String, dynamic>? formData = {
      "id": order!.id.toString(),
      "ptzt":  order!.zt,
      "ptName":  order!.dlpt,
    };
    await EasyLoading.show(status: '验证中...', maskType: EasyLoadingMaskType.black);
    String url="/Order/AgreeOver";
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
          Navigator.pop(context,PtResponse(index: widget.oIndex,zt: "已结算"));
        }
      }
      else
      {
        EasyLoading.showError(res.message!);
      }
    });
    await  EasyLoading.dismiss();
  }
  void unLock() async{
    Map<String, dynamic>? formData = {
      "id": order!.id.toString(),
      "ptzt":  order!.zt,
      "ptName":  order!.dlpt,
    };
    await EasyLoading.show(status: '验证中...', maskType: EasyLoadingMaskType.black);
    String url="/Order/UnLock";
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
          Navigator.pop(context,PtResponse(index: widget.oIndex,zt: "代练中"));
        }
      }
      else
      {
        EasyLoading.showError(res.message!);
      }
    });
    await  EasyLoading.dismiss();
  }
  void addHour(String hour) async{
    Map<String, dynamic>? formData = {
      "id": order!.id.toString(),
      "ptzt":  order!.zt,
      "ptName":  order!.dlpt,
      "addHour": hour,
    };
    await EasyLoading.show(status: '验证中...', maskType: EasyLoadingMaskType.black);
    String url="/Order/AddHour";
    Map<String, dynamic>? headers={"Content-type":"application/x-www-form-urlencoded"};
    RequestClient requestClient = RequestClient();
    await requestClient.post(url,data: formData,headers: headers,onError: (e){
      EasyLoading.showError(e.message!);
      return e.code==0;
    },onSuccess: (res)async{
      if(res.code==0)
      {
        setState(() {
          order!.dlsj= order!.dlsj+int.parse(hour);
        });
        EasyLoading.showSuccess("操作成功！");
      }
      else
      {
        EasyLoading.showError(res.message!);
      }
    });
    await  EasyLoading.dismiss();
  }
  void updateHour(String hour,int index) async{
    Map<String, dynamic>? formData = {
      "id": order!.id,
      "addhour": hour,
    };
    await EasyLoading.show(status: '验证中...', maskType: EasyLoadingMaskType.black);
    String url="/Order/UpdateHour";
    RequestClient requestClient = RequestClient();
    await requestClient.get(url,queryParameters: formData,onError: (e){
      EasyLoading.showError(e.message!);
      return e.code==0;
    },onSuccess: (res)async{
      if(res.code==0)
      {
        setState(() {
          order!.dlsj=order!.dlsj+int.parse(hour);
        });
        EasyLoading.showSuccess("操作成功！");
      }
      else
      {
        EasyLoading.showError(res.message!);
      }
    });
    await  EasyLoading.dismiss();
  }
  void addPrice(String price) async{
    Map<String, dynamic>? formData = {
      "id": order!.id.toString(),
      "ptzt":  order!.zt,
      "ptName":  order!.dlpt,
      "addPrice": price,
    };
    await EasyLoading.show(status: '验证中...', maskType: EasyLoadingMaskType.black);
    String url="/Order/AddPrice";
    Map<String, dynamic>? headers={"Content-type":"application/x-www-form-urlencoded"};
    RequestClient requestClient = RequestClient();
    await requestClient.post(url,data: formData,headers: headers,onError: (e){
      EasyLoading.dismiss();
      EasyLoading.showError(e.message!);
      return e.code==0;
    },onSuccess: (res)async{
      await  EasyLoading.dismiss();
      if(res.code==0)
      {
        setState(() {
          order!.zc= order!.zc+int.parse(price);
          order!.lr= order!.sr- order!.zc;
        });
        EasyLoading.showSuccess("操作成功！");
      }
      else
      {
        EasyLoading.showError(res.message!);
      }
    });
  }
  void updatePrice(String price,int index) async{
    Map<String, dynamic>? formData = {
      "id": order!.id.toString(),
      "addprice": price,
    };
    await EasyLoading.show(status: '验证中...', maskType: EasyLoadingMaskType.black);
    String url="/Order/UpdatePrice";
    RequestClient requestClient = RequestClient();
    await requestClient.get(url,queryParameters: formData,onError: (e){
      EasyLoading.showError(e.message!);
      return e.code==0;
    },onSuccess: (res)async{
      if(res.code==0)
      {
        setState(() {
          order!.zc=order!.zc+int.parse(price);
        });
        EasyLoading.showSuccess("操作成功！");
      }
      else
      {
        EasyLoading.showError(res.message!);
      }
    });
    await  EasyLoading.dismiss();
  }
  ///发货
  void orderDelivery(int tbId,int index) async{
    Map<String, dynamic>? formData = {"id": tbId};
    await EasyLoading.show(status: '验证中...', maskType: EasyLoadingMaskType.black);
    String url="/Order/FH";
    Map<String, dynamic>? headers={"Content-type":"application/x-www-form-urlencoded"};
    RequestClient requestClient = RequestClient();
    await requestClient.post(url,data: formData,headers: headers,onError: (e){
      EasyLoading.showError(e.message!);
      return e.code==0;
    },onSuccess: (res)async{
      if(res.code==0)
      {
        EasyLoading.showSuccess("发货成功！");
      }
      else
      {
        EasyLoading.showError(res.message!);
      }
    });
    await  EasyLoading.dismiss();
  }
  void addPublish(int tbId,int index)async {
    SharedPreferences prefs =await SharedPreferences.getInstance();
    Map<String, dynamic> dic = {
      "id": tbId.toString(),
      "yhid": prefs.getString("yhid"),
    };
    await EasyLoading.show(status: '验证中...', maskType: EasyLoadingMaskType.black);
    String url="http://lz.lzsterp.com/App/Publish";
    Map<String, dynamic>? headers={"content-type":"application/x-www-form-urlencoded"};
    RequestClient requestClient = RequestClient();
    await requestClient.post(url,data: dic,headers: headers,onError: (e){
      EasyLoading.showError(e.message!);
      return e.code==0;
    },onSuccess: (res)async{
      if(res.code==0)
      {
        EasyLoading.showSuccess("发布成功！");
        setState(() {
          order!.zt="未接手";
        });
      }
      else
      {
        EasyLoading.showError(res.message!);
      }
    });
    await  EasyLoading.dismiss();
  }
  void offShelf(int index) async{
    String tbid=order!.id.toString();
    await EasyLoading.show(status: '验证中...', maskType: EasyLoadingMaskType.black);
    String url="/Order/PtDelAll?id=$tbid";
    RequestClient requestClient = RequestClient();
    await requestClient.get(url,onError: (e){
      EasyLoading.showError(e.message!);
      return e.code==0;
    },onSuccess: (res){
      if(res.code==0)
      {
        EasyLoading.showSuccess("操作成功！");
        setState(() {
          order!.zt="未发布";
        });
      }
      else
      {
        EasyLoading.showError(res.message!);
      }
    });
    await  EasyLoading.dismiss();
  }
  void goInvokePage(int index)async {
    int aqj=order!.aqbzj;
    int xlj=order!.xlbzj;
    String tbid=order!.id.toString();
    String dlzt=order!.zt;
    String ptName=order!.dlpt;
    final dataInvoke=await Navigator.push(context, PanPageRouteBuilder(builder: (context) {return  InvokePage(aqbzj: aqj,xlbzj: xlj,tbid: tbid,dlzt: dlzt,ptName: ptName);}, transitionDuration: const Duration(milliseconds: 300),
        popDirection: AxisDirection.left));
    if(dataInvoke.toString()=="1")
    {
      setState(() {
        if(ptName=="私有平台")
        {
          order!.zt="已撤销";
        }
        else
        {
          order!.zt="撤销中";
        }
      });
    }
  }
  @override
  Widget build(BuildContext context) {
     List<Widget> widgets=[];
    String tbStatus=order!.zt;
    if(tbStatus=="未发布"||tbStatus=="已删除") {
      widgets=[
        const Spacer(),
        TextButton (
          onPressed:(){
            addPublish(order!.id,widget.oIndex);
          },
          style: ButtonStyle(
              padding: MaterialStateProperty.all(const EdgeInsets.only(left: 3,right: 3)),
              minimumSize: MaterialStateProperty.all(const Size(80, 36)),
              backgroundColor: const MaterialStatePropertyAll( Colors.grey),
              foregroundColor: MaterialStateProperty.all<Color>(const Color(0xFFFFFFFF)),
              ),
          child: const Text("发布订单")
        ),
        const Spacer(),
      ];
    }
    else if(tbStatus=="未接手") {
       widgets=[
         const Spacer(),
         TextButton (
           onPressed: ()async{
             if(order!.ptddh=="")
             {
               return;
             }
             final textInput = await showTextInputDialog(
                 context: context,title: '加时',okLabel: "确定",cancelLabel: "取消",
                 textFields:  [
                   DialogTextField(hintText: '请输入加时小时数', maxLength: 10,keyboardType: TextInputType.number,
                       validator: (value) {
                         if(value!.isEmpty)
                         {
                           return "小时数不能为空";
                         }
                         var isNumber=RegExp(r"\d+").hasMatch(value!);
                         return isNumber?null:"请输入整数";
                       })
                 ]
             );
             if(textInput!=null)
             {
               updateHour(textInput.elementAt(0).toString(),widget.oIndex);
             }
           },
           style: ButtonStyle(
             padding: MaterialStateProperty.all(const EdgeInsets.only(left: 3,right: 3)),
             minimumSize: MaterialStateProperty.all(const Size(80, 36)),
             backgroundColor: const MaterialStatePropertyAll( Color(0xFFFF8D57)),
             foregroundColor: MaterialStateProperty.all<Color>(const Color(0xFFFFFFFF)),
           ),
           child: const Text("加时"),
         ) , const Spacer(),
         TextButton (
           onPressed: ()async{
             if(order!.ptddh=="")
             {
               return;
             }
             final textInput = await showTextInputDialog(
                 context: context,title: '补款',okLabel: "确定",cancelLabel: "取消",
                 textFields:  [
                   DialogTextField(hintText: '请输入加钱金额', maxLength: 10,keyboardType: TextInputType.number,
                       validator: (value) {
                         if(value!.isEmpty)
                         {
                           return "金额不能为空";
                         }
                         var isNumber=RegExp(r"\d+").hasMatch(value!);
                         return isNumber?null:"请输入整数";
                       })
                 ]
             );
             if(textInput!=null)
             {
               updatePrice(textInput.elementAt(0).toString(),widget.oIndex);
             }
           },
           style: ButtonStyle(
             padding: MaterialStateProperty.all(const EdgeInsets.only(left: 3,right: 3)),
             minimumSize: MaterialStateProperty.all(const Size(80, 36)),
             backgroundColor: const MaterialStatePropertyAll( Color(0xFFFF8D57)),
             foregroundColor: MaterialStateProperty.all<Color>(const Color(0xFFFFFFFF)),
           ),
           child: const Text("加钱"),
         ) , const Spacer(),
         TextButton (
           onPressed: ()async{
             if(order!.ptddh=="")
             {
               return;
             }
             offShelf(widget.oIndex);
           },
           style: ButtonStyle(
             padding: MaterialStateProperty.all(const EdgeInsets.only(left: 3,right: 3)),
             minimumSize: MaterialStateProperty.all(const Size(80, 36)),
             backgroundColor: const MaterialStatePropertyAll( Color(0xFFFF8D57)),
             foregroundColor: MaterialStateProperty.all<Color>(const Color(0xFFFFFFFF)),
           ),
           child: const Text("下架"),
         ) , const Spacer(),
       ];
     }
    else if(tbStatus=="代练中"||tbStatus=="异常中") {
      widgets=[
        const Spacer(),
        TextButton (
          onPressed: (){
            if(order!.ptddh=="")
            {
              return;
            }
            goInvokePage(widget.oIndex);
          },
          style: ButtonStyle(
            padding: MaterialStateProperty.all(const EdgeInsets.only(left: 3,right: 3)),
            minimumSize: MaterialStateProperty.all(const Size(80, 36)),
            backgroundColor: const MaterialStatePropertyAll( Color(0xFFFF8D57)),
            foregroundColor: MaterialStateProperty.all<Color>(const Color(0xFFFFFFFF)),
          ),
          child: const Text("申请撤销"),
        ),  const Spacer(),
        TextButton (
          onPressed: ()async{
            if(order!.ptddh=="")
            {
              return;
            }
            final textInput = await showTextInputDialog(
                context: context,title: '补款',okLabel: "确定",cancelLabel: "取消",
                textFields:  [
                  DialogTextField(hintText: '请输入加钱金额', maxLength: 10,keyboardType: TextInputType.number,
                      validator: (value) {
                        if(value!.isEmpty)
                        {
                          return "金额不能为空";
                        }
                        var isNumber=RegExp(r"\d+").hasMatch(value);
                        return isNumber?null:"请输入整数";
                      })
                ]
            );
            if(textInput!=null)
            {
              addPrice(textInput.elementAt(0).toString());
            }
          },
          style: ButtonStyle(
            padding: MaterialStateProperty.all(const EdgeInsets.only(left: 3,right: 3)),
            minimumSize: MaterialStateProperty.all(const Size(80, 36)),
            backgroundColor: const MaterialStatePropertyAll( Color(0xFFFF8D57)),
            foregroundColor: MaterialStateProperty.all<Color>(const Color(0xFFFFFFFF)),
          ),
          child: const Text("加钱"),
        ),  const Spacer(),
        TextButton (
          onPressed: ()async{
            if(order!.ptddh=="")
            {
              return;
            }
            final textInput = await showTextInputDialog(
                context: context,title: '加时',okLabel: "确定",cancelLabel: "取消",
                textFields:  [
                  DialogTextField(hintText: '请输入加时小时数', maxLength: 10,keyboardType: TextInputType.number,
                      validator: (value) {
                        if(value!.isEmpty)
                        {
                          return "小时数不能为空";
                        }
                        var isNumber=RegExp(r"\d+").hasMatch(value!);
                        return isNumber?null:"请输入整数";
                      })
                ]
            );
            if(textInput!=null)
            {
              addHour(textInput.elementAt(0).toString());
            }
          },
          style: ButtonStyle(
            padding: MaterialStateProperty.all(const EdgeInsets.only(left: 3,right: 3)),
            minimumSize: MaterialStateProperty.all(const Size(80, 36)),
            backgroundColor: const MaterialStatePropertyAll( Color(0xFFFF8D57)),
            foregroundColor: MaterialStateProperty.all<Color>(const Color(0xFFFFFFFF)),
          ),
          child: const Text("加时"),
        ),  const Spacer()
      ];
    }
    else if(tbStatus=="撤销中") {
      widgets=[
        const Spacer(),
        TextButton (
          onPressed: (){
            if(order!.ptddh=="")
            {
              return;
            }
            agreeInvoke(order!.id,order!.zt,order!.dlpt,widget.oIndex);
          },
          style: ButtonStyle(
            padding: MaterialStateProperty.all(const EdgeInsets.only(left: 3,right: 3)),
            minimumSize: MaterialStateProperty.all(const Size(80, 36)),
            backgroundColor: const MaterialStatePropertyAll( Color(0xFFFF8D57)),
            foregroundColor: MaterialStateProperty.all<Color>(const Color(0xFFFFFFFF)),
          ),
          child: const Text("同意撤销"),
        ),  const Spacer(),
        const Spacer(),
        TextButton (
          onPressed: (){
            if(order!.ptddh=="")
            {
              return;
            }
            cancelInvoke(order!.id,order!.zt,order!.dlpt,widget.oIndex);
          },
          style: ButtonStyle(
            padding: MaterialStateProperty.all(const EdgeInsets.only(left: 3,right: 3)),
            minimumSize: MaterialStateProperty.all(const Size(80, 36)),
            backgroundColor: const MaterialStatePropertyAll( Color(0xFFFF8D57)),
            foregroundColor: MaterialStateProperty.all<Color>(const Color(0xFFFFFFFF)),
          ),
          child: const Text("取消撤销"),
        ),  const Spacer(),
      ];
    }
    else if(tbStatus=="已撤销"||tbStatus=="强制撤销") {
      widgets=[
        const Spacer(),
        TextButton (
          onPressed: (){
            if(order!.ptddh=="")
            {
              return;
            }
            addPublish(order!.id, widget.oIndex);
          },
          style: ButtonStyle(
            padding: MaterialStateProperty.all(const EdgeInsets.only(left: 3,right: 3)),
            minimumSize: MaterialStateProperty.all(const Size(80, 36)),
            backgroundColor: const MaterialStatePropertyAll( Color(0xFFFF8D57)),
            foregroundColor: MaterialStateProperty.all<Color>(const Color(0xFFFFFFFF)),
          ),
          child: const Text("一键重发"),
        ),  const Spacer(),
      ];
    }
    else if(tbStatus=="已锁定") {
      widgets=[
        const Spacer(),
        TextButton (
          onPressed: (){
            if(order!.ptddh=="")
            {
              return;
            }
            unLock();
          },
          style: ButtonStyle(
            padding: MaterialStateProperty.all(const EdgeInsets.only(left: 3,right: 3)),
            minimumSize: MaterialStateProperty.all(const Size(80, 36)),
            backgroundColor: const MaterialStatePropertyAll( Color(0xFFFF8D57)),
            foregroundColor: MaterialStateProperty.all<Color>(const Color(0xFFFFFFFF)),
          ),
          child: const Text("解锁订单"),
        ),  const Spacer(),
      ];
    }
    else if(tbStatus=="仲裁中") {
      widgets=[
        const Spacer(),
        TextButton (
          onPressed: (){
            if(order!.ptddh=="")
            {
              return;
            }
            cancelArbitrate(order!.id, order!.zt, order!.dlpt, widget.oIndex);
            },
          style: ButtonStyle(
            padding: MaterialStateProperty.all(const EdgeInsets.only(left: 3,right: 3)),
            minimumSize: MaterialStateProperty.all(const Size(80, 36)),
            backgroundColor: const MaterialStatePropertyAll( Color(0xFFFF8D57)),
            foregroundColor: MaterialStateProperty.all<Color>(const Color(0xFFFFFFFF)),
          ),
          child: const Text("取消仲裁"),
        ),  const Spacer(),
        const Spacer(),
        TextButton (
          onPressed: (){
            if(order!.ptddh=="")
            {
              return;
            }
            addPublish(order!.id, widget.oIndex);
          },
          style: ButtonStyle(
            padding: MaterialStateProperty.all(const EdgeInsets.only(left: 3,right: 3)),
            minimumSize: MaterialStateProperty.all(const Size(80, 36)),
            backgroundColor: const MaterialStatePropertyAll( Color(0xFFFF8D57)),
            foregroundColor: MaterialStateProperty.all<Color>(const Color(0xFFFFFFFF)),
          ),
          child: const Text("一键重发"),
        ),  const Spacer(),
      ];
    }
    else if(tbStatus=="待验收") {
      widgets=[
        const Spacer(),
        TextButton (
          onPressed: (){
            if(order!.ptddh=="")
            {
              return;
            }
            agreeOver();
          },
          style: ButtonStyle(
            padding: MaterialStateProperty.all(const EdgeInsets.only(left: 3,right: 3)),
            minimumSize: MaterialStateProperty.all(const Size(80, 36)),
            backgroundColor: const MaterialStatePropertyAll( Color(0xFFFF8D57)),
            foregroundColor: MaterialStateProperty.all<Color>(const Color(0xFFFFFFFF)),
          ),
          child: const Text("同意验收"),
        ),  const Spacer(),
        const Spacer(),
        TextButton (
          onPressed: (){
            if(order!.ptddh=="")
            {
              return;
            }
            goInvokePage(widget.oIndex);
          },
          style: ButtonStyle(
            padding: MaterialStateProperty.all(const EdgeInsets.only(left: 3,right: 3)),
            minimumSize: MaterialStateProperty.all(const Size(80, 36)),
            backgroundColor: const MaterialStatePropertyAll( Color(0xFFFF8D57)),
            foregroundColor: MaterialStateProperty.all<Color>(const Color(0xFFFFFFFF)),
          ),
          child: const Text("申请撤销"),
        ),  const Spacer(),
      ];
    }
    else if(tbStatus=="已结算"||tbStatus=="已仲裁") {
      widgets=[
        const Spacer(),
        TextButton (
          onPressed: (){
            if(order!.ptddh=="")
            {
              return;
            }
            addPublish(order!.id, widget.oIndex);
          },
          style: ButtonStyle(
            padding: MaterialStateProperty.all(const EdgeInsets.only(left: 3,right: 3)),
            minimumSize: MaterialStateProperty.all(const Size(80, 36)),
            backgroundColor: const MaterialStatePropertyAll( Color(0xFFFF8D57)),
            foregroundColor: MaterialStateProperty.all<Color>(const Color(0xFFFFFFFF)),
          ),
          child: const Text("一键重发"),
        ),  const Spacer(),
      ];
    }
    else  {
      widgets=[
        const Spacer(),
        TextButton (
            onPressed: null,
            style: ButtonStyle(
              padding: MaterialStateProperty.all(const EdgeInsets.only(left: 3,right: 3)),
              minimumSize: MaterialStateProperty.all(const Size(80, 36)),
              backgroundColor: const MaterialStatePropertyAll( Colors.grey),
              foregroundColor: MaterialStateProperty.all<Color>(const Color(0xFFFFFFFF)),
            ),
            child: const Text("申请撤销")
        ),
        const Spacer(),
        TextButton (
            onPressed: null,
            style: ButtonStyle(
              padding: MaterialStateProperty.all(const EdgeInsets.only(left: 3,right: 3)),
              minimumSize: MaterialStateProperty.all(const Size(80, 36)),
              backgroundColor: const MaterialStatePropertyAll( Colors.grey),
              foregroundColor: MaterialStateProperty.all<Color>(const Color(0xFFFFFFFF)),
            ),
            child: const Text("申请仲裁")
        ),
        const Spacer()
      ];
    }
    return  Scaffold(
        backgroundColor: const Color.fromRGBO(247, 249, 253, 1),
        body: SingleChildScrollView(child: Column(
            children: [
              Container(
                  width: MediaQuery.of(context).size.width,
                  decoration:  const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xffFFBF3A),
                          Color(0xffFF5100),
                        ]),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                  ),
                  child: Column(
                      children: [
                        Container(
                          height: 36,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(0),
                          margin: const EdgeInsets.only(top: 36),
                          child:GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                            },
                              child: Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 18,
                                  padding: const EdgeInsets.all(0),
                                  margin: const  EdgeInsets.only(left: 15,top:0),
                                  child:  Image.asset("images/arrow_left_white.png"),
                                ),
                                Container(
                                  width: 60,
                                  height: 32,
                                  margin: const  EdgeInsets.only(left: 10,top:2),
                                  child:  Text(order!.zt,style: const TextStyle(color: Colors.white, fontSize: 20)),
                                ),
                                const Spacer(),
                                Container(
                                  width: 120,
                                  height: 36,
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                    color:  Color(0xFFCC6211),
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(18),bottomLeft: Radius.circular(18)),
                                  ),
                                  margin: const  EdgeInsets.only(left: 0),
                                  padding: const EdgeInsets.all(0),
                                  child:  Text(order!.dlpt,style: const TextStyle(color: Colors.white, fontSize: 16)),
                                )
                              ]
                          ))
                        ),
                        Container(
                            height: 36,
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.all(0),
                            margin: const EdgeInsets.only(top: 6,left: 10),
                            child: Row(
                                children: [
                                  Container(
                                    width: 250,
                                    height: 32,
                                    margin: const  EdgeInsets.only(left: 10,top:8),
                                    child:  Text("平台订单: ${order!.ptddh}",style: const TextStyle(color: Colors.white, fontSize: 14)),
                                  ),
                                  Container(
                                      width: 32,
                                      height: 32,
                                      padding: const EdgeInsets.all(0),
                                      margin: const  EdgeInsets.only(left: 0,top:2),
                                      child:  IconButton(
                                          onPressed: () {
                                            Clipboard.setData(ClipboardData(text:order!.ptddh));
                                            EasyLoading.showSuccess("已复制到粘贴板");
                                          },
                                          icon:  Image.asset("images/btn_copy_white.png"),iconSize: 28)
                                  ),
                                  Container(
                                      width: 32,
                                      height: 32,
                                      padding: const EdgeInsets.all(0),
                                      margin: const  EdgeInsets.only(left: 0,top:2),
                                      child:  IconButton(
                                          onPressed: () {
                                            if(order!.ptddh=="")
                                            {
                                              return;
                                            }
                                            Navigator.push(context, PanPageRouteBuilder(builder: (context) {return  ChatPage(order:order!,ptddh: order!.ptddh);},
                                                transitionDuration: const Duration(milliseconds: 300),
                                                popDirection: AxisDirection.left));
                                          },
                                          icon:  Image.asset("images/btn_chat.png"),iconSize: 23)
                                  )
                                ]
                            )
                        ),
                        Container(
                          height: 28,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(0),
                          margin: const EdgeInsets.only(top: 0,left: 20),
                          child: const Text("剩余时间: 00天20小时00分",style: TextStyle(color: Colors.white, fontSize: 14)),
                        ),
                        Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width-40,
                            decoration: const BoxDecoration(
                              color:  Color.fromRGBO(0, 0, 0, 0.1),
                              borderRadius: BorderRadius.all(Radius.circular(6)),
                            ),
                            padding: const EdgeInsets.all(6),
                            margin: const EdgeInsets.only(top: 0,left: 20,right: 20),
                            child:  Text(order!.cxxx==""?order!.cxyy.replaceAll("<br>", "\n"):order!.cxxx.replaceAll("<br>", "\n"),maxLines: 2,style: const TextStyle(color: Colors.white, fontSize: 14)
                            )
                        ),
                        Container(
                            height: 28,
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.all(0),
                            margin: const EdgeInsets.only(top: 10,left: 20,bottom: 10),
                            child:GestureDetector(
                                onTap: (){
                                  if(order!.ptddh=="")
                                  {
                                    return;
                                  }
                                  // Navigator.push(context, PanPageRouteBuilder(builder: (context) {return  ImagePage(order:widget.order);}, transitionDuration: const Duration(milliseconds: 300),
                                  //     popDirection: AxisDirection.left));
                                  Navigator.push(context, PanPageRouteBuilder(builder: (context) {return  ImagePage(order:order!);},
                                      transitionDuration: const Duration(milliseconds: 300),
                                      popDirection: AxisDirection.left));
                                },
                                child: Row(
                                    crossAxisAlignment:    CrossAxisAlignment.center,
                                    children: [
                                      const Spacer(),
                                      Container(
                                        height: 14,
                                        width: 14,
                                        padding: const EdgeInsets.all(0),
                                        margin: const EdgeInsets.only(top: 0,left: 0),
                                        child:  Image.asset("images/btn_thumb.png"),
                                      ),
                                      Container(
                                        height: 26,
                                        width: 60,
                                        padding: const EdgeInsets.all(0),
                                        margin: const EdgeInsets.only(top: 3,left: 10),
                                        child: const Text("提交截图",style: TextStyle(color: Colors.white, fontSize: 14)),
                                      ),
                                      Container(
                                        height: 9,
                                        width: 17,
                                        padding: const EdgeInsets.all(0),
                                        margin: const EdgeInsets.only(top: 0,left: 0),
                                        child:  Image.asset("images/arrow_right.png",color: Colors.white),
                                      ),
                                      const Spacer(),
                                    ]
                                )
                            )
                        ),
                      ]
                  )
              ),
              Container(
                width: MediaQuery.of(context).size.width-30,
                padding: const EdgeInsets.all(0),
                margin: const EdgeInsets.only(top:10,left: 15,right: 15),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top:10),
                      child:  Row(children:  [
                        const Text("订单信息",style: TextStyle(color: Color(0xFF333333),fontWeight: FontWeight.bold, fontSize: 20)),
                        const Spacer(),
                        const Spacer(),
                        const Spacer(),
                        const Spacer(),
                        const Spacer(),
                        Row(
                          children:  [
                            const Text("安全保证金:  ",style: TextStyle(color: Color(0xFF999999), fontSize: 14)),
                            Text("¥${order!.aqbzj}",style: const TextStyle(color: Color(0xFFFF5601), fontSize: 14)),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          children:  [
                            const Text("效率保证金:  ",style: TextStyle(color: Color(0xFF999999), fontSize: 14)),
                            Text("¥${order!.xlbzj}",style: const TextStyle(color: Color(0xFFFF5601), fontSize: 14)),
                          ],
                        )
                      ]),
                    )

                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width-30,
                decoration:  const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                ),
                padding: const EdgeInsets.all(0),
                margin: const EdgeInsets.only(top:10,left: 15,right: 15),
                child: Column(children:  [
                  Container(
                    width: MediaQuery.of(context).size.width-40,
                    margin: const EdgeInsets.only(top:10,left: 10),
                    child: Text(order!.yq,style: const TextStyle(color: Color(0xFF333333),fontWeight:FontWeight.bold, fontSize: 16)),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width-40,
                    margin: const EdgeInsets.only(top:6,left: 10,right: 10),
                      padding: const EdgeInsets.only(bottom: 10),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 0.6, color: Color(0xFFE2E2E2)),
                        ),
                      ),
                    child: Row(
                      children: [
                        Image.asset("images/icon_game.png",width: 15,height: 14.5),
                        Text("  ${order!.yxmc}|${order!.dq}|${order!.qh}",style: const TextStyle(color: Color(0xFF999999), fontSize: 14)),
                      ]
                    )
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width-40,
                    margin: const EdgeInsets.only(top:6,left: 6),
                    child: Row(
                      children:  [
                        const Text("录入时间：",style: TextStyle(color: Color(0xFF333333), fontSize: 14)),
                        Text(order!.kfscsj,style: const TextStyle(color: Color(0xFF999999), fontSize: 14))
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width-40,
                    margin: const EdgeInsets.only(top:6,left: 6),
                    child: Row(
                      children:  [
                        const Text("代练时间：",style: TextStyle(color: Color(0xFF333333), fontSize: 14)),
                        Text("${order!.dlsj}小时",style: const TextStyle(color: Color(0xFF999999), fontSize: 14))
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width-40,
                    margin: const EdgeInsets.only(top:6,left: 10,right: 10,bottom: 10),
                    padding: const EdgeInsets.only(top:10,left: 20,right: 20,bottom: 10),
                    decoration: const BoxDecoration(
                      color:  Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      //交叉轴的布局方式，对于column来说就是水平方向的布局方式
                      crossAxisAlignment: CrossAxisAlignment.center,
                      //就是字child的垂直布局方向，向上还是向下
                      verticalDirection: VerticalDirection.down,
                      children:  [
                        Column(
                          children:  [
                            Text("¥${order!.zc}",style: const TextStyle(color: Color(0xFFFF5201),fontWeight:FontWeight.bold, fontSize: 18)),
                            const Text("发单价格",style: TextStyle(color: Color(0xFF333333), fontSize: 12))
                          ],
                        ),
                        Column(
                          children:  [
                            Text("¥${order!.sr}",style: const TextStyle(color: Color(0xFFFF5201),fontWeight:FontWeight.bold, fontSize: 18)),
                            const Text("接单价格",style: TextStyle(color: Color(0xFF333333), fontSize: 12))
                          ],
                        ),
                        Column(
                          children:  [
                            Text("¥${order!.lr}",style: const TextStyle(color: Color(0xFFFF5201),fontWeight:FontWeight.bold, fontSize: 18)),
                            const Text("订单利润",style: TextStyle(color: Color(0xFF333333), fontSize: 12))
                          ],
                        )
                      ],
                    ),
                  )
                ]
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width-30,
                decoration:  const BoxDecoration(
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(0),
                margin: const EdgeInsets.only(top: 0.6),
                child: Column(children:  [
                  Container(
                    decoration:  const BoxDecoration(
                      color: Colors.white,
                      border:  Border(top: BorderSide(width: 0.6, color: Colors.black12)),
                    ),
                    width: MediaQuery.of(context).size.width-30,
                    margin: const EdgeInsets.all(0),
                    padding: const EdgeInsets.only(top: 10,left: 10),
                    child:  const Text("号主信息",overflow: TextOverflow.ellipsis,style: TextStyle(color: Color(0xFF333333),fontWeight:FontWeight.bold, fontSize: 18)),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width-30,
                    margin: const EdgeInsets.only(top: 6),
                    padding: const EdgeInsets.only(left: 10),
                    height: 30,
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        const Expanded(
                          flex: 20,
                          child: Text("订单来源",style: TextStyle(color: Color(0xFF999999), fontSize: 14)),
                        ),
                        Expanded(
                          flex: 80,
                          child: Text(order!.ddly,textAlign:TextAlign.left,style: const TextStyle(color: Color(0xFF333333), fontSize: 14)),
                        ),
                        Expanded(
                          flex: 10,
                          child: IconButton(onPressed:(){
                            Clipboard.setData(ClipboardData(text:order!.ddly));
                            EasyLoading.showSuccess("已复制到粘贴板");
                          }, icon:const Image(image: AssetImage("images/btn_copy.png"),width: 14,height:14)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width-30,
                    margin: const EdgeInsets.all(0),
                    padding: const  EdgeInsets.only(left: 10),
                    height: 30,
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        const Expanded(
                          flex: 20,
                          child: Text("订单编号",style: TextStyle(color: Color(0xFF999999), fontSize: 14)),
                        ),
                        Expanded(
                          flex: 80,
                          child: Text(order!.ddh,textAlign:TextAlign.left,style: const TextStyle(color: Color(0xFF333333), fontSize: 14)),
                        ),
                        Expanded(
                          flex: 10,
                          child: IconButton(onPressed:(){
                            Clipboard.setData(ClipboardData(text:order!.ddh));
                            EasyLoading.showSuccess("已复制到粘贴板");
                          },
                              icon:const Image(image: AssetImage("images/btn_copy.png"),width: 14,height:14)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width-30,
                    margin: const EdgeInsets.all(0),
                    padding: const  EdgeInsets.only(left: 10),
                    height: 30,
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        const Expanded(
                          flex: 20,
                          child: Text("游戏账号",style: TextStyle(color: Color(0xFF999999), fontSize: 14)),
                        ),
                        Expanded(
                          flex: 80,
                          child: Text(order!.zh,textAlign:TextAlign.left,style: const TextStyle(color: Color(0xFF333333), fontSize: 14)),
                        ),
                        Expanded(
                          flex: 10,
                          child: IconButton(onPressed:(){
                            Clipboard.setData(ClipboardData(text:order!.zh));
                            EasyLoading.showSuccess("已复制到粘贴板");
                          }, icon:const Image(image: AssetImage("images/btn_copy.png"),width: 14,height:14)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width-30,
                    margin: const EdgeInsets.all(0),
                    padding: const  EdgeInsets.only(left: 10),
                    height: 30,
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        const Expanded(
                          flex: 20,
                          child: Text("游戏密码",style: TextStyle(color: Color(0xFF999999), fontSize: 14)),
                        ),
                        Expanded(
                          flex: 80,
                          child: Text(order!.mm,textAlign:TextAlign.left,style: const TextStyle(color: Color(0xFF333333), fontSize: 14)),
                        ),
                        Expanded(
                          flex: 10,
                          child: IconButton(onPressed:(){
                            Clipboard.setData(ClipboardData(text:order!.mm));
                            EasyLoading.showSuccess("已复制到粘贴板");
                          },
                              icon:const Image(image: AssetImage("images/btn_copy.png"),width: 14,height:14))
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width-30,
                    margin: const EdgeInsets.all(0),
                    padding: const  EdgeInsets.only(left: 10),
                    height: 30,
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        const Expanded(
                          flex: 20,
                          child: Text("游戏角色",style: TextStyle(color: Color(0xFF999999), fontSize: 14)),
                        ),
                        Expanded(
                          flex: 80,
                          child: Text(order!.js,textAlign:TextAlign.left,style: const TextStyle(color: Color(0xFF333333), fontSize: 14)),
                        ),
                        Expanded(
                          flex: 10,
                          child: IconButton(onPressed:(){
                            Clipboard.setData(ClipboardData(text:order!.js));
                            EasyLoading.showSuccess("已复制到粘贴板");
                          }, icon:const Image(image: AssetImage("images/btn_copy.png"),width: 14,height:14))
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width-30,
                    margin: const EdgeInsets.all(0),
                    padding: const  EdgeInsets.only(left: 10),
                    height: 30,
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        const Expanded(
                          flex: 20,
                          child: Text("手机号码",style: TextStyle(color: Color(0xFF999999), fontSize: 14)),
                        ),
                        Expanded(
                          flex: 80,
                          child: Text(order!.sj,textAlign:TextAlign.left,style: const TextStyle(color: Color(0xFF333333), fontSize: 14)),
                        ),
                        Expanded(
                          flex: 10,
                          child: IconButton(onPressed:(){
                            Clipboard.setData(ClipboardData(text:order!.sj));
                            EasyLoading.showSuccess("已复制到粘贴板");
                          },
                              icon:const Image(image: AssetImage("images/btn_copy.png"),width: 14,height:14))
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width-30,
                    margin: const EdgeInsets.all(0),
                    padding: const  EdgeInsets.only(left: 10),
                    height: 30,
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        const Expanded(
                          flex: 20,
                          child: Text("买家旺旺",style: TextStyle(color: Color(0xFF999999), fontSize: 14)),
                        ),
                        Expanded(
                          flex: 80,
                          child: Text(order!.ww,textAlign:TextAlign.left,style: const TextStyle(color: Color(0xFF333333), fontSize: 14)),
                        ),
                        Expanded(
                          flex: 10,
                          child: IconButton(onPressed:(){
                            Clipboard.setData(ClipboardData(text:order!.ww));
                            EasyLoading.showSuccess("已复制到粘贴板");
                          },
                              icon:const Image(image: AssetImage("images/btn_copy.png"),width: 14,height:14)
                          )
                        )
                      ]
                    )
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width-30,
                    margin: const EdgeInsets.all(0),
                    padding: const  EdgeInsets.only(left: 10),
                    height: 30,
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        const Expanded(
                          flex: 20,
                          child: Text("订单备注",style: TextStyle(color: Color(0xFF999999), fontSize: 14)),
                        ),
                        Expanded(
                          flex: 80,
                          child: Text(order!.bzxx1,textAlign:TextAlign.left,style: const TextStyle(color: Color(0xFF333333), fontSize: 14)),
                        ),
                        Expanded(
                          flex: 10,
                          child: IconButton(onPressed:(){
                            Clipboard.setData(ClipboardData(text:order!.bzxx1));
                            EasyLoading.showSuccess("已复制到粘贴板");
                          },
                           icon:const Image(image: AssetImage("images/btn_copy.png"),width: 14,height:14)),
                        ),
                      ],
                    ),
                  ),
                ]
                ),
              ),
              Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                height:60,
                padding: const EdgeInsets.only(left: 20,right: 20,top:0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  //交叉轴的布局方式，对于column来说就是水平方向的布局方式
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: widgets,
                ),
              ),
            ]
        )
        )
    );
  }
}
