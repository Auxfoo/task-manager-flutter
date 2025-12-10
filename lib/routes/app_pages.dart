import 'package:get/get.dart';
import '../screens/splash_screen.dart';
import '../screens/home_screen.dart';
import '../screens/add_task_screen.dart';
import '../screens/task_details_screen.dart';
import '../controllers/task_controller.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<TaskController>(() => TaskController());
      }),
    ),
    GetPage(name: AppRoutes.addTask, page: () => const AddTaskScreen()),
    GetPage(name: AppRoutes.taskDetails, page: () => const TaskDetailsScreen()),
  ];
}
