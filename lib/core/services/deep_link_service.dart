import 'dart:async';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeepLinkService {
  static const MethodChannel _channel = MethodChannel('wahnkap/deep_link');

  StreamController<String>? _linkController;

  Stream<String> get linkStream {
    _linkController ??= StreamController<String>.broadcast();
    return _linkController!.stream;
  }

  Future<void> initialize() async {
    try {
      // Listen for incoming deep links
      _channel.setMethodCallHandler(_handleMethodCall);

      // Check if app was launched from a deep link
      final String? initialLink = await _channel.invokeMethod('getInitialLink');
      if (initialLink != null) {
        _linkController?.add(initialLink);
      }
    } catch (e) {
      // Error initializing deep links: $e
    }
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onNewLink':
        final String link = call.arguments as String;
        _linkController?.add(link);
        break;
    }
  }

  void dispose() {
    _linkController?.close();
    _linkController = null;
  }
}
