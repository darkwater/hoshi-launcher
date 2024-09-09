// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'results_list.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$desktopEntriesHash() => r'53a68b66332e1222acf28c44ea9482a3cb428e14';

/// See also [desktopEntries].
@ProviderFor(desktopEntries)
final desktopEntriesProvider =
    AutoDisposeFutureProvider<List<DesktopEntry>>.internal(
  desktopEntries,
  name: r'desktopEntriesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$desktopEntriesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef DesktopEntriesRef = AutoDisposeFutureProviderRef<List<DesktopEntry>>;
String _$filteredDesktopEntriesHash() =>
    r'6080d8fcf49789c9b2e66077cb4bf02a883d113f';

/// See also [filteredDesktopEntries].
@ProviderFor(filteredDesktopEntries)
final filteredDesktopEntriesProvider =
    AutoDisposeProvider<List<ExtractedResult<DesktopEntry>>>.internal(
  filteredDesktopEntries,
  name: r'filteredDesktopEntriesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filteredDesktopEntriesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FilteredDesktopEntriesRef
    = AutoDisposeProviderRef<List<ExtractedResult<DesktopEntry>>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
