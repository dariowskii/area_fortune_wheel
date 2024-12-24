import 'package:arena_fortune_wheel/constants.dart';
import 'package:arena_fortune_wheel/features/fortune_wheel_feature/domain/participant.dart';
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
    required int lastSelected,
    required List<Partecipant> participants,
    required List<Color> associatedColors,
  }) = _FortuneWheelState;

  factory FortuneWheelState.initial() => FortuneWheelState(
        viewState: ViewState.initial,
        lastSelected: -1,
        associatedColors: kDefaultItemsColors,
        participants: [],
      );
}

@riverpod
class FortuneWheel extends _$FortuneWheel {
  @override
  FortuneWheelState build() => FortuneWheelState.initial();

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

  void reset() {
    ref.invalidateSelf();
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
            .map((e) => Partecipant(
                  name: e
                      .trim()
                      .replaceAll('\n', '')
                      .replaceAll(',', '')
                      .replaceAll(' ', ''),
                ))
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
        )
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
