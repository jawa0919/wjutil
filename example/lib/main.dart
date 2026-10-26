import 'package:flutter/services.dart';

import 'package:material_ui/material_ui.dart';

import 'app.dart';
import 'app_import.dart';

void main() async {
  debugPrint('main.dart~running: isProduct-${Wjutil.isProduct}');
  // ignore: unused_local_variable
  final wfb = WidgetsFlutterBinding.ensureInitialized();
  // wfb.deferFirstFrame();
  // wfb.resetFirstFrameSent();
  await Wjutil.init();
  await _initSystem();
  await _printDebugMessage();
  runApp(const App());
}

Future<void> _initSystem() async {
  ServerManager.init(
    AppStatic.serverMap,
    Wjutil.isProduct ? 'prod' : 'dev',
    () {
      AppApi().updateBaseUrl(ServerManager.optVal('mainApi'));
    },
  );
  ThemeStore.init(AppStatic.colorScheme);
  LanguageStore.init();
  AppRoutes.setPageLanguage();
  if (Wjutil.isMobile) {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    List<DeviceOrientation> devOri = [DeviceOrientation.portraitUp];
    if (AppStatic.designLandscape) {
      devOri = [DeviceOrientation.landscapeLeft];
    }
    await SystemChrome.setPreferredOrientations(devOri);
  }
}

Future<void> _printDebugMessage() async {
  if (!Wjutil.isProduct) {
    debugPrint('..._printDebugMessage...');
    debugPrint('tempDir: ${Wjutil.tempDir}');
    debugPrint('docsDir: ${Wjutil.docsDir}');

    debugPrint('deviceVersion: ${Wjutil.deviceVersion}');
    debugPrint('brand: ${Wjutil.deviceBrand}');
    debugPrint('model: ${Wjutil.deviceModel}');

    debugPrint('packageName: ${Wjutil.packageName}');
    debugPrint('packageId: ${Wjutil.packageId}');
    debugPrint('packageVersion: ${Wjutil.packageVersion}');
    debugPrint('packageVersionCode: ${Wjutil.packageVersionCode}');
  }
}
