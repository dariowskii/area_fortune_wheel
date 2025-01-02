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
  late final TextEditingController _textController = TextEditingController();

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
      children: [
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                label: const Text('Aggiungi partecipanti'),
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.all(8),
                suffix: IconButton(
                  onPressed: viewState == ViewState.spinning
                      ? null
                      : () {
                          FocusScope.of(context).unfocus();
                          final text = _textController.text.trim();
                          _textController.clear();
                          if (text.isEmpty) {
                            return;
                          }

                          ref
                              .read(fortuneWheelProvider.notifier)
                              .handleUserInput(_textController.text);
                        },
                  icon: Icon(
                    Icons.send,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
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
        ),
      ],
    );
  }
}
