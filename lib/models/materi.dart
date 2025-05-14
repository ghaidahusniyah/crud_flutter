// File: models/materi.dart

        class Materi {
          final int id;
          final String title;
          final String description;
          final String image;
          final DateTime createdAt;
          final DateTime updatedAt;

          Materi({
            required this.id,
            required this.title,
            required this.description,
            required this.image,
            required this.createdAt,
            required this.updatedAt,
          });

          factory Materi.fromJson(Map<String, dynamic> json) {
            return Materi(
              id: json['id'],
              title: json['title'],
              description: json['description'],
              image: json['image'],
              createdAt: DateTime.parse(json['created_at']),
              updatedAt: DateTime.parse(json['updated_at']),
            );
          }
        }
        