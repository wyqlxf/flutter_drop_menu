import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_drop_menu/flutter_drop_down_menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'flutter_drop_menu'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /// The list of curves.
  List<Map<String, dynamic>> curves = [];

  /// The default curve.
  Curve curve = Curves.linear;

  /// The selected curve.
  String selectCurve = '';

  /// The default color of the header.
  Color defaultColor = Colors.black;

  /// The color to use for the selected header.
  Color selectColor = Colors.black;

  /// The default font size of the header.
  double defaultFontSize = 14;

  /// The font size to use for the selected header.
  double selectFontSize = 14;

  /// The default icon size of the header.
  double defaultIconSize = 24;

  /// The icon size to use for the selected header.
  double selectIconSize = 24;

  /// The height of the header.
  double headerHeight = 48;

  /// The background color of the header.
  Color headerBackgroundColor = Colors.white;

  /// The alignment of the header.
  MainAxisAlignment headerMainAxisAlignment = MainAxisAlignment.spaceAround;

  /// The index of the selected effect.
  int selectEffectIndex = -1;

  /// The value notifier to use for the selected price.
  final ValueNotifier<int> selectPriceIndex = ValueNotifier<int>(-1);

  /// The value notifier to use for the selected district.
  final ValueNotifier<String> selectDistrict = ValueNotifier<String>('');

  /// The value notifier to use for the selected station.
  final ValueNotifier<String> selectStation = ValueNotifier<String>('');

  /// The controller to use to control the menu.
  final DropdownController _controller = DropdownController();

  /// Show the menu.
  void _showMenu(int index) {
    if (_controller.index == index && _controller.isShow) {
      _hideMenu();
    } else {
      _controller.show(index);
    }
  }

  /// Hide the menu.
  void _hideMenu({int? index, bool isSelect = false, String? title}) {
    _controller.hide(index: index, isSelect: isSelect, title: title);
  }

  /// The callback that is called when the outside region is tapped.
  void _outsideOnTap() {
    _hideMenu();
    // Execute your code logic here.
    // If there is no code logic to execute, there is no need to declare this callback function.
  }

  @override
  void initState() {
    initCurves();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Stack(
        children: [dropDownMenu()],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _selectCurve,
        tooltip: 'Select Curve',
        child: const Text('动画\n曲线'),
      ),
    );
  }

  /// The drop-down menu.
  Widget dropDownMenu() {
    // The title of the drop-down menu.
    const List<String> titles = ['地区', '价格', '效果', '筛选'];
    final int length = titles.length;
    //  The header of the drop-down menu.
    final List<Widget> header = List.generate(
      length,
      (index) {
        String title = titles[index];
        if (index == length - 1) {
          // Use custom headers.
          return customHeaderFilter(title, onTap: () {
            _showMenu(index);
          });
        } else {
          // Use built-in headers.
          return DropDownHeader(
            index: index,
            title: title,
            curve: curve,
            textStyle: TextStyle(
              color: defaultColor,
              fontSize: defaultFontSize,
            ),
            selectTextStyle:
                TextStyle(color: selectColor, fontSize: selectFontSize),
            iconColor: defaultColor,
            selectIconColor: selectColor,
            iconSize: defaultIconSize,
            selectIconSize: selectIconSize,
            onTap: (index) {
              _showMenu(index);
            },
          );
        }
      },
    );
    // The menu of the drop-down menu.
    final List<Widget> menus = [
      customMenuRegion(),
      customMenuPrice(),
      customMenuEffect(),
      customMenuFilter()
    ];
    return DropDownMenu(
      header: header,
      menus: menus,
      curve: curve,
      controller: _controller,
      headerHeight: headerHeight,
      headerBackgroundColor: headerBackgroundColor,
      headerMainAxisAlignment: headerMainAxisAlignment,
      outsideOnTap: _outsideOnTap,
      animTypes: const [
        AnimationType.none,
        AnimationType.topToBottom,
        AnimationType.fade,
        AnimationType.rightToLeft,
      ],
    );
  }

  /// Select the curve.
  void _selectCurve() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SizedBox(
            width: 200,
            height: 328,
            child: SimpleDialog(
              titlePadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.zero,
              title: const Text('选择动画曲线'),
              children: curves
                  .map(
                    (map) => SimpleDialogOption(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        map['alias'],
                        style: TextStyle(
                            color: selectCurve == map['name']
                                ? Colors.blue
                                : Colors.black),
                      ),
                      onPressed: () {
                        setState(() {
                          curve = map['curve'];
                          selectCurve = map['name'];
                        });
                        Navigator.pop(context);
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      },
    );
  }

  /// Initialize curve data.
  ///
  /// See also:
  ///
  ///  * [Curves], Learn more about animation curves.
  initCurves() {
    curves.clear();
    curves.add({'name': 'linear', 'alias': '线性曲线', 'curve': Curves.linear});
    curves.add({'name': 'decelerate', 'alias': '减速曲线', 'curve': Curves.decelerate});
    curves.add({'name': 'easeIn', 'alias': '缓慢开始曲线', 'curve': Curves.easeIn});
    curves.add({'name': 'easeOut', 'alias': '缓慢结束曲线', 'curve': Curves.easeOut});
    curves.add({'name': 'easeInOut', 'alias': '缓慢开始和结束曲线', 'curve': Curves.easeInOut});
    curves.add({'name': 'fastOutSlowIn', 'alias': '快出慢进曲线', 'curve': Curves.fastOutSlowIn});
    curves.add({'name': 'bounceIn', 'alias': '弹跳进入曲线', 'curve': Curves.bounceIn});
    curves.add({'name': 'bounceOut', 'alias': '弹跳退出曲线', 'curve': Curves.bounceOut});
    curves.add({'name': 'elasticIn', 'alias': '弹性进入曲线', 'curve': Curves.elasticIn});
    curves.add({'name': 'elasticOut', 'alias': '弹性退出曲线', 'curve': Curves.elasticOut});
  }

  @override
  void dispose() {
    _controller.dispose();
    selectPriceIndex.dispose();
    selectDistrict.dispose();
    selectStation.dispose();
    super.dispose();
  }

  /// *************************** Custom header. *************************** ///
  Widget customHeaderFilter(String text, {GestureTapCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Text(text),
          const SizedBox(width: 2),
          Icon(
            Icons.filter_alt_outlined,
            size: 16,
            color: defaultColor,
          ),
        ],
      ),
    );
  }

  /// **************************** Custom menu. **************************** ///

  /// Custom menu region.
  Widget customMenuRegion() {
    List<String> district = [
      '罗湖区',
      '福田区',
      '南山区',
      '龙岗区',
      '宝安区',
      '盐田区',
      '光明区',
      '坪山区',
      '大鹏新区'
    ];
    List<String> station = [
      '地王',
      '黄贝岭',
      '万象城',
      '莲塘',
      '新秀',
      '银湖',
      '洪湖',
      '罗湖口岸',
      '布心',
      '翠竹',
      '东门',
      '笋岗',
      '黄木岗'
    ];
    return Container(
      width: double.infinity,
      height: 386,
      color: Colors.white,
      alignment: Alignment.topLeft,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    color: Colors.grey[200],
                    child: ListView.builder(
                      itemCount: district.length,
                      itemBuilder: (context, position) {
                        return InkWell(
                          onTap: () {
                            selectDistrict.value = district[position];
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: ValueListenableBuilder<String>(
                              valueListenable: selectDistrict,
                              builder: (BuildContext context, String value,
                                  Widget? child) {
                                return Text(
                                  district[position],
                                  style: TextStyle(
                                    color: value == district[position]
                                        ? Colors.blue
                                        : Colors.black,
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: ListView.builder(
                    itemCount: station.length,
                    itemBuilder: (context, position) {
                      return InkWell(
                        onTap: () {
                          selectStation.value = station[position];
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          child: ValueListenableBuilder<String>(
                            valueListenable: selectStation,
                            builder: (BuildContext context, String value,
                                Widget? child) {
                              return Text(
                                station[position],
                                style: TextStyle(
                                  color: value == station[position]
                                      ? Colors.blue
                                      : Colors.black,
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.withOpacity(0.3)),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: InkWell(
                    onTap: () {
                      selectDistrict.value = '';
                      selectStation.value = '';
                    },
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      margin: const EdgeInsets.all(8),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE0E0E0),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: const Text('重置'),
                    ),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: InkWell(
                    onTap: () {
                      if (selectStation.value.isNotEmpty) {
                        _hideMenu(
                            index: 0,
                            isSelect: true,
                            title: selectStation.value);
                      } else if (selectDistrict.value.isNotEmpty) {
                        _hideMenu(
                            index: 0,
                            isSelect: true,
                            title: selectDistrict.value);
                      } else {
                        _hideMenu(index: 0, isSelect: false);
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      margin: const EdgeInsets.all(8),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: const Text('确认',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  /// Custom menu price.
  Widget customMenuPrice() {
    return Container(
      width: double.infinity,
      height: 240,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: ListView.builder(
        itemCount: 6,
        itemBuilder: (context, position) {
          String text = '10000元以下';
          switch (position) {
            case 0:
              text = '10000元以下';
              break;
            case 1:
              text = '10000-20000元';
              break;
            case 2:
              text = '20000-30000元';
              break;
            case 3:
              text = '30000-50000元';
              break;
            case 4:
              text = '50000-100000元';
              break;
            case 5:
              text = '100000-999999元';
              break;
          }
          return InkWell(
            onTap: () {
              selectPriceIndex.value = position;
              _hideMenu(index: 1, isSelect: true);
            },
            child: Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ValueListenableBuilder<int>(
                  valueListenable: selectPriceIndex,
                  builder: (BuildContext context, int value, Widget? child) {
                    return Text(
                      text,
                      style: TextStyle(
                        color: value == position ? Colors.blue : Colors.black,
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Custom menu effect.
  Widget customMenuEffect() {
    return Container(
      width: double.infinity,
      height: 200,
      color: Colors.white,
      alignment: Alignment.center,
      child: ListView.separated(
        itemCount: 4,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          thickness: 0.5,
          color: Colors.grey.withOpacity(0.3),
          indent: 16,
          endIndent: 16,
        ),
        itemBuilder: (context, index) {
          String text = '标题默认效果';
          switch (index) {
            case 0:
              text = '标题默认效果';
              break;
            case 1:
              text = '标题选中效果';
              break;
            case 2:
              text = '标题缩放效果';
              break;
            case 3:
              text = '标题背景效果';
              break;
          }
          return InkWell(
            onTap: () {
              _hideMenu(index: 0, isSelect: false);
              _hideMenu(index: 1, isSelect: false);
              _hideMenu(index: 2, isSelect: false);
              defaultColor = Colors.black;
              selectColor = Colors.black;
              defaultFontSize = 14;
              selectFontSize = 14;
              defaultIconSize = 24;
              selectIconSize = 24;
              headerHeight = 48;
              headerBackgroundColor = Colors.white;
              headerMainAxisAlignment = MainAxisAlignment.spaceAround;
              setState(() {
                selectEffectIndex = index;
                switch (index) {
                  case 0:
                    break;
                  case 1:
                    selectColor = Colors.blue;
                    break;
                  case 2:
                    selectColor = Colors.blue;
                    selectFontSize = 18;
                    selectIconSize = 32;
                    break;
                  case 3:
                    selectColor = Colors.white;
                    headerHeight = 58;
                    headerBackgroundColor =
                        Colors.purpleAccent.withOpacity(0.5);
                    headerMainAxisAlignment = MainAxisAlignment.spaceEvenly;
                    break;
                }
              });
            },
            child: Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Text(
                  text,
                  style: TextStyle(
                      color: selectEffectIndex == index
                          ? Colors.blue
                          : Colors.black),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Custom menu filter.
  Widget customMenuFilter() {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double slideDx = screenWidth * 0.2;
    Widget itemGrid(List<String> data,
        {double height = 120, Function(int)? onPressed}) {
      return SizedBox(
        width: double.infinity,
        height: height,
        child: GridView.builder(
          padding: EdgeInsets.only(right: slideDx),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 8,
              childAspectRatio: Platform.isIOS || Platform.isAndroid ? 3 : 6),
          itemCount: data.length,
          itemBuilder: (BuildContext ctx, index) {
            return ElevatedButton(
              onPressed: () {
                onPressed?.call(index);
                _hideMenu();
              },
              child: Text(
                data[index],
                textAlign: TextAlign.center,
                maxLines: 1,
                strutStyle: const StrutStyle(forceStrutHeight: true),
              ),
            );
          },
        ),
      );
    }

    double height = (Platform.isIOS || Platform.isAndroid) ? 120 : 80;
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.deepPurpleAccent.withOpacity(0.5),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          bottomLeft: Radius.circular(16),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 48),
          const Text('折扣',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          itemGrid(['1折', '2折', '3折', '4折', '5折', '6折', '7折', '8折', '9折'],
              height: height),
          const SizedBox(height: 16),
          const Text('颜色',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          itemGrid(['红色', '黄色', '蓝色', '绿色', '紫色', '橙色', '黑色', '白色'],
              height: height),
          const SizedBox(height: 16),
          const Text('品牌',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          itemGrid(['HLA', 'JEEP', 'Nike', 'Semir', 'ANTA', 'Vans'],
              height: height),
        ],
      ),
    );
  }
}
