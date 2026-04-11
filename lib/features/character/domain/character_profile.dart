final class CharacterProfile {
  CharacterProfile({
    required this.id,
    required this.level,
    required this.xp,
    required this.stamina,
    required this.intelligence,
    required this.discipline,
    required this.creativity,
    required this.updatedAt,
    this.name,
    this.skinState,
    this.bodyType,
  }) {
    if (id.trim().isEmpty) {
      throw ArgumentError.value(
        id,
        'id',
        'Character profile id cannot be blank.',
      );
    }
    if (level <= 0) {
      throw ArgumentError.value(level, 'level', 'Level must be positive.');
    }
    if (xp < 0 ||
        stamina < 0 ||
        intelligence < 0 ||
        discipline < 0 ||
        creativity < 0) {
      throw ArgumentError('Character numeric attributes cannot be negative.');
    }
  }

  final String id;
  final String? name;
  final int level;
  final int xp;
  final int stamina;
  final int intelligence;
  final int discipline;
  final int creativity;
  final String? skinState;
  final String? bodyType;
  final DateTime updatedAt;

  CharacterProfile copyWith({
    String? id,
    String? name,
    bool clearName = false,
    int? level,
    int? xp,
    int? stamina,
    int? intelligence,
    int? discipline,
    int? creativity,
    String? skinState,
    bool clearSkinState = false,
    String? bodyType,
    bool clearBodyType = false,
    DateTime? updatedAt,
  }) {
    return CharacterProfile(
      id: id ?? this.id,
      name: clearName ? null : name ?? this.name,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      stamina: stamina ?? this.stamina,
      intelligence: intelligence ?? this.intelligence,
      discipline: discipline ?? this.discipline,
      creativity: creativity ?? this.creativity,
      skinState: clearSkinState ? null : skinState ?? this.skinState,
      bodyType: clearBodyType ? null : bodyType ?? this.bodyType,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
