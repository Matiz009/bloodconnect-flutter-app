import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/blood_request_model.dart';
import '../models/user_model.dart';
import 'login_screen.dart';
import 'create_request_screen.dart';
import 'request_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _firestoreService = FirestoreService();
  final _authService = AuthService();
  UserModel? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() async {
    final user = await _authService.getLocalUser();
    setState(() => _currentUser = user);
  }

  void _logout() async {
    await _authService.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BloodConnect'),
        backgroundColor: const Color(0xFFD32F2F),
        foregroundColor: Colors.white,
        actions: [
          if (_currentUser != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _currentUser!.bloodGroup,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: StreamBuilder<List<BloodRequest>>(
        stream: _firestoreService.getRequests(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final requests = snapshot.data ?? [];
          final open = requests.where((r) => !r.isFulfilled).toList();

          if (open.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bloodtype_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 12),
                  Text(
                    'No active requests',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: open.length,
            itemBuilder:
                (_, i) => _RequestCard(
                  request: open[i],
                  currentUserId: _currentUser?.uid ?? '',
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RequestDetailScreen(request: open[i]),
                        ),
                      ),
                ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CreateRequestScreen(currentUser: _currentUser!),
              ),
            ),
        backgroundColor: const Color(0xFFD32F2F),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Request Blood'),
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final BloodRequest request;
  final String currentUserId;
  final VoidCallback onTap;

  const _RequestCard({
    required this.request,
    required this.currentUserId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFD32F2F),
          child: Text(
            request.bloodGroup,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
        title: Text(
          request.requesterName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${request.hospital} · ${request.city}'),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
