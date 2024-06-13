import 'package:flutter/material.dart';
import 'package:flutter_drop_menu/src/drop_down_controller.dart';
import 'package:flutter_drop_menu/src/extension/safe_set_state.dart';
import 'package:flutter_drop_menu/src/header/header_listener.dart';

/// The type of animation to use for the menu.
enum AnimationType {
  /// No animation.
  none,

  /// Fade animation.
  fade,

  /// Animation from top to bottom.
  topToBottom,

  /// Animation from right to left.
  rightToLeft
}

/// A widget that displays a drop-down menu.
class DropDownMenu extends StatefulWidget {
  /// Custom widget displayed in the header. Built-in [DropDownHeader] widget.
  final List<Widget> header;

  /// Custom widget displayed in the menu.
  final List<Widget> menus;

  /// The animation type to use for the menu. Default usage is [AnimationType.topToBottom].
  final AnimationType animType;

  /// Choose different animation types for each menu based on the menu index. Default usage is [AnimationType.topToBottom].
  final List<AnimationType>? animTypes;

  /// The controller to use to control the menu.
  final DropdownController controller;

  /// The widget that separates the header from the menu.
  final Widget? divider;

  /// The callback that is called when the outside region is tapped.
  final GestureTapCallback? outsideOnTap;

  /// The height of the header.
  final double headerHeight;

  /// The background color of the header.
  final Color headerBackgroundColor;

  /// The arrangement of the title widget on the main axis.
  final MainAxisAlignment headerMainAxisAlignment;

  /// The amount of space by drop-down menu.
  final EdgeInsetsGeometry padding;

  /// The animation curve used by the drop-down menu.
  final Curve curve;

  /// The duration of the drop-down menu animation parameter.
  final Duration duration;

  /// The color of the outside region when the menu is displayed.
  final Color outsideColor;

  /// The tag of the menu.
  /// Use multiple drop-down menus at the same time and set tags when using the built-in DropDownHeader widget.
  final String tag;

  /// The amount of space the sliding menu takes when using the [AnimationType.rightToLeft] animation type.
  final double slideDx;

  const DropDownMenu({
    super.key,
    required this.header,
    required this.menus,
    required this.controller,
    this.divider,
    this.tag = 'default',
    this.animType = AnimationType.topToBottom,
    this.animTypes,
    this.outsideOnTap,
    this.headerHeight = 48,
    this.headerBackgroundColor = Colors.white,
    this.headerMainAxisAlignment = MainAxisAlignment.spaceAround,
    this.slideDx = 0.2,
    this.padding = EdgeInsets.zero,
    this.curve = Curves.decelerate,
    this.duration = const Duration(milliseconds: 300),
    this.outsideColor = const Color(0x80000000),
  }) : assert(header.length == menus.length,
            'The length of the header must be the same as the length of the menus');

  @override
  State<StatefulWidget> createState() => _DropDownMenuState();
}

