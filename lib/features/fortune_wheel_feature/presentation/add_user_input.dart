import 'package:arena_fortune_wheel/features/fortune_wheel_feature/data/fortune_wheel_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddUserInput extends ConsumerStatefulWidget {
  const AddUserInput({
    super.key,
  });

  @override
  ConsumerState<AddUserInput> createState() => _AddUserInputState();
}

class _AddUserInputState extends ConsumerState<AddUserInput> {
  late final TextEditingController _textController;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewState = ref.watch(
      fortuneWheelProvider.select(
        (state) => state.viewState,
      ),
    );
    return Row(
      spacing: 8,
      children: [
        Expanded(
          child: TextField(
            controller: _textController,
            decoration: const InputDecoration(
              hintText: 'Aggiungi partecipanti',
              border: OutlineInputBorder(),
            ),
            onTapOutside: (_) {
              FocusScope.of(context).unfocus();
            },
            maxLength: 1000,
            minLines: 1,
            maxLines: 10,
            enabled: viewState != ViewState.spinning,
          ),
        ),
        IconButton(
          onPressed: viewState == ViewState.spinning
              ? null
              : () {
                  FocusScope.of(context).unfocus();
                  final text = _textController.text.trim();
                  if (text.isEmpty) {
                    return;
                  }
                  ref
                      .read(fortuneWheelProvider.notifier)
                      .handleUserInput(_textController.text);
                  _textController.clear();
                },
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
