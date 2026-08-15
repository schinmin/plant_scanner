# Plant Scanner App

A Flutter application for plant scanning, crop-market information, and farm simulations.

## Firebase configuration

The app initializes Firebase with the generated options committed at
`lib/firebase_options.dart`. Android therefore does not require a local
`android/app/google-services.json` file to compile or initialize the default
Firebase app.

Regenerate the shared options after changing the Firebase project or adding an
app target:

```sh
flutterfire configure --out=lib/firebase_options.dart
```

Review Firebase Security Rules and API-key restrictions whenever the generated
client configuration changes. Never commit service-account credentials or
other server-side secrets.

## Local verification

```sh
flutter pub get
dart analyze
flutter test
flutter build apk --debug
```

## Debug notification test

Debug builds schedule a local notification 10 seconds after every app launch.
The schedule is calculated from the current time, so no date or clock value
needs to be edited. Repeated launches replace the previous pending test instead
of creating duplicates. Release builds do not run this helper.

The delay can be adjusted with `QuickTest.defaultDelay` in
`lib/core/notifications/noti_test.dart`.

---

## မြန်မာဘာသာ

ဤ Flutter application သည် အပင်ရောဂါစစ်ဆေးခြင်း၊ သီးနှံဈေးကွက်အချက်အလက်များ ကြည့်ရှုခြင်းနှင့် စိုက်ပျိုးရေး simulation များ ပြုလုပ်ခြင်းအတွက် ဖြစ်သည်။

### Firebase ပြင်ဆင်သတ်မှတ်ခြင်း

App သည် `lib/firebase_options.dart` တွင် commit လုပ်ထားသော generated options ဖြင့် Firebase ကို initialize လုပ်သည်။ ထို့ကြောင့် Android တွင် compile လုပ်ရန် သို့မဟုတ် default Firebase app ကို initialize လုပ်ရန် local `android/app/google-services.json` ဖိုင် မလိုအပ်ပါ။

Firebase project ပြောင်းခြင်း သို့မဟုတ် app target အသစ်ထည့်ခြင်း ပြုလုပ်ပြီးနောက် shared options ကို အောက်ပါ command ဖြင့် ပြန်လည် generate လုပ်ပါ။

```sh
flutterfire configure --out=lib/firebase_options.dart
```

Generated client configuration ပြောင်းလဲသည့်အခါ Firebase Security Rules နှင့် API-key restrictions များကို ပြန်လည်စစ်ဆေးပါ။ Service-account credentials သို့မဟုတ် server-side secrets များကို commit မလုပ်ပါနှင့်။

### Local စစ်ဆေးမှု

```sh
flutter pub get
dart analyze
flutter test
flutter build apk --debug
```

### Debug notification စမ်းသပ်မှု

Debug build ဖြင့် app ဖွင့်တိုင်း ၁၀ စက္ကန့်အကြာတွင် local notification တစ်ခုကို schedule လုပ်သည်။ လက်ရှိအချိန်မှ အလိုအလျောက်တွက်ချက်သောကြောင့် ရက်စွဲ သို့မဟုတ် နာရီကို ပြင်ရန်မလိုပါ။ App ကို ထပ်ဖွင့်ပါက pending test အဟောင်းကို အစားထိုးပြီး notification အများအပြား မစုစည်းစေပါ။ Release build တွင် ဤ helper ကို မလုပ်ဆောင်ပါ။

စောင့်ဆိုင်းချိန်ကို `lib/core/notifications/noti_test.dart` ရှိ `QuickTest.defaultDelay` ဖြင့် ပြောင်းလဲနိုင်သည်။
