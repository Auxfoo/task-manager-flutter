import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/task_controller.dart';
import '../controllers/theme_controller.dart';
import '../models/task.dart';
import '../routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.high:
        return Colors.red;
      case Priority.medium:
        return Colors.orange;
      case Priority.low:
        return Colors.green;
    }
  }

  IconData _getCategoryIcon(Category category) {
    switch (category) {
      case Category.work:
        return Icons.work;
      case Category.personal:
        return Icons.person;
      case Category.shopping:
        return Icons.shopping_cart;
      case Category.health:
        return Icons.favorite;
      case Category.other:
        return Icons.more_horiz;
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskController = Get.find<TaskController>();
    final themeController = Get.find<ThemeController>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(
                themeController.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              ),
              onPressed: themeController.toggleTheme,
              tooltip: 'Toggle Theme',
            ),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterSheet(context, taskController),
            tooltip: 'Filter',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: taskController.setSearchQuery,
              decoration: InputDecoration(
                hintText: 'Search tasks...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: Obx(
                  () => taskController.searchQuery.value.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            taskController.setSearchQuery('');
                          },
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ),
          ),
          // Active Filters
          Obx(() {
            final hasFilters =
                taskController.selectedCategory.value != null ||
                taskController.selectedPriority.value != null ||
                !taskController.showCompleted.value;
            if (!hasFilters) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                children: [
                  if (taskController.selectedCategory.value != null)
                    Chip(
                      label: Text(taskController.selectedCategory.value!.name),
                      onDeleted: () => taskController.setCategory(null),
                    ),
                  if (taskController.selectedPriority.value != null)
                    Chip(
                      label: Text(taskController.selectedPriority.value!.name),
                      onDeleted: () => taskController.setPriority(null),
                    ),
                  if (!taskController.showCompleted.value)
                    Chip(
                      label: const Text('Hide completed'),
                      onDeleted: taskController.toggleShowCompleted,
                    ),
                ],
              ),
            );
          }),
          // Task List
          Expanded(
            child: Obx(() {
              final tasks = taskController.filteredTasks;
              if (tasks.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.task_outlined,
                        size: 64,
                        color: colorScheme.outline,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No tasks found',
                        style: TextStyle(
                          fontSize: 18,
                          color: colorScheme.outline,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap + to add a new task',
                        style: TextStyle(color: colorScheme.outline),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: Duration(milliseconds: 300 + (index * 50)),
                    curve: Curves.easeOut,
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: Opacity(opacity: value, child: child),
                      );
                    },
                    child: Dismissible(
                      key: Key(task.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) {
                        taskController.deleteTask(task.id);
                        Get.snackbar(
                          'Deleted',
                          '${task.title} was deleted',
                          snackPosition: SnackPosition.BOTTOM,
                          duration: const Duration(seconds: 2),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _getPriorityColor(
                              task.priority,
                            ).withAlpha(51),
                            child: Icon(
                              _getCategoryIcon(task.category),
                              color: _getPriorityColor(task.priority),
                            ),
                          ),
                          title: Text(
                            task.title,
                            style: TextStyle(
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: task.isCompleted
                                  ? colorScheme.outline
                                  : null,
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: _getPriorityColor(
                                    task.priority,
                                  ).withAlpha(26),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  task.priorityText,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: _getPriorityColor(task.priority),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                task.categoryText,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colorScheme.outline,
                                ),
                              ),
                            ],
                          ),
                          trailing: Checkbox(
                            value: task.isCompleted,
                            onChanged: (_) =>
                                taskController.toggleComplete(task.id),
                          ),
                          onTap: () => Get.toNamed(
                            AppRoutes.taskDetails,
                            arguments: task.id,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(AppRoutes.addTask),
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
      ),
    );
  }

  void _showFilterSheet(BuildContext context, TaskController controller) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter Tasks',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    controller.clearFilters();
                    Navigator.pop(context);
                  },
                  child: const Text('Clear All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Category'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: Category.values.map((cat) {
                return Obx(
                  () => FilterChip(
                    label: Text(cat.name),
                    selected: controller.selectedCategory.value == cat,
                    onSelected: (selected) {
                      controller.setCategory(selected ? cat : null);
                    },
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text('Priority'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: Priority.values.map((pri) {
                return Obx(
                  () => FilterChip(
                    label: Text(pri.name),
                    selected: controller.selectedPriority.value == pri,
                    onSelected: (selected) {
                      controller.setPriority(selected ? pri : null);
                    },
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Obx(
              () => SwitchListTile(
                title: const Text('Show completed tasks'),
                value: controller.showCompleted.value,
                onChanged: (_) => controller.toggleShowCompleted(),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
