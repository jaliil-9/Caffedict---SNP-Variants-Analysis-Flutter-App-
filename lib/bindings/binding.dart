import 'package:caffedict/features/demo/controllers/demo_analysis_controller.dart';
import 'package:caffedict/features/analysis/controllers/home_controller.dart';
import 'package:caffedict/util/helpers/network_manager.dart';
import 'package:get/get.dart';

class GeneralBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => NetworkManager());
    Get.lazyPut(() => DemoAnalysisController());
  }
}
