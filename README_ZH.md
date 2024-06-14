# flutter_drop_menu
<a href="https://pub.dev/packages/flutter_drop_menu">
  <img src="https://img.shields.io/badge/Pub-v1.0.0-blue" alt="Pub Version"/>
</a> &nbsp
<a href="https://opensource.org/licenses/MIT">
  <img src="https://img.shields.io/badge/License-MIT-red" alt="License: MIT"/>
</a> &nbsp 
<a name="Wiqwj"></a>

Language： [English](https://github.com/wyqlxf/flutter_drop_menu/blob/master/README.md) | 简体中文

# 介绍
这是一个自定义的Flutter下拉菜单，可以显示标题选中状态和多种下拉动画效果。
<a name="Wiqwj"></a>

# 特征
- 支持自定义header
- 支持自定义menus
- 支持多种动画效果
- 内置选中效果header
  <a name="OkWiA"></a>

# 效果预览
![Preview](https://github.com/wyqlxf/flutter_drop_menu/blob/master/preview_images/drop_down_menu.gif)

<a name="SLIZy"></a>
# 开始使用
<a name="CtaaU"></a>
## 安装
将 flutter_drop_menu 包添加到你的 [pubspec 依赖项中](https://pub.dev/packages/flutter_drop_menu/install)
<a name="nFA0I"></a>
## DropDownMenu 参数
| **选项** | **类型** | **描述** | **是否必传** |
| --- | --- | --- | --- |
| header | List<Widget> | 显示在标题中的自定义小部件 | 是 |
| menus | List<Widget> | 菜单中显示的自定义小部件 | 是 |
| controller | DropdownController | 用于控制菜单的控制器 | 是 |
| divider | Widget? | 将标题与菜单分隔开的小部件 | 否 |
| tag | String | 菜单的标签 | 否 |
| animType | AnimationType | 菜单动画类型，默认使用AnimationType.topToBottom | 否 |
| animTypes | List<AnimationType>? | 菜单动画类型集合，可以指定每个菜单进行不同的动画 | 否 |
| outsideOnTap | GestureTapCallback? | 外部点击区域回调 | 否 |
| headerHeight | double | 标题小部件的高度 | 否 |
| headerDecoration | Decoration? | 标题的装饰 | 否 |
| headerBackgroundColor | Color | 标题小部件的背景颜色 | 否 |
| headerMainAxisAlignment | MainAxisAlignment | 标题小部件在主轴上的排列方式 | 否 |
| slideDx | double | 使用[AnimationType.rightToLeft]动画类型时滑动菜单占用的空间量 | 否 |
| padding | EdgeInsetsGeometry | 菜单上下左右的填充量 | 否 |
| curve | Curve | 菜单的动画曲线 | 否 |
| duration | Duration | 菜单动画的持续时间 | 否 |
| outsideColor | Color | 菜单外部区域的背景颜色 | 否 |

<a name="kLRA9"></a>
## 使用示例
```dart
  /// The controller to use to control the menu.
  final DropdownController _controller = DropdownController();

  /// Show the menu.
  void _showMenu(int index) {
    if (_controller.index == index && _controller.isShow) {
      _hideMenu(-1);
    } else {
      _controller.show(index);
    }
  }

  /// Hide the menu.
  void _hideMenu(int index) {
    _controller.hide(index);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          DropDownMenu(
            // The controller to use to control the menu.
            controller: _controller,
            // The header of the drop-down menu.
            header: List.generate(4, (index) {
                return DropDownHeader(
                  index: index,
                  title: 'Header $index',
                  onTap: (index) {
                    _showMenu(index);
                  },
                );
              },
            ),
            // The menu of the drop-down menu.
            menus: List.generate(4, (index) {
                return Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () {
                      _hideMenu(index);
                    },
                    child: Text('Menu $index'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
```

# License
The MIT License (MIT) Copyright (c) 2024 WangYongQi

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.