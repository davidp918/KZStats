part of 'mode_cubit.dart';

class ModeState {
  String mode;
  bool nub;

  ModeState({
    required this.mode,
    required this.nub,
  });

  Map<String, dynamic> toMap() {
    return {
      'mode': mode,
      'nub': nub,
    };
  }

  factory ModeState.fromMap(Map<String, dynamic>? map) {
    //if (map == null) return null;

    return ModeState(
      mode: map!['mode'],
      nub: map['nub'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ModeState.fromJson(String source) =>
      ModeState.fromMap(json.decode(source));
}
