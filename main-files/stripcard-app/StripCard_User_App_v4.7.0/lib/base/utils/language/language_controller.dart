import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:get_storage/get_storage.dart';
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";
import "package:TAKARA PAY/base/utils/language/language_model.dart";
import "package:TAKARA PAY/base/utils/language/language_service.dart";
import "package:TAKARA PAY/base/utils/local_storage.dart";

final languageSettingsController =
    Get.put(LanguageController(), permanent: true);

class LanguageController extends GetxController {
  RxString selectedLanguage = "".obs; // Selected language
  RxString defLangKey = "".obs; // Default language key

  @override
  void onInit() {
    super.onInit();
    // Seed synchronously so the very first frame already has a usable
    // language (cache → bundled English fallback). This guarantees
    // getTranslation/languageDirection never operate on an empty list.
    _loadFromCacheIfEmpty();
    _ensureEnglishFallback();
    getDefaultKey();
    // Load the full bundled English dictionary from assets (fast, local) so
    // that even with NO network and NO cache every key resolves to real
    // English text instead of the raw key. Once loaded we upgrade the English
    // fallback entry in place.
    _loadBundledEnglish().then((_) {
      getDefaultKey();
      update();
    });
    // Refresh from the API in the background; on failure we keep whatever
    // we already have (cached or the English fallback).
    fetchLanguages().then((_) => getDefaultKey());
  }

  List<Language> languages = [];
  var isLoadingValue = false.obs;

  bool get isLoading => isLoadingValue.value;

  static const String selectedLanguageKey = 'selectedLanguage';
  static const String _englishAsset = 'assets/lang/en.json';

  // ── Fallback / cache helpers ─────────────────────────────────────────────

  /// Full English dictionary shipped inside the app bundle. Empty until the
  /// asset has been read once; populated by [_loadBundledEnglish]. This is the
  /// source of truth for the "always fall back to English" guarantee.
  static Map<String, String> _bundledEnglishMap = const {};

  /// A built-in English language. Carries the bundled dictionary so the very
  /// first offline frame still renders real English (not raw keys / crashes).
  Language _defaultEnglish() => Language(
        name: 'English',
        code: 'en',
        dir: 'ltr',
        status: true,
        translateKeyValues: _bundledEnglishMap,
      );

  /// Guarantee there is always at least an English entry to fall back to.
  void _ensureEnglishFallback() {
    if (languages.isEmpty) {
      languages = [_defaultEnglish()];
    }
  }

  /// Read the bundled English dictionary from assets and, if the live English
  /// entry is still the empty placeholder (no API/cache data yet), upgrade it
  /// to the full dictionary. Never throws.
  Future<void> _loadBundledEnglish() async {
    if (_bundledEnglishMap.isNotEmpty) {
      _upgradeEnglishEntry();
      return;
    }
    try {
      final raw = await rootBundle.loadString(_englishAsset);
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final map = <String, String>{};
      decoded.forEach((k, v) {
        if (v != null) map[k] = v.toString();
      });
      if (map.isNotEmpty) {
        _bundledEnglishMap = map;
        _upgradeEnglishEntry();
      }
    } catch (e) {
      debugPrint('Bundled English load failed: $e');
    }
  }

  /// Replace an empty/placeholder English entry with the full bundled
  /// dictionary. Real API/cache English data (non-empty) is left untouched.
  void _upgradeEnglishEntry() {
    if (_bundledEnglishMap.isEmpty) return;
    final idx = languages.indexWhere((l) => l.code == 'en');
    if (idx == -1) {
      languages.add(_defaultEnglish());
    } else if (languages[idx].translateKeyValues.isEmpty) {
      final existing = languages[idx];
      languages[idx] = Language(
        name: existing.name.isNotEmpty ? existing.name : 'English',
        code: 'en',
        dir: existing.dir.isNotEmpty ? existing.dir : 'ltr',
        status: existing.status,
        translateKeyValues: _bundledEnglishMap,
      );
    }
  }

