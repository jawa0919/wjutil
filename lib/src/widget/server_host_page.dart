import 'package:material_ui/material_ui.dart';

class ServerHostPage extends StatelessWidget {
  final Map<String, Map<String, String>> map;
  final String? currentKey;
  final void Function(String k, Map<String, String> v)? onChange;
  const ServerHostPage(this.map, {super.key, this.currentKey, this.onChange});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ServerHostPage')),
      body: SingleChildScrollView(
        physics: null,
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Text(
                    'Change Server Host',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text('Server Setting', style: TextStyle(fontSize: 16)),
                ),
                ...map.keys.map((e) => _buildServer(context, e)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildServer(BuildContext context, String env) {
    final info = map[env]!;
    return GestureDetector(
      onTap: () async {
        if (env == 'custom') {
          _buildCustomServerEditView(context, info);
          return;
        }
        onChange?.call(env, info);
      },
      child: SizedBox(
        width: 375,
        child: Card(
          margin: EdgeInsets.only(top: 15),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${currentKey == env ? "(current)" : ""}$env',
                  style: TextStyle(
                    fontSize: 18,
                    color: currentKey == env
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                ...info.keys.map((k) {
                  final v = info[k];
                  return Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Text(
                      '$k: ${v ?? ''}',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 14),
                    ),
                  );
                }),
                FilledButton(
                  onPressed: () {
                    _buildCustomServerEditView(context, info);
                  },
                  child: Text('Duplicate Custom'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _buildCustomServerEditView(
    BuildContext context,
    Map<String, String> info,
  ) async {
    final ctMap = {
      for (var e in info.keys) e: TextEditingController(text: info[e] ?? ''),
    };
    await showDialog(
      context: context,
      builder: (context) => getCustomServerEditView(
        context,
        'customServer',
        ctMap,
        () {
          Navigator.of(context).pop();
        },
        () async {
          for (var e in ctMap.keys) {
            if (ctMap[e]?.text.isEmpty ?? true) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('${e}不能为空!')));
              return;
            }
          }
          onChange?.call('custom', {
            for (var e in ctMap.keys) e: ctMap[e]?.text ?? '',
          });
        },
      ),
    );
  }

  Widget getCustomServerEditView(
    BuildContext context,
    String title,
    Map<String, TextEditingController> ctList,
    Function() cancel,
    Function() accept, {
    String cancelText = 'cancel',
    String acceptText = 'accept',
  }) {
    return Center(
      child: AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: Duration(milliseconds: 100),
        child: SingleChildScrollView(
          child: Card(
            child: Container(
              width: 321,
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black.withAlpha(230),
                      fontSize: 18,
                    ),
                  ),
                  ...ctList.keys.map(
                    (k) => Padding(
                      padding: EdgeInsets.only(top: 10, left: 15, right: 15),
                      child: TextField(
                        controller: ctList[k]!,
                        maxLines: 1,
                        decoration: InputDecoration(
                          prefixIcon: UnconstrainedBox(child: Text('$k: ')),
                          counterText: '',
                          hintText: k,
                        ),
                      ),
                    ),
                  ),
                  Container(height: 1, color: Colors.black.withAlpha(25)),
                  SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: cancel,
                          child: SizedBox(
                            width: 160,
                            child: Text(
                              cancelText,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        Container(width: 1, color: Colors.black.withAlpha(25)),
                        GestureDetector(
                          onTap: accept,
                          child: SizedBox(
                            width: 160,
                            child: Text(
                              acceptText,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
