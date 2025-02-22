import 'dart:async';
import 'dart:math' as math;

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
    required List<Partecipant> participants,
    required List<Color> associatedColors,
    required List<Partecipant> extractedParticipants,
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
  StreamController<int> get streamController => _streamController;

  @override
  FortuneWheelState build() {
    _streamController = StreamController<int>();

    ref.onDispose(_streamController.close);
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
      _getFromPattern(value: value, pattern: '\n'),
    );

    allPartecipants =
        allPartecipants.where((element) => element.name.isNotEmpty).toList();

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
    if (state.viewState == ViewState.spinning ||
        state.participants.length < 2) {
      return;
    }

    state = state.copyWith(viewState: ViewState.spinning);
    final random = math.Random.secure();
    final newExtractedIndex = random.nextInt(state.participants.length);
    final newExtracted = state.participants[newExtractedIndex];

    state = state.copyWith(
      extractedParticipants: [...state.extractedParticipants, newExtracted],
    );
    _streamController.add(newExtractedIndex);
  }

  void reset() {
    state = FortuneWheelState.initial();
  }

  void finish({bool remove = true}) {
    if (state.viewState != ViewState.spinning) {
      return;
    }

    if (remove) {
      final newParticipants = [...state.participants];
      newParticipants.remove(state.extractedParticipants.last);
      state = state.copyWith(
        viewState: ViewState.finished,
        lastSelected: state.extractedParticipants.last,
        participants: newParticipants,
      );
      return;
    }

    state = state.copyWith(
      viewState: ViewState.finished,
      lastSelected: state.extractedParticipants.last,
    );
  }

  Partecipant getLatestWinner() {
    return state.extractedParticipants.lastOrNull ??
        const Partecipant(name: 'Nessuno');
  }

  void removeParticipant(int index) {
    final allPartecipants = [...state.participants]..removeAt(index);

    state = state.copyWith(
      participants: allPartecipants,
      associatedColors: _generateRandomColors(allPartecipants.length),
    );
  }

  List<Partecipant> _getFromPattern({
    required String value,
    required String pattern,
  }) {
    if (value.contains(pattern)) {
      return value
          .split(pattern)
          .map(_cleanName)
          .where((e) => e.isNotEmpty)
          .map(Partecipant.named)
          .toList();
    }

    if (value.isNotEmpty) {
      return [
        Partecipant(
          name: _cleanName(value),
        ),
      ];
    }

    return [];
  }

  String _cleanName(String input) => input.trim().replaceAll('\n', '');

  List<Color> _generateRandomColors(int length) {
    List<Color> primaries = [];
    for (int i = 0; i < length; i++) {
      primaries.add(Colors.primaries[i % Colors.primaries.length]);
    }

    primaries.shuffle();
    return primaries;
  }
}
