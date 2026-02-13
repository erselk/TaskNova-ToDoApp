import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:task_nova/providers/task_provider.dart';
import 'package:task_nova/providers/user_provider.dart';
import 'package:task_nova/screens/add_task_screen.dart';
import 'package:task_nova/screens/profile_screen.dart';
import 'package:task_nova/theme/app_theme.dart';
import 'package:task_nova/widgets/task_tile.dart';
import 'package:animate_do/animate_do.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedFilterIndex = 0; // 0: All, 1: Pending, 2: Completed

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );
        },
        child: const Icon(Icons.add, size: 32),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar Area
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Consumer<UserProvider>(
                    builder: (ctx, user, _) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello, ${user.userName}!",
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('EEEE, d MMMM').format(DateTime.now()),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  Consumer<UserProvider>(
                    builder: (ctx, user, _) => GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ProfileScreen()),
                        );
                      },
                      child: CircleAvatar(
                        radius: 24,
                        backgroundColor: user.currentAvatarColor.withOpacity(0.1),
                        child: Icon(Icons.person, color: user.currentAvatarColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Filter Chips
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  _buildFilterChip("All Tasks", 0),
                  const SizedBox(width: 12),
                  _buildFilterChip("Pending", 1),
                  const SizedBox(width: 12),
                  _buildFilterChip("Completed", 2),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Tasks List
            Expanded(
              child: Consumer<TaskProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final tasks = _selectedFilterIndex == 0
                      ? provider.tasks
                      : _selectedFilterIndex == 1
                          ? provider.pendingTasks
                          : provider.completedTasks;

                  if (tasks.isEmpty) {
                    return FadeIn(
                      duration: const Duration(milliseconds: 500),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.assignment_turned_in_outlined, 
                              size: 64, color: Colors.grey.shade300),
                            const SizedBox(height: 16),
                            Text(
                              "No tasks found",
                              style: TextStyle(color: Colors.grey.shade400),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      // Swipe to delete
                      return Dismissible(
                        key: Key(task.id),
                        background: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: AppTheme.errorColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 24),
                          child: Icon(Icons.delete_outline, color: AppTheme.errorColor),
                        ),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          provider.deleteTask(task.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("${task.title} deleted")),
                          );
                        },
                        child: FadeInUp( // Subtle fade in up only for initial load
                          from: 20,
                          duration: const Duration(milliseconds: 300),
                          delay: Duration(milliseconds: index * 50),
                          child: TaskTile(task: task),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, int index) {
    final isSelected = _selectedFilterIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilterIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey.shade200,
          ),
          boxShadow: isSelected 
            ? [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ] 
            : [],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : AppTheme.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
