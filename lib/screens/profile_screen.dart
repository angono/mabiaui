import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(fontSize: 18)),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),

        children: [
          CircleAvatar(radius: 50),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.center,
            child: Text('User Name', style: TextStyle(fontSize: 16)),
          ),
          SizedBox(height: 10),
          SwitchListTile(
            title: Text('Dark Mode'),
            value: true,
            onChanged: (_) {},
          ),

          const Divider(height: 32),
          // Settings options
          _buildListTile(
            context,
            icon: Icons.person_outline,
            title: 'Edit Account',
          ),
          _buildListTile(
            context,
            icon: Icons.bookmark_border,
            title: 'Bookmarks',
          ),
          _buildListTile(
            context,
            icon: Icons.people_outline,
            title: 'Followers',
          ),
          _buildListTile(
            context,
            icon: Icons.lock_outline,
            title: 'Change Password',
          ),
          _buildListTile(
            context,
            icon: Icons.notifications_outlined,
            title: 'Notifications',
          ),
          _buildListTile(context, icon: Icons.help_outline, title: 'FAQ'),
          _buildListTile(
            context,
            icon: Icons.report_problem_outlined,
            title: 'Report a Problem',
          ),

          const Divider(height: 32),

          // Legal section
          _buildListTile(
            context,
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
          ),
          _buildListTile(
            context,
            icon: Icons.description_outlined,
            title: 'Terms & Conditions',
          ),

          const Divider(height: 32),

          // Logout
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.logout, color: Colors.red.shade400),
            ),
            title: Text(
              'Logout',
              style: TextStyle(
                color: Colors.red.shade400,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Icon(Icons.chevron_right, color: Colors.red.shade400),
            onTap: () {
              // Handle logout
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required String title,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.purple),
      ),
      title: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.grey.shade600),
      onTap: () {
        // Handle option tap
      },
    );
  }
}
