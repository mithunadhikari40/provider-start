import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:location/location.dart';
import 'package:places/src/core/base_widget.dart';
import 'package:places/src/core/locator/service_locator.dart';
import 'package:places/src/core/navigation/route_paths.dart';
import 'package:places/src/screens/dashboard/explore_screen.dart';
import 'package:places/src/screens/dashboard/favorite_screen.dart';
import 'package:places/src/screens/dashboard/profile_screen.dart';
import 'package:places/src/utils/snackbar_helper.dart';
import 'package:places/src/viewmodels/dashboard/dashboard_view_model.dart';
import 'package:places/src/widgets/shared/app_colors.dart';

class DashboardScreen extends StatefulWidget {
  static const screens = [ExploreScreen(), FavoriteScreen(), ProfileScreen()];
  static const titles = ["Explore", "Favorite", "Profile"];

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  Widget build(BuildContext context) {
    return BaseWidget<DashboardViewModel>(
        model: locator<DashboardViewModel>(),
        onModelReady: (model) {
          _onModelReady(context, model);
        },
        builder:
            (BuildContext context, DashboardViewModel model, Widget? child) {
          return Scaffold(
            key: _scaffoldKey,
            appBar: _buildAppBar(context, model),
            body: _buildBody(model),
            bottomNavigationBar: _buildBottomNavigationBar(context, model),
            drawer: _buildNavigationDrawer(context, model),
          );
        });
  }

  Future<void> _onModelReady(
      BuildContext context, DashboardViewModel model) async {
    ///1. show a snack bar when connectivity changes
    _listenUserLocation(context, model);

    ///2. record user location
    _listenConnectivity(context, model);

    ///3 setup and listen notification
    await _setupLocalNotification(context, model);
    _setupFcm(context, model);
  }

  Future<void> _setupLocalNotification(
      BuildContext context, DashboardViewModel model) async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: false,
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  Future selectNotification(String? payload) async {
    if (payload != null) {}
  }

  void _showLocalNotification(
      RemoteNotification? notification, String content) async {
    final id = DateTime.now().millisecond + Random().nextInt(100);

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      id.toString(),
      'places',
      channelDescription: 'places notification description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      fullScreenIntent: true,
      playSound: true,
      channelAction: AndroidNotificationChannelAction.update,
    );
    var iOSPlatformChannelSpecifics =
        IOSNotificationDetails(presentSound: true, presentBadge: true);
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        id, notification?.title, notification?.body, platformChannelSpecifics,
        payload: content);
  }

  Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title!),
        content: Text(body!),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              /*await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SecondScreen(payload),
                ),
              );*/
            },
          )
        ],
      ),
    );
  }

  Future<void> _setupFcm(BuildContext context, DashboardViewModel model) async {
    /// 1. Check to see if the device is ios, if yes then ask for notification permission
    if (Platform.isIOS) {
      final setting = await FirebaseMessaging.instance
          .requestPermission(badge: true, sound: true, alert: true);
      if (setting.authorizationStatus != AuthorizationStatus.authorized) {
        return showSnackBar(context,
            "We need notification permission to show you latest places alert");
      }
    }

    /// 2. Take FCM push token and update it to server
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    model.pushTokenToServer(fcmToken);

    ///3. Listen for incoming notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final data = message.data;
      final title = message.notification?.title;
      final body = message.notification?.body;
      print("Notification data $data, $title, $body");
      _showLocalNotification(message.notification, jsonEncode(data));

      ///4. Use local notification:
    });

    // FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  void _listenConnectivity(BuildContext context, DashboardViewModel model) {
    Connectivity().onConnectivityChanged.listen((event) {
      print("Connection status $event");
      if (event == ConnectivityResult.none) {
        showSnackBar(context, "No internet connection");
      } else {
        showSnackBar(context, "Back online");
      }
    });
  }

  AppBar? _buildAppBar(BuildContext context, DashboardViewModel model) {
    if (model.currentIndex == 2) return null;
    return AppBar(
      title: Text(DashboardScreen.titles[model.currentIndex]),
      leading: IconButton(
        icon: Icon(
          Icons.menu,
        ),
        onPressed: () {
          bool drawerOpen = _scaffoldKey.currentState!.isDrawerOpen;
          if (!drawerOpen) {
            _scaffoldKey.currentState!.openDrawer();
          }
        },
      ),
      actions: [
        model.currentIndex != 0
            ? Container()
            : IconButton(
                icon: Icon(
                  Icons.add,
                  size: 40,
                ),
                onPressed: () =>
                    Navigator.of(context).pushNamed(RoutePaths.ADD_NEW),
              ),
        SizedBox(
          width: 16,
        ),
      ],
    );
  }

  Widget _buildBody(DashboardViewModel model) {
    return DashboardScreen.screens[model.currentIndex];
  }

  Widget _buildBottomNavigationBar(
      BuildContext context, DashboardViewModel model) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Explore"),
        BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outlined), label: "Favorite"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
      onTap: model.setCurrentIndex,
      currentIndex: model.currentIndex,
      showSelectedLabels: true,
      showUnselectedLabels: true,
    );
  }

  Widget _buildNavigationDrawer(
      BuildContext context, DashboardViewModel model) {
    print("System dark ${Theme.of(context).brightness}");
    return Container(
      width: 200,
      color: Theme.of(context).brightness == Brightness.dark
          ? blackColor87
          : whiteColor,
      child: Drawer(
        child: Column(
          children: [
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              height: 100,
            ),
            ListTile(
              title: Text("Explore"),
              trailing: Icon(Icons.explore),
              selected: model.currentIndex == 0,
              onTap: () {
                model.setCurrentIndex(0);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text("Favorite"),
              trailing: Icon(Icons.favorite_outlined),
              selected: model.currentIndex == 1,
              onTap: () {
                model.setCurrentIndex(1);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text("Profile"),
              trailing: Icon(Icons.person),
              selected: model.currentIndex == 2,
              onTap: () {
                model.setCurrentIndex(2);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text("About us"),
              trailing: Icon(Icons.info),
            ),
            ListTile(
              title: Text("Log out"),
              trailing: Icon(Icons.exit_to_app),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _listenUserLocation(
      BuildContext context, DashboardViewModel model) async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        showSnackBar(context,
            "Places needs your location to accurately show places near you");
        return;
      }
    }
    _permissionGranted = await location.hasPermission();

    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        showSnackBar(context,
            "Places needs location permission to accurately show places near you");
        return;
      }
    }

    _locationData = await location.getLocation();

    /// store in app state
    model.addUserLocation(_locationData);
    print("The user location $_locationData");
  }
}
