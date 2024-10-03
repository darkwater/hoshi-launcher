import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fuzzywuzzy/algorithms/weighted_ratio.dart';
import 'package:fuzzywuzzy/applicable.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:fuzzywuzzy/model/extracted_result.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hoshi_launcher/main.dart';
import 'package:hoshi_launcher/preferences.dart';
import 'package:hoshi_launcher/widgets/main_text_entry.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xdg_desktop_entries/xdg_desktop_entries.dart';
import 'package:xdg_icons/xdg_icons.dart';

part 'results_list.g.dart';

@riverpod
Future<List<DesktopEntry>> desktopEntries(DesktopEntriesRef ref) async {
  return await DesktopEntry.fromDirectories(DesktopEntry.standardDirectories);
}

@riverpod
Stream<List<String>> pinnedEntryPaths(PinnedEntryPathsRef ref) {
  return prefs.getStringList(Preferences.pinnedEntryPaths, defaultValue: []);
}

@riverpod
List<ExtractedResult<DesktopEntry>> filteredDesktopEntries(
  FilteredDesktopEntriesRef ref,
) {
  final search = ref.watch(mainTextEntryProvider);
  if (search.isEmpty) {
    return [];
  }

  final entries = ref.watch(desktopEntriesProvider);
  if (!entries.hasValue) {
    return [];
  }

  final results = extractTop(
    query: search,
    choices: entries.requireValue,
    limit: 50,
    cutoff: 50,
    getter: (entry) => [entry.name, entry.exec, entry.comment]
        .where((s) => s != null)
        .join("\n"),
    ratio: CustomRatio(),
  );

  final pinned = ref.watch(pinnedEntryPathsProvider).valueOrNull ?? [];

  results.sort((a, b) {
    if (pinned.contains(a.choice.path) && !pinned.contains(b.choice.path)) {
      return -1;
    }

    if (pinned.contains(b.choice.path) && !pinned.contains(a.choice.path)) {
      return 1;
    }

    return b.score.compareTo(a.score) * 2 +
        b.choice.name!.compareTo(a.choice.name!);
  });

  return results;
}

class CustomRatio extends Applicable {
  @override
  int apply(String s1, String s2) {
    if (s2.split("\n").any((s) => s.startsWith(s1))) {
      return 100;
    }

    if (s2.contains(s1)) {
      return 95;
    }

    return ((const WeightedRatio()).apply(s1, s2) / 2).round();
  }
}

class ResultsList extends ConsumerWidget {
  const ResultsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(filteredDesktopEntriesProvider);

    return ListView.builder(
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final result = entries[index];
        final entry = result.choice;

        return Tooltip(
          message: entry.exec,
          child: ListTile(
            key: ValueKey(entry.path),
            title: Text(entry.name ?? 'Unknown'),
            // subtitle: Text(entry.comment ?? entry.exec ?? 'unknown'),
            // subtitle: Text(result.score.toString()),
            leading: XdgIcon(
              name: entry.icon ?? "application-x-executable",
              size: 32,
            ),
            trailing: (entry.path != null) ? _Pin(entry) : null,
            onTap: () async {
              final execLine = entry.parseExec();
              final args = execLine.expand(entry);

              // TODO: Handle terminal launch

              await Process.start(
                args.first,
                args.sublist(1),
                mode: ProcessStartMode.detached,
              );

              // quit
              if (!kDebugMode) SystemNavigator.pop();
            },
          ),
        );
      },
    );
  }
}

class _Pin extends ConsumerWidget {
  final DesktopEntry entry;

  const _Pin(this.entry);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pinned = ref.watch(pinnedEntryPathsProvider.select((paths) {
      return paths.valueOrNull?.contains(entry.path) ?? false;
    }));

    return IconButton(
      icon: Opacity(
        opacity: pinned ? 1.0 : 0.5,
        child: Icon(
          pinned ? Icons.push_pin : Icons.push_pin_outlined,
          color: pinned ? Colors.blue : null,
        ),
      ),
      onPressed: () async {
        final entries = await prefs.getStringList(Preferences.pinnedEntryPaths,
            defaultValue: []).first;
        if (pinned) {
          entries.remove(entry.path);
        } else {
          entries.add(entry.path!);
        }
        await prefs.setStringList(Preferences.pinnedEntryPaths, entries);
      },
    );
  }
}
