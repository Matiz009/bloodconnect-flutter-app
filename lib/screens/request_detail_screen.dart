import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/blood_request_model.dart';
import '../services/firestore_service.dart';

class RequestDetailScreen extends StatelessWidget {
  final BloodRequest request;
  const RequestDetailScreen({super.key, required this.request});

  void _callDonor() async {
    final uri = Uri.parse('tel:${request.requesterPhone}');
    if (await canLaunchUrl(uri)) launchUrl(uri);
  }

  void _whatsApp() async {
    final uri = Uri.parse('https://wa.me/${request.requesterPhone}');
    if (await canLaunchUrl(uri)) launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Detail'),
        backgroundColor: const Color(0xFFD32F2F),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: const Color(0xFFD32F2F),
                child: Text(
                  request.bloodGroup,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _infoRow(Icons.person, 'Name', request.requesterName),
            _infoRow(Icons.local_hospital, 'Hospital', request.hospital),
            _infoRow(Icons.location_city, 'City', request.city),
            if (request.note.isNotEmpty)
              _infoRow(Icons.notes, 'Note', request.note),
            _infoRow(
              Icons.access_time,
              'Posted',
              '${request.createdAt.day}/${request.createdAt.month}/${request.createdAt.year}',
            ),
            const Spacer(),
            const Text(
              'Contact Requester',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _callDonor,
                    icon: const Icon(Icons.call, color: Color(0xFFD32F2F)),
                    label: const Text(
                      'Call',
                      style: TextStyle(color: Color(0xFFD32F2F)),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Color(0xFFD32F2F)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _whatsApp,
                    icon: const Icon(Icons.chat, color: Colors.white),
                    label: const Text(
                      'WhatsApp',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25D366),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFFD32F2F), size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }
}
