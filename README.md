# flutter_drop_menu
<a href="https://pub.dev/packages/flutter_drop_menu">
  <img src="https://img.shields.io/badge/Pub-v1.0.0-blue" alt="Pub Version"/>
</a> &nbsp
<a href="https://opensource.org/licenses/MIT">
  <img src="https://img.shields.io/badge/License-MIT-red" alt="License: MIT"/>
</a> &nbsp 

Language: English | [简体中文](https://github.com/wyqlxf/flutter_drop_menu/blob/master/README_ZH.md)

# Intro
This is a custom Flutter dropdown menu that supports highlighting selected titles and various dropdown animation effects.
<a name="MeYNJ"></a>

# Features
- Support custom headers
- Support custom menus
- Support multiple animation effects
- Built-in header widget with selection effect
  <a name="SxWqM"></a>

# Preview
<a name="CBYvR"></a>
![Preview](https://github.com/wyqlxf/flutter_drop_menu/blob/master/preview_images/drop_down_menu.gif)

# Get started
<a name="Gfe7H"></a>
## Install
Add the flutter_drop_menu package to your [pubspec dependencies](https://pub.dev/packages/flutter_drop_menu/install).
<a name="oO7mS"></a>
## DropDownMenu Param
| **Option** | **Type** | **Describe** | **Required** |
| --- | --- | --- | --- |
| header | List<Widget> | Custom widget displayed in the header | Yes |
| menus | List<Widget> | Custom widget displayed in the menu | Yes |
| controller | DropdownController | The controller to use to control the menu | Yes |
| divider | Widget? | The widget that separates the header from the menu | No |
| tag | String | The tag of the menu | No |
| animType | AnimationType | The animation type to use for the menu. Default usage is [AnimationType.topToBottom] | No |
| animTypes | List<AnimationType>? | Choose different animation types for each menu based on the menu index | No |
| outsideOnTap | GestureTapCallback? | The callback that is called when the outside region is tapped | No |
| headerHeight | double | The height of the header | No |
| headerDecoration | Decoration? | The decoration of the header | No |
| headerBackgroundColor | Color | The background color of the header | No |
| headerMainAxisAlignment | MainAxisAlignment | The arrangement of the title widget on the main axis | No |
| slideDx | double | The amount of space the sliding menu takes when using the [AnimationType.rightToLeft] animation type | No |
| padding | EdgeInsetsGeometry | The amount of space by drop-down menu | No |
| curve | Curve | The animation curve used by the drop-down menu | No |
| duration | Duration | The duration of the drop-down menu animation parameter | No |
| outsideColor | Color | The color of the outside region when the menu is displayed | No |

<a name="rTWpc"></a>
## Usage
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