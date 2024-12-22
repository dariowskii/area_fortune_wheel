import 'package:freezed_annotation/freezed_annotation.dart';

part 'participant.freezed.dart';
part 'participant.g.dart';

@freezed
class Partecipant with _$Partecipant {
  const factory Partecipant({
    required String name,
  }) = _Partecipant;

  factory Partecipant.fromJson(Map<String, dynamic> json) =>
      _$PartecipantFromJson(json);
}
