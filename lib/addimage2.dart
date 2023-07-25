
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lanzhong/model/api_response/list_data.dart';
import 'package:lanzhong/request/request_client.dart';
import 'package:logger/logger.dart';

import 'model/image_url_entity.dart';
import 'model/orders_entity.dart';


class ImagePage extends StatefulWidget {
  final OrdersData order;
  const ImagePage({super.key, required this.order});

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  ScrollController scrollController = ScrollController();
  List<ImageUrlEntity> messages=[];
  TextEditingController textContent= TextEditingController();
  var logger = Logger(printer: PrettyPrinter());
  void loadMessage() async{
    RequestClient requestClient = RequestClient();
    String url = "/Order/GetImages";
    Map<String, dynamic>? formData = {"id": widget.order.id, "ptzt":  widget.order.zt,"ptName":  widget.order.dlpt};
    Map<String, dynamic>? headers={"Content-type":"application/x-www-form-urlencoded"};
    ListData<ImageUrlEntity>? pte = await requestClient.post<ListData<ImageUrlEntity>>(url,data: formData,headers: headers,onError: (e){
      return e.code==0;
    });
    if(pte!=null)
    {
      setState(() {
        messages=pte.data!;
      });
    }
  }
  @override
  void initState() {
    super.initState();
    loadMessage();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 68,
            padding: const EdgeInsets.only(left: 0,top: 32),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/set_banner.png'),
                fit: BoxFit.fill, // 完全填充
              ),
            ),
            child: Row(children: [
              IconButton(onPressed: () {
                Navigator.pop(context);
              }, icon:  Image.asset("images/arrow_left.png",width: 11,height: 18)),
              const Text('订单图片', style: TextStyle(color: Colors.white, fontSize: 16), textAlign: TextAlign.left)
            ]
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height-68,
            padding: const EdgeInsets.all(0),
            margin: const EdgeInsets.only(top: 68,left: 0,right: 0,bottom: 0),
            child:SingleChildScrollView(child: MediaQuery.removePadding(
              removeTop: true, context: context,
              child:ListView.builder(
                  scrollDirection:Axis.vertical,
                  itemCount: messages.length,
                  controller: scrollController,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return  Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFD4EDF8),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      margin: const EdgeInsets.only(top: 10,left: 10,right: 10),
                      padding: const EdgeInsets.all(0),
                      child: Column(children: [
                        Flex(
                          direction: Axis.horizontal,
                          children: <Widget>[
                            Expanded(
                              flex: 6,
                              child: Container(
                                height: 30.0,
                                padding: const EdgeInsets.only(left: 10,top: 6),
                                child:  Text(messages[index].title),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Container(
                                height: 30.0,
                                padding: const EdgeInsets.only(right: 10,top: 6),
                                child: Text(messages[index].createTime),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(10),
                          child:  Image.network(messages[index].imgUrl),
                        )
                      ]),
                    );
                  }
              ) ,
            )),
          ),
        ],
      ),
    );
  }
}
