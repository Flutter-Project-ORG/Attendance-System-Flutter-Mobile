import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingViewModel{

  Future<void> onBoardingFinished()async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isFirstTime', false);
  }


}