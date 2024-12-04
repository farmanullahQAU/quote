import 'dart:async';
import 'dart:developer' as developer;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ConnectivityService extends GetxService {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  List<ConnectivityResult> _connectionStatus = [];
  Future<ConnectivityService> init() async {
    try {
      _connectionStatus = await _connectivity.checkConnectivity();
      _connectivitySubscription =
          _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
      print("ConnectivityService initialized successfully");
      return this;
    } on PlatformException catch (e) {
      print('Couldn\'t check connectivity status: $e');
      rethrow;
    }
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    _connectionStatus = result;
    if (!isConnected) {
      Get.snackbar(
        "No internet",
        "You are offline",
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      developer.log("Connected");
    }
  }

  bool get isConnected =>
      _connectionStatus.contains(ConnectivityResult.wifi) ||
      _connectionStatus.contains(ConnectivityResult.ethernet) ||
      _connectionStatus.contains(ConnectivityResult.mobile);

  void dispose() {
    _connectivitySubscription?.cancel();
  }
}
