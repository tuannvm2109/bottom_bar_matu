import 'package:flutter/material.dart';

import 'package:bottom_bar_matu/bottom_bar_matu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Bottom Bar Bubble'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _index = 0;
  final PageController controller = PageController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      bottomNavigationBar: BottomBarBubble(
        selectedIndex: _index,
        items: [
          BottomBarBubbleItem(
            iconData: Icons.home,
            // label: 'Home',
          ),
          BottomBarBubbleItem(
            iconData: Icons.chat,
            // label: 'Chat',
          ),
          BottomBarBubbleItem(
            iconData: Icons.notifications,
            // label: 'Notification',
          ),
          BottomBarBubbleItem(
            iconData: Icons.calendar_month,
            // label: 'Calendar',
          ),
          BottomBarBubbleItem(
            iconData: Icons.settings,
            // label: 'Setting',
          ),
        ],
        onSelect: (index) {
          controller.jumpToPage(index);
        },
      ),
      body: PageView(
        controller: controller,
        children: const <Widget>[
          Center(
            child: Text('First Page'),
          ),
          Center(
            child: Text('Second Page'),
          ),
          Center(
            child: Text('Third Page'),
          ),
          Center(
            child: Text('Four Page'),
          ),
          Center(
            child: Text('Five Page'),
          ),
        ],
      ),
    );
  }
}
