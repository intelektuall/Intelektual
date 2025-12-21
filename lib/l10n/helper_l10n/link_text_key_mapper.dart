import '../app_localizations.dart';
import '../../Ryan/models/link_text_key.dart';

extension LinkTextKeyLocalization on LinkTextKey {
  String localized(AppLocalizations t) {
    switch (this) {
      case LinkTextKey.learnOceanTitle:
        return t.learnUnderwaterLife;
      case LinkTextKey.learnMore:
        return t.learnMore;
    }
  }
}
