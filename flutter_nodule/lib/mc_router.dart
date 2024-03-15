import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_nodule/channel_util.dart';
import 'package:flutter_nodule/page/friend_page/friend_page.dart';
import 'package:flutter_nodule/page/message_page/message_page.dart';
import 'package:flutter_nodule/page/mine_page/mine_page.dart';

import 'gen/assets.gen.dart';
import 'page/camera_page/camera_page.dart';
import 'page/player_page/player_page.dart';
import 'widget/photo_picker.dart';

/// 路由管理类
/// 在Flutter中，使用路由这个词来表示App中的页面，路由栈也就是页面栈。2.0提出的这个Page类，实际上就相当于是一个路由的描述文件。
/// Flutter中的所谓Widget就是一种配置描述，而Element类就根据这个描述生成的。同理，Page也是一种描述，用于生成真正的路由对象。
/// 理解了这一点，就会明白，Navigator2.0不仅没有让路由管理更复杂，反而更简单了。只要操作这个Page列表，相应的路由栈就会感知到，
/// 自动发生变化。想要哪个页面显示，只需要把它放置到List的最后一个元素位置即可。Navigator2.0就是把原来对形同黑盒子的路由栈操
/// 作变成了一个对列表List的操作。我们想要改变路由栈中页面的先后顺序，只需要修改List<Page>中的元素位置。
/// Page: Page类本身继承自RouteSettings类，这说明它确实就是一个路由配置文件。它本身是一个抽象类，不能实例化，找到了它的两个直接实现类：
/// 一个是Android的Material风格，一个是iOS的Cupertino风格。
class MCRouter extends RouterDelegate<List<RouteSettings>>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<List<RouteSettings>> {
  static const String minePage = '/mine';
  static const String photoPicker = '/photo_picker';
  static const String playerPage = '/player';
  static const String cameraPage = '/camera';
  static const String messagePage = '/message';
  static const String friendPage = '/friend';

  static const String key = 'key';
  static const String value = 'value';

  static const String key_url = 'url';
  static const String key_height = 'height';
  static const String key_width = 'width';

  final List<Page> _pages = [];

  late Completer<Object?> _boolResultCompleter;

  // 创建了Navigator作为路由的管理者，并设置了两个主要参数pages和onPopPage，其中pages是一个
  // 存放Page对象的列表；当路由被pop时，onPopPage会被回调，可在此处理路由退栈的逻辑。
  // todo: WillPopScope在这里也不起作用,不知道是什么原因,只能采用接口回调的方式了
  @override
  Widget build(BuildContext context) {
    return Navigator(key: navigatorKey, pages: _pages, onPopPage: _onPopPage);
  }

  // todo: 采用下面这种写法,navigatorKey.currentContext就不为Null,但是集成到主工程,导航就不起效果了
  // 下面这种写法是不对的,每次都会造成界面重新建立
  // final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  // navigatorKey也是PopNavigatorRouterDelegateMixin的一个属性，用于获取当前的NavigatorState对象。
  @override
  GlobalKey<NavigatorState> get navigatorKey => GlobalKey<NavigatorState>();

  @override
  Future<void> setNewRoutePath(List<RouteSettings> configuration) async {}

  // 自定义退栈逻辑: backButtonDispatcher 发出回退按钮事件时，会调用 RouterDelegate 的 popRoute() 方法，
  // 由混入的 PopNavigatorRouterDelegateMixin 实现。
  @override
  Future<bool> popRoute({Object? params}) {
    if (params != null) {
      _boolResultCompleter.complete(params);
    }
    ChannelUtil.popRouteNumber(_pages.length);
    if (_canPop()) {
      _pages.removeLast();
      // 通知路由栈，Page列表已经修改了
      notifyListeners();
      return Future.value(true);
    }
    return _confirmExit();
  }

  bool _onPopPage(Route route, dynamic result) {
    if (!route.didPop(result)) return false;

    if (_canPop()) {
      _pages.removeLast();
      return true;
    } else {
      return false;
    }
  }

  // 判断page栈长度，为空则即将退出App；不为空则返回true表示页面关闭
  bool _canPop() {
    return _pages.length > 1;
  }

  // replace方法，用于替换当前页面，参数name表示页面名称，arguments表示页面参数
  void replace({required String name, dynamic arguments}) {
    if (_pages.isNotEmpty) {
      _pages.removeLast();
    }
    push(name: name, arguments: arguments);
  }

  // push方法，用于打开新页面，参数name表示页面名称，arguments表示页面参数
  Future<Object?> push({required String name, dynamic arguments}) async {
    _boolResultCompleter = Completer<Object?>();
    _pages.add(_createPage(RouteSettings(name: name, arguments: arguments)));
    notifyListeners();
    return _boolResultCompleter.future;
  }

  // 创建页面Page，通过RouteSettings给页面的构造方法传参
  MaterialPage _createPage(RouteSettings routeSettings) {
    Widget page;

    // 这是一个Object对象，可以是任意类型，这里用于传递参数
    var args = routeSettings.arguments;

    switch (routeSettings.name) {
      case minePage:
        page = const MinePage();
        break;
      case photoPicker:
        String? url;
        String height = '';
        String width = '';

        if (args is Map<String, String>) {
          url = args[MCRouter.key_url];
          height = args[MCRouter.key_height] ?? height;
          width = args[MCRouter.key_width] ?? width;
        }

        page = PhotoPickerPage(url ?? Assets.image.defaultPhoto.keyName);
        break;
      case playerPage:
        page = PlayerPage(routeSettings.arguments?.toString() ?? '');
        break;
      case cameraPage:
        page = const CameraPage();
        break;
      case messagePage:
        page = const MessagePage();
        break;
      case friendPage:
        page = const FriendPage();
        break;
      default:
        page = const Scaffold();
    }
    // 创建Material风格的Page
    return MaterialPage(
        child: page,
        key: Key(routeSettings.name!) as LocalKey,
        name: routeSettings.name,
        arguments: routeSettings.arguments);
  }

  Future<bool> _confirmExit() async {

    if (navigatorKey.currentContext == null) {
      return true;
    }
    // showDialog方法，用于打开对话框，参数context表示上下文，builder表示对话框构造器
    final result = await showDialog<bool>(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text('确认退出吗'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('取消')),
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('确定'))
          ],
        );
      },
    );
    return result ?? true;
  }
}
