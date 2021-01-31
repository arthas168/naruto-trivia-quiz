import 'dart:io';
import 'package:firebase_admob/firebase_admob.dart';

class AdMobService {
  String getAdMobAppId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-4062966075408687~5090155904';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-4062966075408687~1733187210';
    }
    return null;
  }

  String getInterstitialAdId() {
    if (Platform.isIOS) {
//      return '';
      return 'ca-app-pub-4062966075408687/1722359171';
    } else if (Platform.isAndroid) {
//      return '';
      return "ca-app-pub-4062966075408687/9555836910";
    }
    return null;
  }

  InterstitialAd endOfQuizAd() {
    return InterstitialAd(
      adUnitId: getInterstitialAdId(),
      listener: (MobileAdEvent event) {
        // ignore: avoid_print
        print("InterstitialAd event is $event");
      },
    );
  }
}
