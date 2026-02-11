import 'package:get/get.dart';

class VideoSoundController extends GetxController {
  RxBool isMuted = true.obs;     // default muted

  void toggleMute() => isMuted.value = !isMuted.value;

  void setMute(bool value) => isMuted.value = value;
}
