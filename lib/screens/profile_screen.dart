import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_nova/providers/user_provider.dart';
import 'package:task_nova/screens/home_screen.dart';
import 'package:task_nova/theme/app_theme.dart';
import 'package:task_nova/widgets/custom_text_field.dart';

class ProfileScreen extends StatefulWidget {
  final bool isSetupMode; // True for first-time use, False for editing

  const ProfileScreen({super.key, this.isSetupMode = false});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  int _selectedColorIndex = 0;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _nameController = TextEditingController(text: widget.isSetupMode ? "" : userProvider.userName);
    _selectedColorIndex = userProvider.avatarColorIndex;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      if (_nameController.text.trim().isEmpty) {
        return;
      }

      Provider.of<UserProvider>(context, listen: false).updateUserData(
        name: _nameController.text.trim(),
        colorIndex: _selectedColorIndex,
      );

      if (widget.isSetupMode) {
        // Go to Home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        // Just go back
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully!")),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const colors = UserProvider.avatarColors;
    
    return Scaffold(
      appBar: widget.isSetupMode
          ? null // No app bar for setup screen
          : AppBar(
              backgroundColor: AppTheme.backgroundColor,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.textPrimary),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text("Edit Profile", style: Theme.of(context).textTheme.headlineSmall),
              centerTitle: true,
            ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.isSetupMode) ...[
                  const Spacer(),
                  Text(
                    "Let's make it yours!",
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Tell us your name so we can address you properly.",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 48),
                ],
                
                // Avatar Preview
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: colors[_selectedColorIndex],
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: colors[_selectedColorIndex].withOpacity(0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        )
                      ]
                    ),
                    child: Center(
                      child: Icon(Icons.person, size: 50, color: Colors.white),
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                Text("Your Name", style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                CustomTextField(
                  hintText: "Enter your name",
                  controller: _nameController,
                  prefixIcon: Icons.person_outline,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return "Name is required";
                    if (val.length < 2) return "Name is too short";
                    return null;
                  },
                ),

                const SizedBox(height: 24),
                
                Text("Theme Color", style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                
                // Color Picker
                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: colors.length,
                    itemBuilder: (context, index) {
                      final isSelected = _selectedColorIndex == index;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedColorIndex = index;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 48,
                          height: 48,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            color: colors[index],
                            shape: BoxShape.circle,
                            border: isSelected 
                              ? Border.all(color: AppTheme.textPrimary, width: 3)
                              : null,
                          ),
                          child: isSelected 
                            ? const Center(child: Icon(Icons.check, color: Colors.white, size: 24))
                            : null,
                        ),
                      );
                    },
                  ),
                ),

                const Spacer(),
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(widget.isSetupMode ? "Continue" : "Update Profile", 
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      )
                    ),
                  ),
                ),
                if (widget.isSetupMode) const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
