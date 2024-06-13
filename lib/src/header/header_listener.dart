/// The listener for the header.
class HeaderListener {
  HeaderListener._internal();

  /// The instance of the [HeaderListener].
  static final Map<String, HeaderListener> _instances = {};

  /// Get the instance of the [HeaderListener].
  factory HeaderListener.getInstance(String tag) {
    if (!_instances.containsKey(tag)) {
      _instances[tag] = HeaderListener._internal();
    }
    return _instances[tag]!;
  }

  /// The list of listeners.
  final List<Function(int, bool, bool, String?)?> _listeners = [];

  /// Add a listener.
  addListener(Function(int, bool, bool, String?)? callback) {
    if (callback != null && !_listeners.contains(callback)) {
      _listeners.add(callback);
    }
  }

  /// Remove a listener.
  removeListener(Function(int, bool, bool, String?)? callback) {
    if (callback != null && _listeners.contains(callback)) {
      _listeners.remove(callback);
    }
  }

  /// Notify the listeners.
  notifyListeners(int index, bool isShow,
      {bool isSelect = false, String? title}) {
    if (_listeners.isNotEmpty) {
      for (var notify in _listeners) {
        if (null != notify) {
          notify(index, isShow, isSelect, title);
        }
      }
    }
  }
}
