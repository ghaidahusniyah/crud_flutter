import 'dart:convert';

        import 'package:http/http.dart' as http;
        import '../models/materi.dart';
        import '../models/user.dart';
        import 'auth_service.dart';

        class ApiService {
          // URL dasar API. Ganti IP jika menggunakan emulator atau device fisik
          static const String _baseUrl = "http://127.0.0.1:8000/api";

        Future<User> login(String email, String password) async {
          final response = await http.post(
            Uri.parse('$_baseUrl/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': email,
              'password': password
            }),
          );

          if (response.statusCode == 200) {
            final json = jsonDecode(response.body);

            // Simpan token ke AuthService
            AuthService().setToken(json['token']);

            return User.fromJson(json['user']);
          } else {
            throw Exception('Login failed: ${response.body}');
          }
        }

        Future<User> register(String name, String email, String password, String role) async {
          final response = await http.post(
            Uri.parse('$_baseUrl/register'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'name': name,
              'email': email,
              'password': password,
              'role': role,
            }),
          );

          if (response.statusCode == 200 || response.statusCode == 201) {
            final json = jsonDecode(response.body);
            return User.fromJson(json['user']);
          } else {
            throw Exception('Register failed: ${response.body}');
          }
        }
        
          // GET: Mengambil semua data Materi
        Future<List<Materi>> getMateri() async {
          try {
            final token = AuthService().token;

            final response = await http.get(
              Uri.parse('$_baseUrl/materi'),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token', // tambahkan token di header
              },
            );

            if (response.statusCode == 200) {
              List<dynamic> jsonResponse = json.decode(response.body);
              return jsonResponse.map((data) => Materi.fromJson(data)).toList();
            } else {
              throw Exception('Gagal memuat data materi');
            }
          } catch (e) {
            throw Exception('Error getMateri: $e');
          }
        }

          // POST: Membuat data Materi baru
          Future<void> createMateri({
            required String title,
            required String description,
            required String image,
          }) async {
            try {
              final token = AuthService().token;

              final response = await http.post(
                Uri.parse('$_baseUrl/materi'),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token', // tambahkan token di header
              },
                body: jsonEncode({
                  'title': title,
                  'description': description,
                  'image': image,
                }),
              );

              if (response.statusCode != 201) {
                throw Exception('Gagal membuat materi');
              }
            } catch (e) {
              throw Exception('Error createMateri: $e');
            }
          }

          // PUT: Mengupdate data Materi
          Future<void> updateMateri({
            required int id,
            required String title,
            required String description,
            required String image,
          }) async {
            try {
              final token = AuthService().token;

              final response = await http.put(
                Uri.parse('$_baseUrl/materi/$id'),
                headers: {
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer $token', 
                  },
                body: jsonEncode({
                  'title': title,
                  'description': description,
                  'image': image,
                }),
              );

              if (response.statusCode != 200) {
                throw Exception('Gagal memperbarui materi');
              }
            } catch (e) {
              throw Exception('Error updateMateri: $e');
            }
          }

          // DELETE: Menghapus data Materi
          Future<void> deleteMateri(int id) async {
            try {
              final token = AuthService().token;
              final response = await http.delete(
                Uri.parse('$_baseUrl/materi/$id'),
                headers: {
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer $token', 
                },
              );

              if (response.statusCode != 200) {
                throw Exception('Gagal menghapus materi');
              }
            } catch (e) {
              throw Exception('Error deleteMateri: $e');
            }
          }
        }
        