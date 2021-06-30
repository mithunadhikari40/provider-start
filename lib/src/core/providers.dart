import 'package:flutter/cupertino.dart';
import 'package:places/src/api/auth_api.dart';
import 'package:places/src/api/dashboard/explore_api.dart';
import 'package:places/src/api/dashboard/favorite_api.dart';
import 'package:places/src/services/auth/auth_service.dart';
import 'package:places/src/services/auth_rx_provider.dart';
import 'package:places/src/services/dashboard/dashboard_service.dart';
import 'package:places/src/services/dashboard/explore_service.dart';
import 'package:places/src/services/dashboard/favorite_service.dart';
import 'package:places/src/services/local/cache_provider.dart';
import 'package:places/src/services/local/db_provider.dart';
import 'package:places/src/services/splash_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

final List<SingleChildWidget> providers = [
  ...independentProviders,
  ...dependantProviders,
];

final List<SingleChildWidget> independentProviders = [
  Provider.value(value: AuthApi()),
  Provider.value(value: ExploreApi()),
  Provider.value(value: FavoriteApi()),
  Provider.value(value: DbProvider()),
  Provider.value(value: CacheProvider()),
  Provider.value(value: AuthRxProvider()),
];
final List<SingleChildWidget> dependantProviders = [
  ProxyProvider3<DbProvider, CacheProvider, AuthRxProvider, SplashService>(
    update: (BuildContext context,
        DbProvider dbProvider,
        CacheProvider cacheProvider,
        AuthRxProvider authRxProvider,
        SplashService? service) {
      return SplashService(
          authRxProvider: authRxProvider,
          cacheProvider: cacheProvider,
          dbProvider: dbProvider);
    },
  ),
  ProxyProvider4<AuthApi, DbProvider, CacheProvider, AuthRxProvider,
      AuthService>(
    update: (BuildContext context,
        AuthApi api,
        DbProvider dbProvider,
        CacheProvider cacheProvider,
        AuthRxProvider authRxProvider,
        AuthService? service) {
      return AuthService(
          api: api,
          authRxProvider: authRxProvider,
          cacheProvider: cacheProvider,
          dbProvider: dbProvider);
    },
  ),
  ProxyProvider<AuthRxProvider, DashboardService>(
    update: (BuildContext context, AuthRxProvider authRxProvider, DashboardService? service) {
      return DashboardService(authRxProvider: authRxProvider);
    },
  ),
  ProxyProvider2<ExploreApi, AuthRxProvider, ExploreService>(
    update: (BuildContext context, ExploreApi api,
        AuthRxProvider authRxProvider, ExploreService? service) {
      return ExploreService(api: api, authRxProvider: authRxProvider);
    },
  ),
  ProxyProvider2<FavoriteApi, AuthRxProvider, FavoriteService>(
    update: (BuildContext context, FavoriteApi api,
        AuthRxProvider authRxProvider, FavoriteService? service) {
      return FavoriteService(api: api, authRxProvider: authRxProvider);
    },
  ),
];
