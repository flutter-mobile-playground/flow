import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flow',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 73),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late AnimationController menuAnimation;
  late IconData _lastIconClicked;

  final List<IconData> _menuItems = <IconData>[
    Icons.home,
    Icons.new_releases,
    Icons.notifications,
    Icons.settings,
    Icons.menu,
  ];

  @override
  void initState() {
    menuAnimation = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _lastIconClicked = _menuItems[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flow'),
      ),
      body: Center(
        child: Flow(
          delegate: FlowMenuDelegate(
            menuAnimation: menuAnimation,
          ),
          children: _menuItems
              .map<Widget>(
                (IconData icon) => Padding(
                  padding: const EdgeInsets.all(8),
                  child: FloatingActionButton(
                    backgroundColor: _lastIconClicked == icon ? Colors.orange : Colors.grey,
                    splashColor: Colors.orange,
                    onPressed: () {
                      if (icon != Icons.menu) {
                        setState(() {
                          _lastIconClicked = icon;
                        });
                      }
                      menuAnimation.status == AnimationStatus.completed ? menuAnimation.reverse() : menuAnimation.forward();
                    },
                    child: Icon(icon),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class FlowMenuDelegate extends FlowDelegate {
  final Animation<double> menuAnimation;

  FlowMenuDelegate({required this.menuAnimation}) : super(repaint: menuAnimation);

  @override
  void paintChildren(FlowPaintingContext context) {
    double dx = 0.0;
    for (int i = 0; i < context.childCount; i++) {
      dx = context.getChildSize(i)!.width * i;
      context.paintChild(
        i,
        transform: Matrix4.translationValues(dx * menuAnimation.value, 0, 0),
      );
    }
  }

  @override
  bool shouldRepaint(FlowMenuDelegate oldDelegate) {
    return menuAnimation != oldDelegate.menuAnimation;
  }
}
