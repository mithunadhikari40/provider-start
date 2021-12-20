import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart' hide Router;
import 'package:places/src/core/constants/app_constants.dart';
import 'package:places/src/core/locator/service_locator.dart';
import 'package:places/src/core/navigation/route_paths.dart';
import 'package:places/src/core/navigation/router.dart';
import 'package:places/src/services/local/cache_provider.dart';
import 'package:places/src/services/rx_data_service.dart';
import 'package:places/src/widgets/shared/app_colors.dart';

Future<void> main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  bool? isDark = await locator<CacheProvider>().getBoolValue(THEME_KEY);
  locator<RxDataService>().addTheme(isDark ?? false);
  runApp(App(isDark));
}

Future<void> handleBackgroundMessage(RemoteMessage message) async {}

class App extends StatelessWidget {
  App(this.isDark);

  final bool? isDark;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        initialData: isDark,
        stream: locator<RxDataService>().themeStream,
        builder: (context, AsyncSnapshot<bool> snapshot) {
          return MaterialApp(
            title: "Places",

            themeMode: snapshot.hasData && snapshot.data!
                ? ThemeMode.dark
                : ThemeMode.light,
            // color:
            //     snapshot.hasData && snapshot.data! ? blackColor87 : whiteColor,
            theme: ThemeData(
              appBarTheme: AppBarTheme(
                backgroundColor: whiteColor,
                titleTextStyle: TextStyle(
                  color: blackColor87,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                actionsIconTheme: IconThemeData(color: blackColor87),
                iconTheme: IconThemeData(color: blackColor87),
              ),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                selectedItemColor: blackColor87,
                unselectedItemColor: blackColor54,
                selectedIconTheme: IconThemeData(color: blackColor87),
                unselectedIconTheme: IconThemeData(color: blackColor54),
                selectedLabelStyle:
                    TextStyle(fontSize: 18, color: blackColor87),
                unselectedLabelStyle:
                    TextStyle(fontSize: 16, color: blackColor87),
              ),
              iconTheme: IconThemeData(
                color: blackColor87,
              ),
              primaryIconTheme: IconThemeData(
                color: blackColor87,
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide.none),
                padding: EdgeInsets.all(18.0),
                primary: primaryColor,
              )),
              textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(primary: primaryColor)),
              outlinedButtonTheme: OutlinedButtonThemeData(
                  style: OutlinedButton.styleFrom(primary: primaryColor)),
              buttonTheme: ButtonThemeData(
                buttonColor: primaryColor,
              ),
              textTheme: Theme.of(context).textTheme.apply(
                    bodyColor: blackColor87,
                    displayColor: blackColor87,
                  ),
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: primaryColor,
              ),
              tabBarTheme: TabBarTheme(labelColor: blackColor87),
            ),
            darkTheme: ThemeData(
              appBarTheme: AppBarTheme(
                backgroundColor: blackColor87,
                titleTextStyle: TextStyle(
                  color: whiteColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                actionsIconTheme: IconThemeData(color: whiteColor),
                iconTheme: IconThemeData(color: whiteColor),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide.none),
                padding: EdgeInsets.all(18.0),
                primary: primaryColor,
              )),
              textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(primary: primaryColor)),
              outlinedButtonTheme: OutlinedButtonThemeData(
                  style: OutlinedButton.styleFrom(primary: primaryColor)),
              buttonTheme: ButtonThemeData(
                buttonColor: primaryColor,
              ),
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: primaryColor,
              ),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                selectedItemColor: whiteColor,
                unselectedItemColor: whiteColor,
                backgroundColor: blackColor87,
                selectedIconTheme: IconThemeData(color: whiteColor),
                unselectedIconTheme: IconThemeData(color: whiteColor),
                selectedLabelStyle: TextStyle(fontSize: 18, color: whiteColor),
                unselectedLabelStyle:
                    TextStyle(fontSize: 16, color: whiteColor),
              ),
              iconTheme: IconThemeData(
                color: whiteColor,
              ),
              primaryIconTheme: IconThemeData(
                color: whiteColor,
              ),
              tabBarTheme: TabBarTheme(labelColor: whiteColor),
              textTheme: Theme.of(context).textTheme.apply(
                    bodyColor: blackColor87,
                    displayColor: blackColor87,
                  ),
            ),
            // home: LoginScreen(),
            onGenerateRoute: Router.onGenerateRoute,
            initialRoute: RoutePaths.SPLASH,
          );
        });
  }
}

/// __________________________**** Navigation in flutter *** _________________
///4 division(ways) priority wise weight on decreasing order
/// 1. passing *home* in MaterialApp
/// 2. passing *routes--- {}* in MaterialApp
/// 2. passing *onGenerateRoute*--- {Route<dynamic>? Function(RouteSettings)? onGenerateRoute} in MaterialApp
/// 2. passing *onUnknownRoute*--- {Route<dynamic>? Function(RouteSettings)? onGenerateRoute} --> if passed route is not found in MaterialApp
