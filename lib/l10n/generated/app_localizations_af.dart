// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Afrikaans (`af`).
class AppLocalizationsAf extends AppLocalizations {
  AppLocalizationsAf([String locale = 'af']) : super(locale);

  @override
  String get tryAgain => 'Probeer weer';

  @override
  String get cancel => 'Kanselleer';

  @override
  String get save => 'Stoor';

  @override
  String get ageJustNow => 'sopas';

  @override
  String ageMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minute gelede',
      one: '1 minuut gelede',
    );
    return '$_temp0';
  }

  @override
  String ageHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count uur gelede',
      one: '1 uur gelede',
    );
    return '$_temp0';
  }

  @override
  String ageDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dae gelede',
      one: '1 dag gelede',
    );
    return '$_temp0';
  }

  @override
  String bannerOffline(String age) {
    return 'Jy is vanlyn. Ons wys wat hierdie foon $age gestoor het.';
  }

  @override
  String bannerCouldNotRefresh(String age) {
    return 'Kon nie verfris nie. Ons wys wat hierdie foon $age gestoor het.';
  }

  @override
  String memberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lede',
      one: '1 lid',
      zero: 'Geen lede nie',
    );
    return '$_temp0';
  }

  @override
  String contributionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bydraes',
      one: '1 bydrae',
      zero: 'Geen bydraes nie',
    );
    return '$_temp0';
  }

  @override
  String get statusPaid => 'Betaal';

  @override
  String get statusPending => 'Hangend';

  @override
  String get statusConfirmed => 'Bevestig';

  @override
  String get statusLate => 'Laat';

  @override
  String get statusUnknown => 'Status nie herken nie';

  @override
  String get statusNotSent => 'Nog nie gestuur nie';

  @override
  String payTitle(String stokvel) {
    return 'Betaal aan $stokvel';
  }

  @override
  String payCycle(String period) {
    return 'Siklus $period';
  }

  @override
  String get payAmountLabel => 'Bedrag in rand';

  @override
  String get payAmountHint => 'Byvoorbeeld 500 of 1 250,50';

  @override
  String get payButton => 'Betaal';

  @override
  String get payBusy => 'Stoor tans…';

  @override
  String get payPendingButton => 'Betaling hangend';

  @override
  String get paySavedOffline =>
      'Op hierdie foon gestoor. Ons stuur dit sodra ons die bediener bereik; dit is nog nie betaal nie.';

  @override
  String get payPaid => 'Betaal. Die siklus is op datum.';

  @override
  String get payAlreadyPaid =>
      'Jy het reeds vir hierdie siklus betaal, dus is niks meer gestuur nie.';

  @override
  String get payCycleClosed =>
      'Hierdie siklus is gesluit en kan nie meer betalings ontvang nie.';

  @override
  String payRefused(String reason) {
    return 'Die betaling is nie aanvaar nie: $reason';
  }

  @override
  String payWaiting(int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      seconds,
      locale: localeName,
      other:
          'Te veel betalings tegelyk. Ons probeer oor $seconds sekondes weer.',
      one: 'Te veel betalings tegelyk. Ons probeer oor 1 sekonde weer.',
    );
    return '$_temp0';
  }

  @override
  String payExpired(String day) {
    return '\'n Betaling wat op $day gestoor is, kon nie betyds bevestig word nie en sal nie gestuur word nie. Kyk na hierdie siklus en betaal weer as dit nodig is.';
  }

  @override
  String pendingPayment(String amount) {
    return 'Hangende betaling: $amount. Nie betaal voordat die bediener dit bevestig nie.';
  }

  @override
  String get sendNow => 'Stuur nou';

  @override
  String get amountRequired => 'Voer \'n bedrag in.';

  @override
  String get amountInvalid => 'Gebruik net syfers, soos 500 of 1 250,50.';

  @override
  String get amountGroups => 'Groepeer die rand in drieë, soos 1 250.';

  @override
  String get amountCents => 'Skryf sente met twee syfers, soos 500,50.';

  @override
  String get amountTooManyCents => 'Sente het hoogstens twee syfers.';

  @override
  String get amountTooLarge => 'Daardie bedrag is te groot.';

  @override
  String get amountZero => 'Voer meer as R 0,00 in.';

  @override
  String get signOutWithPendingTitle => '\'n Betaling is nog nie gestuur nie';

  @override
  String signOutWithPendingBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count betalings op hierdie foon het nog nie die bediener bereik nie. As jy afmeld, word hulle uitgevee en sal hulle nie betaal word nie.',
      one: '\'n Betaling op hierdie foon het nog nie die bediener bereik nie. As jy afmeld, word dit uitgevee en dit sal nie betaal word nie.',
    );
    return '$_temp0';
  }

  @override
  String get signOutAnyway => 'Meld tog af';

  @override
  String get createTitle => 'Nuwe stokvel';

  @override
  String get createName => 'Naam van die stokvel';

  @override
  String get createAmount => 'Maandelikse bydrae, in rand';

  @override
  String get createDueDate => 'Eerste betaaldatum';

  @override
  String get createPickDate => 'Kies \'n datum';

  @override
  String get createDueDateRequired => 'Kies die eerste betaaldatum.';

  @override
  String get createNameRequired => 'Gee die stokvel \'n naam.';

  @override
  String get createButton => 'Skep stokvel';

  @override
  String get createBusy => 'Skep tans…';

  @override
  String get newStokvel => 'Nuwe stokvel';

  @override
  String editCycleTitle(String period) {
    return 'Wysig siklus $period';
  }

  @override
  String get editCycleTarget => 'Teiken, in rand';

  @override
  String get editCycleDueDate => 'Betaaldatum';

  @override
  String get editCycleStale =>
      'Iemand anders het hierdie siklus verander terwyl jy dit gewysig het. Hier is die nuutste weergawe; kyk daarna en stoor weer.';

  @override
  String get editCycleSaved => 'Gestoor.';

  @override
  String get editCycle => 'Wysig siklus';

  @override
  String get contributionsTitle => 'Bydraes';

  @override
  String get filterCycle => 'Siklus';

  @override
  String get filterStatus => 'Status';

  @override
  String get filterMember => 'Lid';

  @override
  String get filterDates => 'Datums';

  @override
  String get filterAll => 'Alles';

  @override
  String get filterAnyone => 'Enigiemand';

  @override
  String get filterAnyDay => 'Enige dag';

  @override
  String get filterClear => 'Maak filters skoon';

  @override
  String filterOneDay(String day) {
    return '$day';
  }

  @override
  String filterDayRange(String first, String last) {
    return '$first tot $last';
  }

  @override
  String get listLoading => 'Laai bydraes';

  @override
  String get listEmpty => 'Niemand het nog in hierdie siklus betaal nie.';

  @override
  String get listEmptyFiltered => 'Geen bydraes pas by hierdie filters nie.';

  @override
  String get listFailed => 'Ons kon nie die bydraes laai nie.';

  @override
  String get listMoreFailed => 'Ons kon nie meer laai nie.';

  @override
  String listEnd(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dis alles: $count bydraes.',
      one: 'Dis alles: 1 bydrae.',
      zero: 'Dis alles.',
    );
    return '$_temp0';
  }

  @override
  String recordedOn(String day) {
    return 'Betaal op $day';
  }

  @override
  String get viewContributions => 'Alle bydraes';

  @override
  String get settingsLanguage => 'Taal';

  @override
  String get languageSystem => 'Volg die foon';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageAfrikaans => 'Afrikaans';
}