class _DropDownMenuState extends State<DropDownMenu>
    with SingleTickerProviderStateMixin {
  /// Whether the menu is displayed.
  bool isShowMenu = false;

  /// The animation controller.
  late final AnimationController controller;

  /// The animation to use for the menu.
  late final Animation<double> sizeFactor;

  /// The animation to use for the menu.
  late final Animation<double> opacity;

  /// The animation to use for the menu.
  late final Animation<Offset> position;

  /// The type of animation to use for the menu.
  AnimationType animType = AnimationType.topToBottom;

  @override
  void initState() {
    super.initState();
    animType = widget.animType;
    controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    sizeFactor = CurvedAnimation(
      parent: controller,
      curve: widget.curve,
    );
    opacity = CurvedAnimation(
      parent: controller,
      curve: widget.curve,
    );
    position = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset(widget.slideDx, 0),
    ).animate(CurvedAnimation(
      parent: controller,
      curve: widget.curve,
    ));
    widget.controller.addListener(() {
      updateAnimType();
      String? title;
      bool isSelect = false;
      if (widget.controller.data.isNotEmpty &&
          widget.controller.data.containsKey(widget.controller.index)) {
        title = widget.controller.data[widget.controller.index]['title'];
        isSelect = widget.controller.data[widget.controller.index]['is_select'];
      }
      if (widget.controller.isShow) {
        if (controller.isCompleted) {
          // If the animation is already completed, Update the state of a widget.
          safeSetState(() {});
        } else {
          controller.forward();
        }
        HeaderListener.getInstance(widget.tag).notifyListeners(
            widget.controller.index, true,
            isSelect: isSelect, title: title);
      } else if (controller.isCompleted) {
        if (animType == AnimationType.none) {
          safeSetState(() {
            isShowMenu = false;
          });
        }
        controller.reverse();
        HeaderListener.getInstance(widget.tag).notifyListeners(
            widget.controller.index, false,
            isSelect: isSelect, title: title);
      }
    });
    controller.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        // Animation starts running in the forward direction
        safeSetState(() {
          isShowMenu = true;
        });
      } else if (status == AnimationStatus.dismissed) {
        // Animation has been dismissed
        safeSetState(() {
          isShowMenu = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (isShowMenu) outsideWidget(),
        Padding(
          padding: widget.padding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              headerWidget(),
              if (isShowMenu && null != widget.divider) widget.divider!,
              if (isShowMenu) menuWidget(),
            ],
          ),
        ),
        if (isShowMenu && animType == AnimationType.rightToLeft)
          menuAnimSlideWidget(),
      ],
    );
  }

  /// The widget to display the header.
  Widget headerWidget() {
    return Container(
      width: double.infinity,
      height: widget.headerHeight,
      color: widget.headerBackgroundColor,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: widget.headerMainAxisAlignment,
        children: widget.header,
      ),
    );
  }

  /// The widget to display the menu.
  Widget menuWidget() {
    assert(widget.controller.index >= 0,
        'The controller index must be greater than or equal to 0');
    assert(widget.menus.length > widget.controller.index,
        'The length of the menu must be greater than the index of the controller');
    if (animType == AnimationType.topToBottom) {
      return menuAnimSizeWidget();
    } else if (animType == AnimationType.fade) {
      return menuAnimFadeWidget();
    } else if (animType == AnimationType.none) {
      return widget.menus[widget.controller.index];
    }
    return const SizedBox.shrink();
  }

  /// The widget to display the menu from top to bottom.
  Widget menuAnimSizeWidget() {
    return SizeTransition(
      sizeFactor: sizeFactor,
      axis: Axis.vertical,
      axisAlignment: 0,
      child: widget.menus[widget.controller.index],
    );
  }

  /// The widget to display the menu from fade.
  Widget menuAnimFadeWidget() {
    return FadeTransition(
      opacity: opacity,
      child: widget.menus[widget.controller.index],
    );
  }

  /// The widget to display the menu from right to left.
  Widget menuAnimSlideWidget() {
    assert(widget.controller.index >= 0,
        'The controller index must be greater than or equal to 0');
    assert(widget.menus.length > widget.controller.index,
        'The length of the menu must be greater than the index of the controller');
    return SlideTransition(
      position: position,
      child: widget.menus[widget.controller.index],
    );
  }

  /// The widget to display outside the menu.
  Widget outsideWidget() {
    Widget child = GestureDetector(
      onTap: widget.outsideOnTap ??
          () {
            widget.controller.hide();
          },
      child: Container(
        width: double.infinity,
        color: widget.outsideColor,
      ),
    );
    if (animType == AnimationType.none) {
      return child;
    }
    return FadeTransition(
      opacity: opacity,
      child: child,
    );
  }

  /// Update the animation type.
  updateAnimType() {
    if (null != widget.animTypes &&
        widget.animTypes!.length > widget.controller.index &&
        widget.controller.index >= 0) {
      animType = widget.animTypes![widget.controller.index];
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