  Language? _findByCode(String code) {
    for (final lang in languages) {
      if (lang.code == code) return lang;
    }
    return null;
  }

  void _loadFromCacheIfEmpty() {
    if (languages.isNotEmpty) return;
    try {
      final raw = LocalStorage.getCachedLanguages();
      if (raw is String && raw.isNotEmpty) {
        final decoded = jsonDecode(raw) as List<dynamic>;
        final cached = decoded
            .map((e) => Language.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        if (cached.isNotEmpty) languages = cached;
      }
    } catch (e) {
      debugPrint('Language cache read failed: $e');
    }
  }

  void _saveToCache(List<Language> langs) {
    try {
      LocalStorage.saveCachedLanguages(
        json: jsonEncode(langs.map((l) => l.toJson()).toList()),
      );
    } catch (e) {
      debugPrint('Language cache write failed: $e');
    }
  }

  // ── Fetch ────────────────────────────────────────────────────────────────

  Future<void> fetchLanguages() async {
    isLoadingValue.value = true;
    try {
      final fetched = await LanguageService().fetchLanguages();
      if (fetched.isNotEmpty) {
        languages = fetched;
        _saveToCache(fetched);
      }
    } catch (e) {
      // API/language issue: do NOT clear what we have — keep cached data or
      // the bundled English fallback so the app stays usable in English.
      debugPrint('Error fetching language data: $e');
    } finally {
      _ensureEnglishFallback();
      // Guarantee a usable English fallback exists even if the API payload
      // omitted English or returned it empty.
      _upgradeEnglishEntry();
      isLoadingValue.value = false;
      update();
    }
  }

  // >> get default language key (never throws)
  String getDefaultKey() {
    _ensureEnglishFallback();
    final selectedLang = languages.firstWhereOrNullStatus(true) ??
        languages.firstWhereOrNullStatus(false) ??
        _findByCode('en') ??
        languages.first;

    defLangKey.value = selectedLang.code;

    // Load selected language from cache (falls back to the default key).
    final box = GetStorage();
    final stored = box.read(selectedLanguageKey);
    selectedLanguage.value =
        (stored is String && stored.isNotEmpty) ? stored : defLangKey.value;
    return selectedLang.code;
  }

  void changeLanguage(String newLanguage) {
    selectedLanguage.value = newLanguage;
    final box = GetStorage();
    box.write(selectedLanguageKey, newLanguage);
    update();
  }

  /// Resolve a translation key. Order: selected language → default language →
  /// English → the key itself. Never throws and never returns empty.
  String getTranslation(String key) {
    if (languages.isEmpty) return key;

    final selected = _findByCode(selectedLanguage.value) ??
        _findByCode(defLangKey.value) ??
        _findByCode('en') ??
        languages.first;

    final fallback =
        _findByCode('en') ?? _findByCode(defLangKey.value) ?? languages.first;

    final selectedValue = selected.translateKeyValues[key];
    if (selectedValue != null && selectedValue.isNotEmpty) {
      return selectedValue;
    }

    final fallbackValue = fallback.translateKeyValues[key];
    if (fallbackValue != null && fallbackValue.isNotEmpty) {
      return fallbackValue;
    }

    // Ultimate fallback — the key (many Strings keys are already English).
    return key;
  }

  /// Text direction. Falls back to LTR (English) on any issue.
  TextDirection get languageDirection {
    final selected = _findByCode(selectedLanguage.value) ??
        _findByCode(defLangKey.value) ??
        _findByCode('en');
    return selected?.dir == 'rtl' ? TextDirection.rtl : TextDirection.ltr;
  }
}

extension _LanguageStatusLookup on List<Language> {
  Language? firstWhereOrNullStatus(bool status) {
    for (final lang in this) {
      if (lang.status == status) return lang;
    }
    return null;
  }
}
