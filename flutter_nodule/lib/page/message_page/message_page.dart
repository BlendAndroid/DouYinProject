import 'package:flutter/material.dart';

import '../../gen/assets.gen.dart';
import '../../widget/t_image.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, //去掉右上角debug标签
        home: Scaffold(
          body: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 10, top: 40, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.add_circle_outline,
                        size: 30, color: Colors.black87),
                    Icon(Icons.flash_on_outlined,
                        size: 30, color: Colors.black87),
                    Icon(Icons.search, size: 30, color: Colors.black87),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Stack(children: [
                          TImage(Assets.image.avatar.path,
                              shape: Shape.CIRCLE, radius: 35),
                          // 相对布局
                          const Positioned(
                            right: 1,
                            bottom: 1,
                            child: Icon(Icons.add_circle,
                                size: 30, color: Colors.red),
                          )
                        ]),
                        const SizedBox(height: 10),
                        const Text(
                          '密友时刻',
                          style: TextStyle(color: Colors.black45, fontSize: 14),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Stack(children: [
                          TImage(Assets.image.review.path,
                              shape: Shape.CIRCLE, radius: 35),
                          // 相对布局
                          const Positioned(
                            right: 1,
                            bottom: 1,
                            child:
                                Icon(Icons.circle, size: 30, color: Colors.red),
                          )
                        ]),
                        const SizedBox(height: 10),
                        const Text(
                          '往日回顾',
                          style: TextStyle(color: Colors.black45, fontSize: 14),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Stack(children: [
                          TImage(Assets.image.setting.path,
                              shape: Shape.CIRCLE, radius: 35),
                        ]),
                        const SizedBox(height: 10),
                        const Text(
                          '状态设置',
                          style: TextStyle(color: Colors.black45, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const ListTile(
                leading: Icon(
                  Icons.people,
                  size: 30,
                  color: Colors.blue,
                ),
                title: Text("新朋友",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                trailing: Icon(Icons.arrow_forward_ios_rounded),
              ),
              const ListTile(
                leading: Icon(
                  Icons.notification_add_sharp,
                  size: 30,
                  color: Colors.pinkAccent,
                ),
                title: Text("互动消息",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                trailing: Icon(Icons.arrow_forward_ios_rounded),
              ),
              const ListTile(
                leading: Icon(
                  Icons.speaker_group_sharp,
                  size: 30,
                  color: Colors.green,
                ),
                title: Text("系统通知",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                trailing: Icon(Icons.arrow_forward_ios_rounded),
              ),
            ],
          ),
        ));
  }
}
