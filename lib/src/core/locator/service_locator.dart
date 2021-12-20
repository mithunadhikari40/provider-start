import 'package:get_it/get_it.dart';
import 'package:places/src/api/auth_api.dart';
import 'package:places/src/api/dashboard/explore_api.dart';
import 'package:places/src/api/dashboard/favorite_api.dart';
import 'package:places/src/api/dashboard/my_places_api.dart';
import 'package:places/src/api/dashboard/profile_api.dart';
import 'package:places/src/services/auth/login_service.dart';
import 'package:places/src/services/dashboard/expore_service.dart';
import 'package:places/src/services/dashboard/favorite_service.dart';
import 'package:places/src/services/dashboard/my_places_service.dart';
import 'package:places/src/services/dashboard/profile_detail_service.dart';
import 'package:places/src/services/local/cache_provider.dart';
import 'package:places/src/services/local/db_provider.dart';
import 'package:places/src/services/navigation_service.dart';
import 'package:places/src/services/rx_data_service.dart';
import 'package:places/src/services/splash/splash_service.dart';
import 'package:places/src/viewmodels/auth/login_view_model.dart';
import 'package:places/src/viewmodels/dashboard/add_new_place_view_model.dart';
import 'package:places/src/viewmodels/dashboard/add_to_favorite_view_model.dart';
import 'package:places/src/viewmodels/dashboard/dashboard_view_model.dart';
import 'package:places/src/viewmodels/dashboard/explore_view_model.dart';
import 'package:places/src/viewmodels/dashboard/favorite_view_model.dart';
import 'package:places/src/viewmodels/dashboard/my_places_view_model.dart';
import 'package:places/src/viewmodels/dashboard/profile_detail_view_model.dart';
import 'package:places/src/viewmodels/splash/splash_view_model.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  /// independent services
  locator.registerLazySingleton<AuthApi>(() => AuthApi());
  locator.registerLazySingleton<ProfileApi>(() => ProfileApi());
  locator.registerLazySingleton<MyPlacesApi>(() => MyPlacesApi());
  locator.registerLazySingleton<ExploreApi>(() => ExploreApi());
  locator.registerLazySingleton<FavoriteApi>(() => FavoriteApi());
  locator.registerLazySingleton<DbProvider>(() => DbProvider());
  locator.registerLazySingleton<CacheProvider>(() => CacheProvider());
  locator.registerLazySingleton<RxDataService>(() => RxDataService());

  locator.registerLazySingleton<NavigationService>(() => NavigationService());

  /// dependant services
  locator.registerLazySingleton<LoginService>(() => LoginService());
  locator.registerLazySingleton<SplashService>(() => SplashService());
  locator.registerLazySingleton<ExploreService>(() => ExploreService());
  locator.registerLazySingleton<FavoriteService>(() => FavoriteService());

  locator.registerLazySingleton<ProfileDetailService>(
      () => ProfileDetailService());
  locator.registerLazySingleton<MyPlacesService>(() => MyPlacesService());

  ///view models
  locator.registerFactory<LoginViewModel>(() => LoginViewModel());
  locator.registerFactory<SplashViewModel>(() => SplashViewModel());
  locator.registerFactory<ExploreViewModel>(() => ExploreViewModel());
  locator.registerFactory<DashboardViewModel>(() => DashboardViewModel());
  locator.registerFactory<AddNewPlaceViewModel>(() => AddNewPlaceViewModel());
  locator.registerFactory<FavoriteViewModel>(() => FavoriteViewModel());
  locator
      .registerFactory<ProfileDetailViewModel>(() => ProfileDetailViewModel());
  locator.registerFactory<MyPlacesViewModel>(() => MyPlacesViewModel());
  locator
      .registerFactory<AddToFavoriteViewModel>(() => AddToFavoriteViewModel());
}
