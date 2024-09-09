import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final mainTextEntryProvider = StateProvider<String>((ref) => '');

class MainTextEntry extends ConsumerWidget {
  const MainTextEntry({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(
      decoration: const InputDecoration(
        // border: InputBorder.none,
        // filled: true,
        contentPadding: EdgeInsets.all(12),
        prefixIcon: Icon(Icons.search),
      ),
      onChanged: (value) {
        ref.read(mainTextEntryProvider.notifier).state = value;
      },
    );
  }
}
