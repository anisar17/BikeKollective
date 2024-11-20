import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerifyEmailController extends GetxController {
  static VerifyEmailController get instance => Get.find();

  // Send email when on verify screen and set timer to redirect
  @override
  void onInit() {
    sendVerification();
    super.onInit();
  }
  // Send email verify link
  sendVerification() {
    try {
  
    } catch(e){
      print('Failed to verify email address');
    }
  }
  // Set timer

  // verify??
}