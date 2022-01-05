import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPrefs = FutureProvider<SharedPreferences>(
    (_) async => await SharedPreferences.getInstance());

class SharedPreferenceNotifier extends StateNotifier<List<String>> {
  SharedPreferenceNotifier(this.pref)
      : super(pref?.getStringList("fav_folder") ?? []);

  final SharedPreferences? pref;

  static final sharedPrefenceProvider =
      StateNotifierProvider<SharedPreferenceNotifier, List<String>>((ref) {
    final pref = ref.watch(sharedPrefs).maybeWhen(
          data: (value) => value,
          orElse: () => null,
        );
    return SharedPreferenceNotifier(pref);
  });

  void toggle(String favoriteId) {
    if (state.contains(favoriteId)) {
      state = state.where((id) => id != favoriteId).toList();
    } else {
      state = [...state, favoriteId];
    }
    // Throw here since for some reason SharedPreferences could not be retrieved
    pref!.setStringList("id", state);
  }
}
