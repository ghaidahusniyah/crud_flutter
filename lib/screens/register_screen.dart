import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/user.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>(); // Tambahkan GlobalKey untuk Form
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _selectedRole;

  final _apiService = ApiService();

  void _register() async {
    if (_formKey.currentState!.validate()) { // Validasi inputan
      try {
        final user = await _apiService.register(
          _nameController.text,
          _emailController.text,
          _passwordController.text,
          _selectedRole ?? '', // Gunakan role yang dipilih atau string kosong jika null
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Register berhasil: ${user.name} sebagai ${user.role}')),
        );
        Navigator.pop(context); // kembali ke login
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Register gagal: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Tambahkan Form dengan key
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nama'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Masukkan email yang valid';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';
                  }
                  if (value.length < 6) {
                    return 'Password harus minimal 6 karakter';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value!;
                  });
                },
                decoration: InputDecoration(labelText: 'Pilih Role'),
                items: ['anggota', 'admin', 'petugas'].map((role) {
                  return DropdownMenuItem(value: role, child: Text(role));
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Role harus dipilih';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _register,
                child: Text('Daftar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
