
import 'dart:io' show Platform;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lanzhong/publishpage.dart';
import 'package:lanzhong/request/request_client.dart';
import 'package:lanzhong/settingpage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:r_upgrade/r_upgrade.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_netcore/msgpack_hub_protocol.dart';
import 'PanPage.dart';
import 'PlatformEdit.dart';
import 'applyinvoke.dart';
import 'event_bus.dart';
import 'generated/l10n.dart';
import 'homepage.dart';
import 'model/chat_message_entity.dart';
import 'model/version_entity.dart';
import 'mypage.dart';
import 'orderpage.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:logging/logging.dart';
enum UpgradeMethod {
  all,
  hot,
  increment,
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const MaterialColor redYellow = MaterialColor(
    _bluePrimaryValue,
    <int, Color>{
      50: Color(0xFFE3F2FD),
      100: Color(0xFFFFBC39),
      200: Color(0xFFFFB837),
      300: Color(0xFFBF7A21),
      400: Color(0xFFBD6B19),
      500: Color(0xFFFF891D),
      600: Color(0xFFF87313),
      700: Color(0xFFFF6A0D),
      800: Color(0xFFFF5C06),
      900: Color(0xFFFF5100),
    },
  );
  static const int _bluePrimaryValue = 0xFFFF891D;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: ThemeData(
        // This is the theme of your application.
        platform: TargetPlatform.iOS,
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: redYellow,
      ),
      routes:{
          "/home":(context) => const MyApp(),
          "set_page":(context) => const SettingPage(),
          "invoke_page":(context) => const InvokePage(aqbzj: 0,xlbzj: 0,tbid: "",dlzt: "",ptName: ""),
          "plat_page":(context) =>  const PlatformPage(findex: -1,ptid: "0"),
      },
      home: const MainPage(),
      //builder: EasyLoading.init(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".


  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>  with TickerProviderStateMixin{
  int? downloadId;
  int? lastId;
  DownloadStatus? lastStatus;
  RUpgradeInstallType installType = RUpgradeInstallType.normal;
  NotificationVisibility notificationVisibility = NotificationVisibility.VISIBILITY_VISIBLE;
  NotificationStyle notificationStyle = NotificationStyle.planTime;
  UpgradeMethod? upgradeMethod;
  late String appName;
  late String packageName;
  late String version;
  late String buildNumber;
  late  PermissionHandlerPlatform _permissionHandler = PermissionHandlerPlatform.instance;
  // static const permissions = [Permissions.CAMERA,Permissions.READ_EXTERNAL_STORAGE,Permissions.WRITE_EXTERNAL_STORAGE];
  // static const permissionGroup = [PermissionGroup.DataNetwork,PermissionGroup.Camera,PermissionGroup.MediaLibrary,PermissionGroup.Photos];
  // late FlutterEasyPermission _easyPermission;
  Future<VersionEntity?> getServerVersion()  async {
    String url = "/Home/GetVersion";
    RequestClient requestClient = RequestClient();
    VersionEntity? vet= await requestClient.get<VersionEntity>(url,onError: (e){
      return e.code==0;
    });
    return vet;
  }

  void _listenForPermissionStatus() async {
    String os = Platform.operatingSystem; //in your code
    if(os=="android")
    {
      final status0 = await _permissionHandler.checkPermissionStatus(Permission.manageExternalStorage);
      if(status0.isDenied)
      {
        if (await Permission.manageExternalStorage.request().isGranted) {

        }
        else
        {
          debugPrint("android授权失败:manageExternalStorage");
        }
      }
      final status1 = await _permissionHandler.checkPermissionStatus(Permission.storage);
      if(status1.isDenied)
      {
        if (await Permission.storage.request().isGranted) {

        }
        else
        {
          debugPrint("android授权失败:storage");
        }
      }
      final status2 = await _permissionHandler.checkPermissionStatus(Permission.camera);
      if(status2.isDenied)
      {
        if (await Permission.camera.request().isGranted) {

        }
        else
        {
          debugPrint("android授权失败:camera");
        }
      }
    }
    if(os=="ios")
   {
     final status2 = await _permissionHandler.checkPermissionStatus(Permission.camera);
     if(status2.isDenied)
     {
       if (await Permission.camera.request().isGranted) {

       }
       else
       {
         debugPrint("android授权失败:camera");
       }
     }
     final status3 = await _permissionHandler.checkPermissionStatus(Permission.mediaLibrary);
     if(status3.isDenied)
     {
       if (await Permission.mediaLibrary.request().isGranted) {

       }
       else
       {
         debugPrint("android授权失败:mediaLibrary");
       }
     }
     final status4 = await _permissionHandler.checkPermissionStatus(Permission.photos);
     if(status4.isDenied)
     {
       if (await Permission.photos.request().isGranted) {

       }
       else
       {
         debugPrint("android授权失败:mediaLibrary");
       }
     }
   }
  }
  final pageController = PageController();
  int ztIndex=0;
  bool isShowUpdate=true;
  bool isShowProgress=false;
  late BuildContext dialogContext;
  final progressNotifier = ValueNotifier<double?>(0);
  final progressNotifier2 = ValueNotifier<String>("忽略此版本");
  final hubConnection = HubConnectionBuilder()
      .withUrl("https://appapi.lzsterp.com/LzHub", options: HttpConnectionOptions(logger:  Logger("SignalR - transport")))
      .withHubProtocol(MessagePackHubProtocol())
      .configureLogging(Logger("SignalR - hub"))
      .build();
  void initSignalR() async {

    try {
      hubConnection.onclose(({error}) {
        debugPrint("Connection Closed");
      });
      hubConnection.onreconnecting(({error}) {
        debugPrint("onReconnecting called");
      });
      hubConnection.onreconnected(({connectionId}) {
        debugPrint("onReconnected called");
      });
      if (hubConnection.state != HubConnectionState.Connected)
      {
        await hubConnection.start();
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        ChatMessageEntity cm=ChatMessageEntity();
        cm.id=int.parse(prefs.getString("yhid")!);
        cm.ygnc=prefs.getString("userName")!;
        cm.ygzh=prefs.getString("userName")!;
        cm.os= Platform.operatingSystem;
        await hubConnection.invoke("initScene",args:<Object>[cm.toJson()]);
      }

    } catch (e) {
      debugPrint(e.toString());
    }
  }
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    Logger.root.level = Level.ALL;
   // Writes the log messages to the console
    Logger.root.onRecord.listen((LogRecord rec) {
      debugPrint('${rec.level.name}: ${rec.time}: ${rec.message}');
    });
    initSignalR();

    bus.on("pvChange", (arg) {
      pageController.jumpToPage(2);
      ztIndex=int.parse(arg.toString());
      debugPrint("home_doAction_index:$arg");
      Future.delayed(const Duration(milliseconds: 500), () {
        bus.emit("doAction", arg);
      });
    });
    String osPlat= Platform.operatingSystem;
    if(osPlat=="android"){
      RUpgrade.setDebug(true);
      RUpgrade.stream.listen((DownloadInfo info){
        lastStatus=info.status;
        debugPrint("info-percent111111111:${info.path}");
        if(info.status==DownloadStatus.STATUS_RUNNING)
        {
          debugPrint("info-percent111111111:${info.percent!/100}");
          setState(() {
            progressNotifier.value= info.percent!/100;
            progressNotifier2.value="${info.percent}%";
          });
        }
        if(info.status==DownloadStatus.STATUS_SUCCESSFUL)
        {
          Navigator.pop(dialogContext);
          RUpgrade.install(lastId!);
        }
      });
    }

    _listenForPermissionStatus();
   //  _easyPermission = FlutterEasyPermission()
   //    ..addPermissionCallback(
   //        onGranted: (requestCode,perms,perm) {
   //          debugPrint("android获得授权:$perms");
   //          debugPrint("iOS获得授权:$perm");
   //
   //        },
   //        onDenied: (requestCode,perms,perm,isPermanent){
   //          if(isPermanent){
   //            FlutterEasyPermission.showAppSettingsDialog(title: "Camera");
   //          }else{
   //            debugPrint("android授权失败:$perms");
   //            debugPrint("iOS授权失败:$perm");
   //          }
   //        },
   //        onSettingsReturned: (){
   //          FlutterEasyPermission.has(perms: permissions,permsGroup: []).then(
   //                  (value) => value
   //                  ?debugPrint("已获得授权:$permissions")
   //                  :debugPrint("未获得授权:$permissions")
   //          );
   //        });
   // Future<bool> ftb= FlutterEasyPermission.has(perms: permissions,permsGroup: permissionGroup);
   // ftb.then((value) {
   //   if(value==false)
   //   {
   //     FlutterEasyPermission.request(perms: permissions,permsGroup: permissionGroup,rationale:"需要这些权限");
   //   }
   // });

    Future<PackageInfo> packageInfo =  PackageInfo.fromPlatform();
    packageInfo.then((fpi) async{
      appName = fpi.appName;
      packageName = fpi.packageName;
      version = fpi.version;
      buildNumber = fpi.buildNumber;
      // debugPrint("2当前appName:$appName");
      // debugPrint("2当前packageName:$packageName");
      // debugPrint("2当前version:$version");
      // debugPrint("2当前buildNumber:$buildNumber");
      VersionEntity? futureVer=await getServerVersion();
      if(futureVer!.versionCode>int.parse(buildNumber))
      {
        String osPlat= Platform.operatingSystem;
        if(osPlat=="android")
        {
          if(context.mounted) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext  ctx) {
                dialogContext=ctx;
                return WillPopScope(
                    onWillPop: () async => false,
                    child:StatefulBuilder(builder: (BuildContext context, void Function(void Function()) setState) {
                      return Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(6.0)),
                          child: Container(
                            width: 260,
                            height: 320,
                            padding: const EdgeInsets.all(0),
                            margin: const EdgeInsets.all(0),
                            child: Column(children: [
                              Image.asset("images/img_update.png"),
                              Container(
                                height: 28,
                                width: MediaQuery.of(ctx).size.width,
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 20),
                                margin: const EdgeInsets.only(top:10),
                                child:  Text("是否升级到${futureVer.versionName}版本？",style: const TextStyle(color:Colors.black,fontSize: 16)),
                              ),
                              Container(
                                width: MediaQuery.of(ctx).size.width,
                                alignment: Alignment.topLeft,
                                height: 60,
                                padding: const EdgeInsets.only(left: 20),
                                margin: const EdgeInsets.only(top:10),
                                child: Text(futureVer.versionContent,style: const TextStyle(color:Color(0xFF999999),fontSize: 14)),
                              ),
                              Visibility(
                                  visible: isShowProgress,
                                  maintainState : true,
                                  child:  Container(
                                    //限制进度条的高度
                                    height: 6.0,
                                    //限制进度条的宽度
                                    width: MediaQuery.of(ctx).size.width,
                                    padding: const EdgeInsets.only(left: 0),
                                    margin: const EdgeInsets.only(top:10,left: 10,right: 10),
                                    child: ValueListenableBuilder<double?>(
                                      valueListenable:progressNotifier,
                                      builder: (context, percent, child) {
                                        return LinearProgressIndicator(
                                            value: percent,
                                            backgroundColor: Colors.grey,
                                            valueColor:  const AlwaysStoppedAnimation<Color>(Color(0xFF5363F7))
                                        );
                                      },
                                    )
                                    ,
                                  )
                              ),
                              Visibility(visible: isShowUpdate,
                                  child:  Container(
                                    width: MediaQuery.of(ctx).size.width,
                                    alignment: Alignment.center,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(9),
                                      gradient: const LinearGradient(colors: [
                                        Color(0xffFFBF3A),
                                        Color(0xffFF5100),
                                      ]),
                                    ),
                                    padding: const EdgeInsets.only(left: 0),
                                    margin: const EdgeInsets.only(top:10,left: 10,right: 10),
                                    child: ElevatedButton(
                                        onPressed: () async {
                                          setState(() {
                                            isShowUpdate=false;
                                            isShowProgress=true;
                                          });

                                          downloadId = await RUpgrade.upgrade(
                                              'https://appapi.lzsterp.com/app-release.apk',
                                              fileName: 'app-release.apk',
                                              installType: installType,
                                              notificationStyle: notificationStyle,
                                              notificationVisibility: notificationVisibility,
                                              useDownloadManager: false);
                                          upgradeMethod = UpgradeMethod.all;
                                        },
                                        style: ButtonStyle(
                                          //去除阴影
                                          elevation: MaterialStateProperty.all(0),
                                          //将按钮背景设置为透明
                                          backgroundColor: MaterialStateProperty.all(Colors.transparent),
                                        ),
                                        child: const Text("立即升级",
                                            style: TextStyle(color: Colors.white, fontSize: 12.8),
                                            textAlign: TextAlign.center)),
                                  )),
                              GestureDetector(
                                  onTap: (){
                                    if(isShowUpdate)
                                    {
                                      Navigator.pop(ctx);
                                    }
                                  },
                                  child: Container(
                                    width: MediaQuery.of(ctx).size.width,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.all(0),
                                    margin: const EdgeInsets.only(top:10),
                                    child:  ValueListenableBuilder<String>(
                                      valueListenable:progressNotifier2,
                                      builder: (context, percentLabel, child) {
                                        return Text(percentLabel,style: const TextStyle(color:Color(0xFF999999),fontSize: 13));
                                      },
                                    )
                                    ,
                                  )
                              )
                            ]),
                          )
                      );
                    }));
              },
            );

          }
        }
      }
    });
  }
  @override
  void dispose() {
    super.dispose();
   if(hubConnection.state == HubConnectionState.Connected)
   {
     hubConnection.stop();
   }
  }
  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  int _currentIndex = 0;
  final List<Widget> pageList = [
    const HomePage(),
    const PublishPage(),
    const OrderPage(),
    const MyPage(),
  ];
  final List<BottomNavigationBarItem> barItem = [
    const BottomNavigationBarItem(icon: Image(image: AssetImage("images/nav/home.png"),width: 20,height:20 ),activeIcon:Image(image: AssetImage("images/nav/home_over.png"),width: 21,height:20),label: "首页"),
    const BottomNavigationBarItem(icon: Image(image: AssetImage("images/nav/pub.png"),width: 20,height:20),activeIcon:Image(image: AssetImage("images/nav/pub_over.png"),width: 16,height:20),label: "发单"),
    const BottomNavigationBarItem(icon: Image(image: AssetImage("images/nav/order.png"),width: 18,height:20),activeIcon:Image(image: AssetImage("images/nav/order_over.png"),width: 19,height:20),label: "订单"),
    const BottomNavigationBarItem(icon: Image(image: AssetImage("images/nav/my.png"),width: 20,height:20),activeIcon:Image(image: AssetImage("images/nav/my_over.png"),width: 17,height:20),label: "我的")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics:const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
        children: pageList,
      ),
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) {

          if(index==1)
          {
             Navigator.push(context, PanPageRouteBuilder(builder: (context) {return  const PublishPage();}, transitionDuration: const Duration(milliseconds: 300),
                popDirection: AxisDirection.left));
          }
          else
          {
            pageController.jumpToPage(index);
            if(index==2)
            {
              Future.delayed(const Duration(milliseconds: 600), () {
                bus.emit("doAction", ztIndex);
              });
            }
          }
        },
        currentIndex: _currentIndex,
        items: barItem,
        iconSize: 12,
        backgroundColor: const Color(0xFFFFFFFF),
        fixedColor: const Color(0xFF333333),
        selectedFontSize: 12,
        unselectedFontSize: 12,
        type: BottomNavigationBarType.fixed,
      )
    );
  }
}
