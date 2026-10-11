import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import "package:stripcard/base/utils/basic_screen_import.dart";
import 'package:flutter/services.dart';
import "package:stripcard/base/maintenance/maintanance_dialoge.dart";
import "package:stripcard/base/utils/local_storage.dart";
import "package:stripcard/base/utils/network_check/dependency_injection.dart";
import "package:stripcard/views/app_settings/controller/app_settings_controller.dart";
import "package:stripcard/base/utils/language/language_controller.dart";
import "package:stripcard/base/utils/theme.dart";
import 'package:pusher_beams/pusher_beams.dart';
import "package:stripcard/service/notification_service.dart";

void main() async {
  // Ensure Widgets Binding
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,

    DeviceOrientation.portraitDown,
  ]);

  await GetStorage.init();
  await LocalStorage.primeSecureCache();
  InternetCheckDependencyInjection.init();

  Get.put(Themes());

  // Set System UI Style based on Theme
  final bool isDarkMode = Get.isDarkMode; // Ensure it's accessible
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: isDarkMode
          ? CustomColor.whiteColor
          : CustomColor.primaryDarkScaffoldBackgroundColor,
      statusBarColor: isDarkMode
          ? CustomColor.whiteColor
          : CustomColor.primaryDarkScaffoldBackgroundColor,
      statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
    ),
  );

  // Run the main app
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    initPusherBeams();
    super.initState();
  }

  initPusherBeams() async {
    if (!kIsWeb) {
      await PusherBeams.instance.onMessageReceivedInTheForeground(
        _onMessageReceivedInTheForeground,
      );
    }
    await _checkForInitialMessage();
  }

  Future<void> _checkForInitialMessage() async {
    final initialMessage = await PusherBeams.instance.getInitialMessage();
    if (initialMessage != null) {}
  }

  void _onMessageReceivedInTheForeground(Map<Object?, Object?> data) {
    NotificationService.showLocalNotificationPusher(
      title: data["title"].toString(),
      body: data["body"].toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      useInheritedMediaQuery: true,
      designSize: const Size(375, 812),
      builder: (_, child) => GetMaterialApp(
        title: Strings.appName,
        debugShowCheckedModeBanner: false,
        theme: Themes.light,
        darkTheme: Themes.dark,
        themeMode: Themes().theme,
        navigatorKey: Get.key,
        initialRoute: Routes.splashScreen,

        getPages: Routes.list,
        initialBinding: BindingsBuilder(() {
          Get.put(LanguageController());
          Get.put(AppSettingsController(), permanent: true);
          Get.put(SystemMaintenanceController());
        }),
        builder: (context, widget) {
          ScreenUtil.init(context);
          return Obx(
            () => MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: Directionality(
                textDirection: Get.find<LanguageController>().isLoading
                    ? TextDirection.ltr
                    : Get.find<LanguageController>().languageDirection,
                child: Overlay(
                  initialEntries: [OverlayEntry(builder: (context) => widget!)],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
