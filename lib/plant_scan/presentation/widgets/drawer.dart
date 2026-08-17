import 'package:flutter/material.dart';
import 'package:plant_scanner_app/auth/presentation/screens/register_screen.dart';
import 'package:plant_scanner_app/core/database/shared_prefercences.dart';
import 'package:plant_scanner_app/core/network/api_service.dart';

class ProfileDrawer extends StatefulWidget {
  final bool isLoggedIn;
  final VoidCallback onAuthToggle;

  const ProfileDrawer({
    super.key,
    required this.isLoggedIn,
    required this.onAuthToggle,
  });

  @override
  State<ProfileDrawer> createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<ProfileDrawer> {
  final ApiService apiService = ApiService();

  bool _isLoading = false;
  String? _name;
  String? _phone;
  String? _errorMessage;
  String? _createdAt;

  @override
  void initState() {
    super.initState();
    if (widget.isLoggedIn) {
      _fetchProfileData();
    }
  }

  Future<void> _fetchProfileData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Fetch token from SharedPreferences (Adjust key name if different)
      //final String? token = await localStorageService.getUserToken();

      final response = await apiService.dio.get(
        'profile', // ⚠️ Replace with your full base URL
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;

        setState(() {
          _name = data['name'] ?? 'User';
          _phone = data['phone'] ?? 'Farmer';
          _createdAt = data['createdAt'] ?? DateTime.now();
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load profile ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Header / Profile Info Section
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.green.shade700),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                size: 40,
                color: Theme.of(context).primaryColor,
              ),
            ),
            accountName: Text(
              widget.isLoggedIn
                  ? (_isLoading ? 'Loading...' : (_name ?? 'Guest User'))
                  : 'Guest User',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(
              widget.isLoggedIn
                  ? (_isLoading ? 'Please wait...' : (_phone ?? ''))
                  : 'Sign in to manage your profile',
            ),
          ),

          // Details Section (Visible when logged in)
          if (widget.isLoggedIn) ...[
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_errorMessage != null)
              ListTile(
                leading: const Icon(Icons.error_outline, color: Colors.red),
                title: Text(_errorMessage!),
                trailing: IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _fetchProfileData,
                ),
              )
            else ...[
              ListTile(
                leading: const Icon(Icons.phone),
                title: const Text('Phone Number'),
                subtitle: Text(_phone ?? 'Not provided'),
              ),
              const Divider(),
            ],
          ],

          const Spacer(),

          // Login / Logout Button at Bottom
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.isLoggedIn ? Colors.red : Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  await localStorageService.clearAll();
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterPage(),
                      ),
                      (route) => false,
                    );
                  }
                },
                icon: Icon(widget.isLoggedIn ? Icons.logout : Icons.login),
                label: Text(
                  widget.isLoggedIn ? 'Log Out' : 'Log In',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
