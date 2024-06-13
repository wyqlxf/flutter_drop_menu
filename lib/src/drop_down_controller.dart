import 'package:flutter/foundation.dart';

/// The controller of the dropdown menu.
class DropdownController extends ChangeNotifier {
  /// The index of the menu to display.
  int get index => _index;
  int _index = -1;

  /// Whether the menu is displayed, True means display, False means hide.
  bool get isShow => _isShow;
  bool _isShow = false;

  /// The data of the menu.
  Map<int, dynamic> get data => _data;
  final Map<int, dynamic> _data = {};

  /// Show the menu at the specified index.
  void show(int index) {
    _index = index;
    _isShow = true;
    notifyListeners();
  }

  /// Hide the menu.
  /// If the index is null or less than 0, clicking outside will only hide the menu.
  void hide({int? index, bool isSelect = false, String? title}) {
    if (null != index && index >= 0) {
      _index = index;
      if (_data.containsKey(index)) {
        _data[index]['title'] = title;
        _data[index]['is_select'] = isSelect;
      } else {
        _data[index] = {'is_select': isSelect, 'title': title};
      }
    }
    _isShow = false;
    notifyListeners();
  }

  /// Dispose of the controller.
  @override
  void dispose() {
    data.clear();
    super.dispose();
  }
}
