import 'package:flutter/cupertino.dart';
import 'package:places/src/core/locator/service_locator.dart';
import 'package:places/src/core/navigation/route_paths.dart';
import 'package:places/src/services/local/cache_provider.dart';
import 'package:places/src/services/local/db_provider.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  Future logout() async {
    final dbProvider = locator<DbProvider>();
    final cacheProvider = locator<CacheProvider>();
    dbProvider.clear();
    cacheProvider.clear();
    navigatorKey.currentState?.pushNamedAndRemoveUntil(RoutePaths.LOGIN,
        (route) {
      return route.settings.name == RoutePaths.LOGIN;
    });
  }
}
