enum PathKind { clarity, strength, expansion, neutral }

class PathSnapshot {
  final double clarity;
  final double strength;
  final double expansion;
  final PathKind dominant;

  const PathSnapshot({
    required this.clarity,
    required this.strength,
    required this.expansion,
    required this.dominant,
  });

  factory PathSnapshot.initial() => const PathSnapshot(
        clarity: 0,
        strength: 0,
        expansion: 0,
        dominant: PathKind.neutral,
      );

  PathSnapshot copyWith({
    double? clarity,
    double? strength,
    double? expansion,
    PathKind? dominant,
  }) {
    return PathSnapshot(
      clarity: clarity ?? this.clarity,
      strength: strength ?? this.strength,
      expansion: expansion ?? this.expansion,
      dominant: dominant ?? this.dominant,
    );
  }

  Map<String, dynamic> toJson() => {
        'clarity': clarity,
        'strength': strength,
        'expansion': expansion,
        'dominant': dominant.name,
      };

  factory PathSnapshot.fromJson(Map<String, dynamic> json) {
    return PathSnapshot(
      clarity: (json['clarity'] as num?)?.toDouble() ?? 0,
      strength: (json['strength'] as num?)?.toDouble() ?? 0,
      expansion: (json['expansion'] as num?)?.toDouble() ?? 0,
      dominant: PathKind.values.firstWhere(
        (e) => e.name == json['dominant'],
        orElse: () => PathKind.neutral,
      ),
    );
  }
}
