import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'participant.freezed.dart';
part 'participant.g.dart';

@freezed
class Partecipant with _$Partecipant {
  const factory Partecipant({
    required String uuid,
    required String name,
  }) = _Partecipant;

  factory Partecipant.fromJson(Map<String, dynamic> json) =>
      _$PartecipantFromJson(json);

  factory Partecipant.named(String name) => Partecipant(
        uuid: const Uuid().v4(),
        name: name,
      );
}
