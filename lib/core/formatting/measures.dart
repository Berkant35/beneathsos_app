import 'package:beneathsos_app/l10n/generated/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:rubble_core/rubble_core.dart';

/// "18.2 m" / "18,2 m".
String metresLabel(AppLocalizations l10n, Meters length) => l10n.lengthMetres(
  NumberFormat('0.0', l10n.localeName).format(length.value),
);

/// "216 m²" / "8.5 m²" — whole square metres from 10 m² on.
String squareMetresLabel(AppLocalizations l10n, SquareMeters area) =>
    l10n.areaSquareMetres(
      NumberFormat(
        area.value < 10 ? '0.0' : '0',
        l10n.localeName,
      ).format(area.value),
    );
