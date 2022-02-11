# FlutterBoost demo

Very simple demo project for how the library [FlutterBoost](https://github.com/LuizSSB/flutter_boost/tree/fix/general) can be used to integrate Flutter into existing, all-native, iOS and Android apps.

Flutter's [Add-to-app](https://docs.flutter.dev/development/add-to-app) feature, which allows Flutter to be integrated into existing applications, is nice, but also extremely basic, requiring significant effort to be of any real use. FlutterBoost is a library that augments Add-to-app, although its documentation could receive some love.

FlutterBoost allows Flutter content to be mixed with native content in a variety of scenarios, however this demo focuses on what I believe will be the most common case: a native "page" that displays a Flutter page, that displays another page, either a native one or a Flutter one.

This repository is composed by three directories:

- `hyper_turbo`: Flutter module shared by the Android and iOS applications.
- `HyperTurboDroid`: Android application that uses `hyper_turbo`.
- `HyperTurboTouch`: iOS application that uses `hyper_turbo`.

Please Check out each directory's `README.md` for some explanation of its setup. Also please check out the comments in the code, I hope it helps.

## Setup

Requirements:

- All that one needs to develop iOS and Android apps
- Cocoapods
- Flutter SDK 2.8+

After cloning this repo:

 1. In the `hyper_turbo` directory, run  `$ flutter pub get`
 2. In the `HyperTurboTouch` directory, run `$ pod install`
