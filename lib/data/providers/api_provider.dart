import 'package:get/get.dart';
import 'package:logger/web.dart';

import '../../services/connectivity_service.dart';
import '../../services/storage_service.dart';

class ApiProvider extends GetConnect {
  var logger = Logger();
  static const String bUrl =
      // 'http://192.168.10.15:3000/api/'; // Example base URL
      'http://192.168.100.50:3000/api/'; // Example base URL

  final _storageService = Get.find<StorageService>();
  final _connectivityService = Get.find<ConnectivityService>();

  ApiProvider() {
    timeout = const Duration(seconds: 30); // Default timeout for API calls
    httpClient.baseUrl = bUrl;
  }

  Future<void> getData(
    String endpoint, {
    Map<String, dynamic>? params,
    required String storageKey,
    required Function(dynamic) successCallback,
    bool useCache = true,
    required Function(String) onError,
  }) async {
    Logger().d("Body: $params");

    try {
      final isConnected = _connectivityService.isConnected;

      // If not connected and cache is allowed, use cached data
      if (!isConnected && useCache) {
        final cachedData = await _getCachedData(storageKey);
        if (cachedData != null) {
          successCallback(cachedData); // Call successCallback with cached data
          _showOfflineNotification(); // Notify user
          return; // Exit before to avoid further API call
        }
      }

      // Attempt API call if connected
      if (isConnected) {
        final response = await get(endpoint, query: params);

        // Check if the API call was successful
        if (response.isOk) {
          // Cache new data after successful network call
          await _cacheData(response.body['data'], storageKey);

          // Call successCallback with the fresh data
          final freshData = response.body['data'];
          logger.d("Api Data: $freshData");
          successCallback(freshData);
        } else {
          // If the API call failed, check if we have cached data
          if (useCache) {
            final cachedData = await _getCachedData(storageKey);
            if (cachedData != null) {
              successCallback(
                  cachedData); // Call successCallback with cached data
              // _showOfflineNotification(); // Notify user
            } else {
              onError('Failed to fetch data: ${response.statusText}');
            }
          } else {
            onError('Failed to fetch data: ${response.statusText}');
          }
        }
      } else {
        onError('No internet connection. Please check your network.');
      }
    } catch (e) {
      Logger().e(e);
      onError('Failed to connect: $e');
    }
  }

  Future<void> _cacheData(dynamic data, String storageKey) async {
    await _storageService.writeData(storageKey, data);
  }

  Future<dynamic>? _getCachedData(String storageKey) async {
    return _storageService.readData<dynamic>(storageKey);
  }

  void _showOfflineNotification() {
    Get.snackbar("", "'You are offline. Using cached data.'");
  }
}
