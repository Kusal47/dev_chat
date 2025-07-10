import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev_chat/features/dashboard/presentation/home_screen/model/chat_user_model._response.dart';
import 'package:dev_chat/features/splash_screen/presentation/splash_screen.dart';
import 'package:dev_chat/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'core/api/core_bindings.dart';
import 'core/api/token_services.dart';
import 'core/resources/app_theme.dart';
import 'core/routes/app_pages.dart';
import 'features/auth/controller/auth_controller.dart';
import 'features/auth/login/presentation/login_screen.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart' as stream;

import 'features/chats/presentation/call_screen.dart';
import 'features/chats/widgets/incoming_call_alert.dart';

String? username;

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp( MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    userData();
    stream.StreamVideo.reset();

    if (currentUser != null) {
      final client = stream.StreamVideo(
        '73u4jjq2tunh', //getStream api key
        user: stream.User.regular(
            userId: currentUser!.uid, //current user id
            role: 'admin',
            name: username ?? currentUser?.displayName),
        userToken: generateJwtToken(currentUser!.uid), // token of current user logged in
      );
      client.connect();
      MyNotificationHandler.initialize();
    } else {
// Navigate to SplashScreen if currentUser is null
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAll(() => SplashScreen());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'devChat',
      useInheritedMediaQuery: true,
      initialBinding: CoreBindings(),
      supportedLocales: const [
        Locale('en', 'US'),
      ],
      fallbackLocale: const Locale('en'),
      locale: const Locale('en'),
     
      
      home: const LoginScreen(),
      themeMode: ThemeMode.light,
      theme: AppThemes.lightThemeData,
      darkTheme: AppThemes.darkThemeData,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}

class InitializeCallHandler {
  User? currentUser = FirebaseAuth.instance.currentUser;
  Future<String> getCallIdIfUseridExists(String? userId) async {
    if (currentUser != null) {
      DocumentSnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('callData').doc(userId ?? user?.id).get();
      if (userSnapshot.exists) {
        Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
        List<String> userIds = List<String>.from(userData['user_ids'] ?? []);
        Timestamp startTime = userData['start_time'];
        String status = userData['status'];

        // Check if the current user is in the call and the status is active
        if (userIds.contains(currentUser?.uid) && status == 'active'
            // &&
            // startTime == Timestamp.now()
            ) {
          log("User is active in call");
          String callId = userData['call_id'];
          return callId;
        } else {
          log("User is not active in call");
        }
      }
    }
    return "";
  }
}

class MyNotificationHandler {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // Initialize Flutter Local Notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings = const InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (message.notification != null) {
        displayLocalNotification(message);
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      if (message.data.containsKey('call_id')) {
        String callId = message.data['call_id'];
        navigateToCallScreen(message.notification?.body ?? '', callId);
      }
    });
  }

  static Future<void> displayLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    if (message.data.containsKey('call_id')) {
      String callId = message.data['call_id'];
      navigateToCallScreen(message.notification?.body ?? '', callId);
    }
    await flutterLocalNotificationsPlugin.show(
      message.notification.hashCode,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
      payload: 'notification payload',
    );
  }

  static void navigateToCallScreen(String message, String callId) async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) return;
    String callId = await InitializeCallHandler().getCallIdIfUseridExists(currentUser.uid);
    if (callId.isNotEmpty) {
      var call =
          stream.StreamVideo.instance.makeCall(callType: stream.StreamCallType(), id: callId);

      Navigator.push(
        Get.context!,
        MaterialPageRoute(
          builder: (context) => IncomingCallAlert(
            callerName: message,
            onAccept: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CallScreen(
                            call: call,
                            isIncommingCall: true,
                          )));
            },
            onDecline: () {
              call.end();
              Get.offAllNamed(Routes.dashboard);
            },
          ),
        ),
      );
    }
  }
}

ChatUserResponseModel? user;
void userData() async {
  User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    DocumentSnapshot<Map<String, dynamic>> userDoc =
        await FirebaseFirestore.instance.collection('chatUsers').doc(currentUser?.uid).get();
    user = ChatUserResponseModel.fromJson(userDoc.data() ?? {});
    username = userDoc.data()?['name'];
    final email = userDoc.data()?['email'];

    print(email);
    print(username);
  } else {
    return;
  }
}
