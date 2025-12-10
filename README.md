# Task Manager App

Flutter app with GetX for routing and state management.

## Features

### Core Screens
- Splash Screen
- Home Screen (task list)
- Add Task Screen
- Task Details Screen

### Extra Features
- Categories (Work, Personal, Shopping, Health, Other)
- Priority levels (High, Medium, Low)
- Search bar
- Dark mode toggle
- Animations on splash screen
- Filter by category/priority
- Custom theme colors
- Local storage (tasks saved on device)

## GetX Routing

We used named routes with GetX. Routes are in `lib/routes/app_routes.dart`:

```dart
Get.toNamed('/add-task');  // go to add task screen
Get.back();                 // go back
```

## GetX State Management

We used `.obs` for reactive state and `Obx()` to update the UI automatically:

```dart
final tasks = <Task>[].obs;  // observable list

Obx(() => ListView.builder(
  itemCount: controller.tasks.length,
))
```

## Run the App

```bash
flutter pub get
flutter run
```

## Team
- Ara Hikmat
- Azhy Alan
- Shad Salar
- Zheer Araz
