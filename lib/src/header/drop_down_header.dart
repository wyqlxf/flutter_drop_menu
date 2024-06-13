import 'package:flutter/material.dart';
import 'package:flutter_drop_menu/src/extension/safe_set_state.dart';
import 'package:flutter_drop_menu/src/header/header_listener.dart';

/// A widget that displays a drop-down header.
class DropDownHeader extends StatefulWidget {
  /// The title of the header.
  final String title;

  /// The index of the header.
  final int index;

  /// The callback that is called when the header is tapped.
  final Function(int)? onTap;

  /// The style to use for the header.
  final TextStyle textStyle;

  /// The style to use for the selected header.
  final TextStyle selectTextStyle;

  /// The color of the icon.
  final Color iconColor;

  /// The color of the selected icon.
  final Color selectIconColor;

  /// The size of the icon.
  final double iconSize;

  /// The size of the selected icon.
  final double selectIconSize;

  /// The animation curve used by the header.
  final Curve curve;

  /// The duration of the header animation parameter.
  final Duration duration;

  /// The tag of the header.
  /// Setting labels when using multiple drop-down menus at the same time.
  final String tag;

  const DropDownHeader({
    super.key,
    required this.title,
    required this.index,
    this.onTap,
    this.tag = 'default',
    this.textStyle = const TextStyle(
      color: Colors.black,
      fontSize: 14,
    ),
    this.selectTextStyle = const TextStyle(
      color: Colors.black,
      fontSize: 14,
    ),
    this.iconSize = 24,
    this.selectIconSize = 24,
    this.iconColor = Colors.black,
    this.selectIconColor = Colors.black,
    this.curve = Curves.decelerate,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  State<StatefulWidget> createState() => _DropDownHeaderState();
}

class _DropDownHeaderState extends State<DropDownHeader>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  /// The number of turns.
  double turns = 0;

  /// Whether to use animation.
  bool isUseAnim = false;

  /// Whether the header is selected.
  bool isSelect = false;

  /// Whether the header is selected in outside.
  bool isOutsideSelect = false;

  /// The title of the header.
  String? outsideTitle;

  /// The callback that is called when the header is tapped.
  Function(int, bool, bool, String?)? callback;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    callback = (index, isShow, outsideSelect, title) {
      safeSetState(() {
        isUseAnim = true;
        if (isShow) {
          if (widget.index == index) {
            isSelect = true;
            turns = 0.5;
          } else {
            isSelect = false;
            turns = 0;
            isUseAnim = false;
          }
        } else {
          turns = 0;
          isSelect = false;
        }
        if (widget.index == index) {
          outsideTitle = title;
          isOutsideSelect = outsideSelect;
        }
      });
    };
    // Add the listener.
    HeaderListener.getInstance(widget.tag).addListener(callback);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () {
        widget.onTap?.call(widget.index);
      },
      child: Row(
        children: [
          AnimatedDefaultTextStyle(
            style: isSelect || isOutsideSelect
                ? widget.selectTextStyle
                : widget.textStyle,
            curve: widget.curve,
            duration: widget.duration,
            child: Text(outsideTitle ?? widget.title),
          ),
          AnimatedRotation(
            turns: turns,
            duration: isUseAnim ? widget.duration : Duration.zero,
            child: Icon(Icons.arrow_drop_down,
                color: isSelect || isOutsideSelect
                    ? widget.selectIconColor
                    : widget.iconColor,
                size: isSelect || isOutsideSelect
                    ? widget.selectIconSize
                    : widget.iconSize),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Remove the listener.
    HeaderListener.getInstance(widget.tag).removeListener(callback);
    callback = null;
    super.dispose();
  }
}
