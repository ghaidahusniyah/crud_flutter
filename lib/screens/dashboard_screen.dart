import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  final String name;
  final String email;

  const DashboardScreen({
    super.key,
    required this.name,
    required this.email,
  });

  void _logout(BuildContext context) {
    // Tambahkan logika untuk menghapus token atau sesi pengguna di sini
    // Misalnya, hapus token dari penyimpanan lokal jika menggunakan shared_preferences

    // Navigasi kembali ke layar login
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
            tooltip: 'Logout', // Tooltip untuk ikon logout
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.account_circle,
                    size: 80,
                    color: Colors.blue,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Welcome, $name!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    email,
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/materi');
                    },
                    child: Text('Lihat Materi'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
