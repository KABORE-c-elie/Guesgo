import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_provider.g.dart';

/// `true` once the device reports at least one connected interface. Powers
/// [OfflineBanner] — the visible half of "mode hors-ligne": data falling
/// back to cache is invisible on its own, this is what tells the user why
/// what they're seeing might be stale.
@Riverpod(keepAlive: true)
Stream<bool> isOnline(Ref ref) => Connectivity().onConnectivityChanged.map(
  (results) => !results.contains(ConnectivityResult.none),
);
