import 'package:dio_log_plus/dio_log_plus.dart' show showDebugBtn;
import 'package:material_ui/material_ui.dart';

import '../util/media_util.dart';
import '../util/share_util.dart';
import '../widget/qr_scan_view.dart';
import 'storage_show_page.dart';
import 'theme_color_show_page.dart';
import '../wjutil.dart';
import 'url_schemes_page.dart';

class DebugPage extends StatefulWidget {
  static bool debugFlag = !Wjutil.isProduct;
  const DebugPage({super.key});

  static void start(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const DebugPage()),
    );
  }

  @override
  State<DebugPage> createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  var f = TextEditingController(text: 'https://flutter.cn/');

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    showDebugBtn(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('DebugPage'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      extendBody: false,
      body: Card(
        margin: const EdgeInsets.all(16),
        child: ListView(
          physics: ClampingScrollPhysics(),
          children: ListTile.divideTiles(
            context: context,
            tiles: [
              TextButton(
                child: const Text('SharedPreferences Show'),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const StorageShowPage(),
                    ),
                  );
                },
              ),
              TextButton(
                child: const Text('Theme Color Show'),
                onPressed: () async {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ThemeColorShowPage(),
                    ),
                  );
                },
              ),
              TextButton(
                child: const Text('URL Schemes'),
                onPressed: () async {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const URLSchemesPage(),
                    ),
                  );
                },
              ),
              Builder(
                builder: (context) {
                  return ListTile(
                    leading: IconButton(
                      onPressed: () {
                        ShareUtil.openSystemBrowser(f.text);
                      },
                      onLongPress: () {
                        final imgBytes = QrScanView.qrPng(f.text);
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Image.memory(imgBytes),
                              ElevatedButton(
                                child: const Text('Save QrImage'),
                                onPressed: () async {
                                  MediaUtil.saveImageBytesToPhotosAlbum(
                                    imgBytes,
                                    'qr_code_${DateTime.now().toString()}.png',
                                  ).then((value) {
                                    if (value.isSuccess) {
                                      Navigator.of(context).pop();
                                      _showSnackBar('Save success');
                                    } else {
                                      _showSnackBar(
                                        'Save failed ${value.errorMessage}',
                                      );
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      icon: Icon(Icons.web),
                    ),
                    title: Text('Web Open'),
                    subtitle: TextField(controller: f),
                    trailing: IconButton(
                      onPressed: () async {
                        ShareUtil.openSystemBrowser(f.text);
                      },
                      icon: Icon(Icons.near_me),
                    ),
                  );
                },
              ),
              TextButton(
                child: const Text('QR Code Scan'),
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const QrScanView()),
                  ).then((value) {
                    if (value != null) {
                      _showSnackBar('scanning result:value=$value');
                    }
                  });
                },
              ),
              SizedBox(),
            ],
          ).toList(),
        ),
      ),
    );
  }

  void _showSnackBar(String message, {SnackBarAction? action}) {
    ScaffoldMessenger.maybeOf(
      context,
    )?.showSnackBar(SnackBar(content: Text(message), action: action));
  }
}
