import 'dart:ui';

import 'package:douyin_flutter_plugin/player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import 'channel_util.dart';
import 'mc_router.dart';

MCRouter router = MCRouter();

// 一个Flutter引擎,只有一个main函数,所以这里的main函数是唯一的入口
void main() {
  runApp(const MyApp());

  init();
}

String sdcardPath =
    '/storage/emulated/0/Android/data/com.blend.douyinproject/files';

init() {
  // 初始化页面路由，获取Native传递的参数，放入路由表
  print('FlutterLog- init route is : ${window.defaultRouteName}');
  router.push(name: window.defaultRouteName);

  // 初始化sdcard目录
  getExternalStorageDirectory().then((value) {
    sdcardPath = value?.path ?? sdcardPath;
    // Player.setCachePath(sdcardPath);
    print('FlutterLog- sdcard path: $sdcardPath');
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ChannelUtil.methodChannel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'popRoute':
          router.popRoute();
          break;
      }
    });

    // GetX改造步骤：1、修改MaterialApp成GetMaterialApp
    return GetMaterialApp(
      debugShowCheckedModeBanner: false, //去掉右上角debug标签
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.blue,
      ),
      home: Router(
        routerDelegate: router,
        // 返回按钮的处理
        backButtonDispatcher: RootBackButtonDispatcher(),
      ),
    );
  }
}
