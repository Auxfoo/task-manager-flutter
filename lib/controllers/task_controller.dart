import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/task.dart';

class TaskController extends GetxController {
  final _box = GetStorage();
  final _key = 'tasks';

  final tasks = <Task>[].obs;
  final searchQuery = ''.obs;
  final selectedCategory = Rxn<Category>();
  final selectedPriority = Rxn<Priority>();
  final showCompleted = true.obs;

  List<Task> get filteredTasks {
    return tasks.where((task) {
      // Search filter
      if (searchQuery.value.isNotEmpty) {
        final query = searchQuery.value.toLowerCase();
        if (!task.title.toLowerCase().contains(query) &&
            !task.description.toLowerCase().contains(query)) {
          return false;
        }
      }
      // Category filter
      if (selectedCategory.value != null &&
          task.category != selectedCategory.value) {
        return false;
      }
      // Priority filter
      if (selectedPriority.value != null &&
          task.priority != selectedPriority.value) {
        return false;
      }
      // Completed filter
      if (!showCompleted.value && task.isCompleted) {
        return false;
      }
      return true;
    }).toList()..sort((a, b) {
      // Sort by completion, then priority
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }
      return a.priority.index.compareTo(b.priority.index);
    });
  }

  @override
  void onInit() {
    super.onInit();
    _loadTasks();
  }

  void _loadTasks() {
    final data = _box.read<List>(_key);
    if (data != null) {
      tasks.value = data
          .map((e) => Task.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
  }

  void _saveTasks() {
    _box.write(_key, tasks.map((t) => t.toJson()).toList());
  }

  void addTask(Task task) {
    tasks.add(task);
    _saveTasks();
  }

  void updateTask(Task task) {
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      tasks[index] = task;
      tasks.refresh();
      _saveTasks();
    }
  }

  void deleteTask(String id) {
    tasks.removeWhere((t) => t.id == id);
    _saveTasks();
  }

  void toggleComplete(String id) {
    final index = tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      tasks[index].isCompleted = !tasks[index].isCompleted;
      tasks.refresh();
      _saveTasks();
    }
  }

  Task? getTaskById(String id) {
    try {
      return tasks.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  void setSearchQuery(String query) => searchQuery.value = query;
  void setCategory(Category? cat) => selectedCategory.value = cat;
  void setPriority(Priority? pri) => selectedPriority.value = pri;
  void toggleShowCompleted() => showCompleted.value = !showCompleted.value;
  void clearFilters() {
    selectedCategory.value = null;
    selectedPriority.value = null;
    showCompleted.value = true;
  }
}
