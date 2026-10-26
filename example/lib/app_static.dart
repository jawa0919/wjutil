class AppStatic {
  AppStatic._();
  // 适合UI的尺寸
  static const designWidth = 1080.0;
  static const designHeight = 2340.0;
  static final designLandscape = designWidth > designHeight;
  // App Store id
  static const String appStoreId = '';
  // 获取App Store更新信息
  static const String appStoreLookup = 'https://itunes.apple.com/cn/lookup?id=';
  // icp备案号
  static const String icpNumber = 'AAA-BBB-CCC';
  // icp备案号查询链接
  static const String icpQueryUrl = 'https://beian.miit.gov.cn/';
  // 版权标志
  static const String copyrightCode = 'Copyright © 2006-2026 flutter.cn';

  /// 服务器列表
  static const serverMap = {
    'prod': {
      'mainApi': 'https://flutter.cn',
      'subApi': 'https://flutter.cn',
      'h5Host': 'https://flutter.cn',
      'agreementUrl': 'https://flutter.cn',
      'privacyUrl': 'https://flutter.cn',
    },
    'test': {
      'mainApi': 'https://flutter.cn',
      'subApi': 'https://flutter.cn',
      'h5Host': 'https://flutter.cn',
      'agreementUrl': 'https://flutter.cn',
      'privacyUrl': 'https://flutter.cn',
    },
    'dev': {
      'mainApi': 'https://flutter.cn',
      'subApi': 'https://flutter.cn',
      'h5Host': 'https://flutter.cn',
      'agreementUrl': 'https://flutter.cn',
      'privacyUrl': 'https://flutter.cn',
    },
    'custom': {
      'mainApi': '',
      'subApi': '',
      'h5Host': '',
      'agreementUrl': '',
      'privacyUrl': '',
    },
  };
}
