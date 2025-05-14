import 'package:flutter/material.dart';
import 'package:crud_flutter/services/api_service.dart';
import 'package:crud_flutter/models/materi.dart';
import 'package:intl/intl.dart';


class MateriScreen extends StatefulWidget {
  const MateriScreen({Key? key}) : super(key: key);

  @override
  _MateriScreenState createState() => _MateriScreenState();
}

class _MateriScreenState extends State<MateriScreen> {
  late Future<List<Materi>> _futureMateri;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadMateri();
  }

  void _loadMateri() {
    setState(() {
      _futureMateri = _apiService.getMateri();
    });
  }

  // Show add or edit form
  void _showMateriDialog({Materi? materi}) {
    final _formKey = GlobalKey<FormState>();
    String title = materi?.title ?? '';
    String description = materi?.description ?? '';
    String image = materi?.image ?? '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(materi == null ? 'Tambah Materi' : 'Edit Materi'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: title,
                    decoration: InputDecoration(
                      labelText: 'Judul',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Judul wajib diisi' : null,
                    onChanged: (value) => title = value,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    initialValue: description,
                    decoration: InputDecoration(
                      labelText: 'Deskripsi',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Deskripsi wajib diisi' : null,
                    onChanged: (value) => description = value,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    initialValue: image,
                    decoration: InputDecoration(
                      labelText: 'Image URL',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Image URL wajib diisi' : null,
                    onChanged: (value) => image = value,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  if (materi == null) {
                    await _apiService.createMateri(
                      title: title,
                      description: description,
                      image: image,
                    );
                  } else {
                    await _apiService.updateMateri(
                      id: materi.id,
                      title: title,
                      description: description,
                      image: image,
                    );
                  }
                  Navigator.of(context).pop();
                  _loadMateri();
                }
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Materi'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Materi>>(
        future: _futureMateri,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Belum ada data materi.'));
          } else {
            final materiList = snapshot.data!.reversed.toList();
            return ListView.builder(
              itemCount: materiList.length,
              itemBuilder: (context, index) {
                final materi = materiList[index];
                return GestureDetector(
                  onTap: () => _showMateriDialog(materi: materi),
                  child: Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(materi.image),
                        radius: 28,
                      ),
                      title: Text(
                        materi.title.toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(materi.description),
                            Text(
                              materi.updatedAt != materi.createdAt
                                  ? 'Update: ${DateFormat('dd MMM yyyy, HH:mm').format(materi.updatedAt)}'
                                  : 'Added: ${DateFormat('dd MMM yyyy, HH:mm').format(materi.createdAt)}',
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await _apiService.deleteMateri(materi.id);
                          _loadMateri();
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showMateriDialog(),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
    );
  }
}
