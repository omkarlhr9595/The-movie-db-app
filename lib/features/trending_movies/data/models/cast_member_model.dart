import 'package:cine_parker/features/trending_movies/domain/entities/cast_member.dart';

class CastMemberModel {
  const CastMemberModel({
    required this.id,
    required this.name,
    required this.character,
    this.profilePath,
  });

  factory CastMemberModel.fromJson(Map<String, dynamic> json) {
    return CastMemberModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: (json['name'] ?? '').toString(),
      character: (json['character'] ?? '').toString(),
      profilePath: json['profile_path']?.toString(),
    );
  }

  final int id;
  final String name;
  final String character;
  final String? profilePath;

  CastMember toEntity() => CastMember(id: id, name: name, character: character, profilePath: profilePath);
}
