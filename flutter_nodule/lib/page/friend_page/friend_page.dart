import 'package:flutter/material.dart';

class FriendPage extends StatefulWidget {
  const FriendPage({Key? key}) : super(key: key);

  @override
  State<FriendPage> createState() => _FriendPageState();
}

// SingleTickerProviderStateMixin是Flutter中的一个mixin，它为State对象提供了一个单个TickerProvider的实现。
// 作用就是当前页的动画还在播放的时候，用户导航到另外一个页面，当前页的动画就没有必要再播放了，反之在页面切换回来的时
// 候动画有可能还要继续播放，它就是来实现这个控制的。
class _FriendPageState extends State<FriendPage>
    with SingleTickerProviderStateMixin {
  final List _tabTitles = ['朋友', '动态'];

  int curPage = 1;

  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    // 添加了一个选项卡切换的监听器
    _tabController =
        TabController(initialIndex: 0, length: _tabTitles.length, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, //去掉右上角debug标签
        home: Scaffold(
            body: Container(
          decoration: const BoxDecoration(color: Colors.black),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 30),
              Container(
                color: Colors.black87,
                child: TabBar(
                    controller: _tabController,
                    //指示器的颜色
                    indicatorColor: const Color(0xffffffff),
                    //tab背景色
                    labelColor: const Color(0xffffffff),
                    tabs: _tabTitles.map((title) {
                      return Tab(
                          child: Text(title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 16)));
                    }).toList()),
              ),
              // Expanded: 可以用于将子组件扩展以填充可用空间，以及根据可用空间的大小调整子组件的尺寸
              Expanded(
                  child: TabBarView(
                // TabBarView 封装了 PageView
                controller: _tabController,
                children: [_buildLatestBlogList(), _buildHotBlogList()],
              ))
            ],
          ),
        )));
  }

  //最新
  Widget _buildLatestBlogList() {
    return const Center(
      child: Text('快去寻找更多可能认识的人吧',
          style: TextStyle(color: Colors.white, fontSize: 16)),
    );
  }

  Widget _buildHotBlogList() {
    return const Center(
      child:
          Text('暂无朋友动态', style: TextStyle(color: Colors.white, fontSize: 16)),
    );
  }
}
