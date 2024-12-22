import 'package:arena_fortune_wheel/features/fortune_wheel_feature/domain/participant.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fortune_wheel_provider.freezed.dart';
part 'fortune_wheel_provider.g.dart';

@freezed
class FortuneWheelState with _$FortuneWheelState {
  const factory FortuneWheelState({
    required int lastSelected,
    required List<Partecipant> participants,
  }) = _FortuneWheelState;
}

@riverpod
class FortuneWheel extends _$FortuneWheel {
  @override
  FortuneWheelState build() => const FortuneWheelState(
        lastSelected: -1,
        participants: [],
      );
}
