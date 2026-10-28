import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailAlertsEnabled = true;
  bool _lowStockAlertsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F6FA),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Settings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              children: [
                _buildSection(
                  title: 'Store Information',
                  children: [
                    _buildTextField('Store Name', 'Krishi Saathi'),
                    const SizedBox(height: 16),
                    _buildTextField('Email', 'support@krishisaathi.com'),
                    const SizedBox(height: 16),
                    _buildTextField('Phone', '+91 98765 43210'),
                    const SizedBox(height: 16),
                    _buildTextField(
                      'Address',
                      'Rampur Kalan, Shahjahanpur, UP',
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSection(
                  title: 'Notifications',
                  children: [
                    _buildSwitchTile(
                      'Push Notifications',
                      'Receive push notifications for orders',
                      _notificationsEnabled,
                      (value) {
                        setState(() {
                          _notificationsEnabled = value;
                        });
                      },
                    ),
                    _buildSwitchTile(
                      'Email Alerts',
                      'Receive email notifications',
                      _emailAlertsEnabled,
                      (value) {
                        setState(() {
                          _emailAlertsEnabled = value;
                        });
                      },
                    ),
                    _buildSwitchTile(
                      'Low Stock Alerts',
                      'Get notified when stock is low',
                      _lowStockAlertsEnabled,
                      (value) {
                        setState(() {
                          _lowStockAlertsEnabled = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSection(
                  title: 'Payment Settings',
                  children: [
                    _buildListTile('Payment Methods', 'Manage payment options'),
                    _buildListTile('Tax Settings', 'Configure tax rates'),
                    _buildListTile('Currency', '₹ Indian Rupee'),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSection(
                  title: 'Security',
                  children: [
                    _buildListTile('Change Password', 'Update your password'),
                    _buildListTile('Two-Factor Authentication', 'Enable 2FA'),
                    _buildListTile('Activity Log', 'View login activity'),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Save Changes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String value) {
    return TextField(
      controller: TextEditingController(text: value),
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 13),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return SwitchListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.grey[600], fontSize: 12),
      ),
      value: value,
      onChanged: onChanged,
      activeThumbColor: const Color(0xFF2E7D32),
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildListTile(String title, String subtitle) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.grey[600], fontSize: 12),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      contentPadding: EdgeInsets.zero,
      onTap: () {},
    );
  }
}
