import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _auth = AuthService();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  String _selectedBloodGroup = 'A+';
  bool _loading = false;

  void _register() async {
    setState(() => _loading = true);
    final error = await _auth.register(
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text.trim(),
      name: _nameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      bloodGroup: _selectedBloodGroup,
      city: _cityCtrl.text.trim(),
    );
    setState(() => _loading = false);
    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _field(_nameCtrl, 'Full Name'),
            const SizedBox(height: 12),
            _field(_emailCtrl, 'Email', type: TextInputType.emailAddress),
            const SizedBox(height: 12),
            _field(_phoneCtrl, 'Phone Number', type: TextInputType.phone),
            const SizedBox(height: 12),
            _field(_cityCtrl, 'City'),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedBloodGroup,
              decoration: const InputDecoration(
                labelText: 'Blood Group',
                border: OutlineInputBorder(),
              ),
              items:
                  bloodGroups
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
              onChanged: (v) => setState(() => _selectedBloodGroup = v!),
            ),
            const SizedBox(height: 12),
            _field(_passCtrl, 'Password', obscure: true),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD32F2F),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child:
                    _loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                          'Register',
                          style: TextStyle(fontSize: 16),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController ctrl,
    String label, {
    TextInputType type = TextInputType.text,
    bool obscure = false,
  }) {
    return TextField(
      controller: ctrl,
      keyboardType: type,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
