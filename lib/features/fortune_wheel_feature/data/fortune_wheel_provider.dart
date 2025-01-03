import 'dart:async';
import 'dart:math' as math;

import 'package:arena_fortune_wheel/constants.dart';
import 'package:arena_fortune_wheel/extensions.dart';
import 'package:arena_fortune_wheel/features/fortune_wheel_feature/domain/participant.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fortune_wheel_provider.freezed.dart';
part 'fortune_wheel_provider.g.dart';

enum ViewState {
  initial,
  loading,
  spinning,
  finished,
}

@freezed
class FortuneWheelState with _$FortuneWheelState {
  const factory FortuneWheelState({
    required ViewState viewState,
    required List<Partecipant> participants,
    required List<Color> associatedColors,
    required List<int> extractedParticipants,
    Partecipant? lastSelected,
  }) = _FortuneWheelState;

  factory FortuneWheelState.initial() => const FortuneWheelState(
        viewState: ViewState.initial,
        associatedColors: kDefaultItemsColors,
        extractedParticipants: [],
        participants: [],
      );
}

@riverpod
class FortuneWheel extends _$FortuneWheel {
  late final StreamController<int> _streamController;
  late final ConfettiController _confettiController;
  StreamController<int> get streamController => _streamController;
  ConfettiController get confettiController => _confettiController;

  @override
  FortuneWheelState build() {
    _streamController = StreamController<int>();
    _confettiController = ConfettiController(duration: 5.seconds);

    ref.onDispose(_streamController.close);
    ref.onDispose(_confettiController.dispose);
    return FortuneWheelState.initial();
  }

  void handleUserInput(String value) {
    List<Partecipant> allPartecipants = [];
    if (state.viewState == ViewState.initial) {
      allPartecipants = [];
    } else {
      allPartecipants = [...state.participants];
    }
    allPartecipants.addAll(
      _getFromPattern(value: value, pattern: ['\n', ', ', ',', ' ']),
    );

    allPartecipants = allPartecipants
        .where((element) => element.name.isNotEmpty)
        .toSet()
        .toList(growable: false);

    if (allPartecipants.isEmpty) {
      return;
    }

    state = state.copyWith(
      viewState: ViewState.loading,
      participants: allPartecipants,
      associatedColors: _generateRandomColors(allPartecipants.length),
    );
  }

  void spin() {
    if (state.viewState == ViewState.spinning) {
      return;
    }

    state = state.copyWith(viewState: ViewState.spinning);
    final random = math.Random.secure();
    final newExtracted = random.nextInt(state.participants.length);

    state = state.copyWith(
      extractedParticipants: [...state.extractedParticipants, newExtracted],
    );
    _streamController.add(newExtracted);
  }

  void reset() {
    state = FortuneWheelState.initial();
  }

  void playConfetti() {
    _confettiController.play();
  }

  void finish({bool remove = true}) {
    if (state.viewState != ViewState.spinning) {
      return;
    }

    if (remove) {
      final newParticipants = [...state.participants];
      final removed = newParticipants.removeAt(
        state.extractedParticipants.last,
      );
      state = state.copyWith(
        viewState: ViewState.finished,
        lastSelected: removed,
        participants: newParticipants,
      );
      return;
    }

    final lastSelected = state.participants[state.extractedParticipants.last];
    state = state.copyWith(
      viewState: ViewState.finished,
      lastSelected: lastSelected,
    );
  }

  Partecipant getLatestWinner() {
    return state.participants[state.extractedParticipants.last];
  }

  void removeParticipant(int index) {
    final List<Partecipant> allPartecipants = [...state.participants];
    allPartecipants.removeAt(index);

    state = state.copyWith(
      participants: allPartecipants,
      associatedColors: _generateRandomColors(allPartecipants.length),
    );
  }

  List<Partecipant> _getFromPattern({
    required String value,
    required List<String> pattern,
  }) {
    for (final p in pattern) {
      if (value.contains(p)) {
        return value
            .split(p)
            .map((e) {
              return e
                  .trim()
                  .replaceAll('\n', '')
                  .replaceAll(',', '')
                  .replaceAll(' ', '');
            })
            .where((e) => e.isNotEmpty)
            .map(Partecipant.named)
            .toList(growable: false);
      }
    }

    if (value.isNotEmpty) {
      return [
        Partecipant(
          name: value
              .trim()
              .replaceAll('\n', '')
              .replaceAll(',', '')
              .replaceAll(' ', ''),
        ),
      ];
    }

    return [];
  }

  List<Color> _generateRandomColors(int length) {
    List<Color> primaries = [];
    for (int i = 0; i < length; i++) {
      primaries.add(Colors.primaries[i % Colors.primaries.length]);
    }

    primaries.shuffle();
    return primaries;
  }
}
