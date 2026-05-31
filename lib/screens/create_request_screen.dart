import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/blood_request_model.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';
import '../utils/constants.dart';

class CreateRequestScreen extends StatefulWidget {
  final UserModel currentUser;
  const CreateRequestScreen({super.key, required this.currentUser});
  @override
  State<CreateRequestScreen> createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends State<CreateRequestScreen> {
  final _hospitalCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  final _firestoreService = FirestoreService();
  String _bloodGroup = 'A+';
  bool _loading = false;

  void _submit() async {
    if (_hospitalCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter hospital name')),
      );
      return;
    }
    setState(() => _loading = true);
    final request = BloodRequest(
      id: FirebaseFirestore.instance.collection('requests').doc().id,
      requesterId: widget.currentUser.uid,
      requesterName: widget.currentUser.name,
      requesterPhone: widget.currentUser.phone,
      bloodGroup: _bloodGroup,
      city: widget.currentUser.city,
      hospital: _hospitalCtrl.text.trim(),
      note: _noteCtrl.text.trim(),
      createdAt: DateTime.now(),
    );
    await _firestoreService.createRequest(request);
    setState(() => _loading = false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Blood'),
        backgroundColor: const Color(0xFFD32F2F),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _bloodGroup,
              decoration: const InputDecoration(
                labelText: 'Blood Group Needed',
                border: OutlineInputBorder(),
              ),
              items:
                  bloodGroups
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
              onChanged: (v) => setState(() => _bloodGroup = v!),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _hospitalCtrl,
              decoration: const InputDecoration(
                labelText: 'Hospital Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _noteCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Additional Note (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD32F2F),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child:
                    _loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                          'Post Request',
                          style: TextStyle(fontSize: 16),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
