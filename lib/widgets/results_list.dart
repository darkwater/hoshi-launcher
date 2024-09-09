import 'package:flutter/material.dart';
import 'package:fuzzywuzzy/algorithms/weighted_ratio.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:fuzzywuzzy/model/extracted_result.dart';
import 'package:fuzzywuzzy/ratios/partial_ratio.dart';
import 'package:fuzzywuzzy/ratios/simple_ratio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
    // cutoff: 50,
    getter: (entry) => entry.name ?? "",
    ratio: WeightedRatio(),
  );

  results.sort((a, b) =>
      b.score.compareTo(a.score) * 2 +
      b.choice.name!.compareTo(a.choice.name!));

  return results;
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
          message: entry.comment ?? '',
          child: ListTile(
            title: Text(entry.name ?? 'Unknown'),
            subtitle: Text(entry.exec ?? 'unknown'),
            // subtitle: Text(entry.comment ?? entry.exec ?? 'unknown'),
            // subtitle: Text(result.score.toString()),
            leading: XdgIcon(
              name: entry.icon ?? "application-x-executable",
              size: 24,
            ),
          ),
        );
      },
    );
  }
}
