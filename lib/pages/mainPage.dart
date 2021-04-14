import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intelligent_construction/pages/projectManage.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MainPageState();
  }
}

class MainPageState extends State<MainPage> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('智慧建造-监理端'),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'logout',
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.navigate_next),
            tooltip: '关于软件',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute<void>(
                builder: (BuildContext context) {
                  return Scaffold(
                    appBar: AppBar(
                      title: const Text('关于软件'),
                    ),
                    body: const Center(
                      child: Text(
                        '上海电力大学毕业设计',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  );
                },
              ));
            },
          ),
        ],
      ),
      body: Builder(
        builder: (context) => [
          ProjectManage(),
          Text('工程通信'),
          Text('工单报送'),
        ][_selected],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.build), label: '项目管理'),
          BottomNavigationBarItem(icon: Icon(Icons.comment), label: '工程通信'),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment_rounded), label: '工单报送')
        ],
        onTap: (index) => setState(() {
          _selected = index;
        }),
        currentIndex: _selected,
      ),
    );
  }
}
