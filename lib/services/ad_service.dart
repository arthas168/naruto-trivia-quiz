import 'dart:io';
import 'package:firebase_admob/firebase_admob.dart';

class AdMobService {

  String getAdMobAppId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-2334510780816542~6726672523';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-4062966075408687~1733187210';
    }
    return null;
  }

  String getInterstitialAdId() {
    if (Platform.isIOS) {
//      return '';
      return 'ca-app-pub-3940256099942544/4411468910';
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
        print("InterstitialAd event is $event");
      },
    );
  }
}