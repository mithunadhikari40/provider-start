import 'package:places/src/core/authenticated_request.dart';
import 'package:places/src/core/constants/app_constants.dart';
import 'package:places/src/core/locator/service_locator.dart';
import 'package:places/src/model/user_model.dart';
import 'package:places/src/services/local/cache_provider.dart';
import 'package:places/src/services/local/db_provider.dart';
import 'package:places/src/services/rx_data_service.dart';

class SplashService {
  final DbProvider dbProvider = locator<DbProvider>();
  final CacheProvider cacheProvider = locator<CacheProvider>();
  final RxDataService rxDataService = locator<RxDataService>();

  bool isAlreadyLoggedIn = false;

  Future<void> initialize() async {
    UserModel? user = await dbProvider.getUser();
    if (user == null) {
      return;
    }
    rxDataService.addUser(user);

    //todo 2. load up the token from cache if exists
    String? token = await cacheProvider.getStringValue(TOKEN_KEY);
    if (token == null) {
      return;
    }
    authenticatedRequest.setDefaultHeaders({"x-auth-token":token});

    //todo 3. decide whether the user is already logged in or not
    isAlreadyLoggedIn = true;
  }


}