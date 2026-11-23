// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get tryAgain => 'Try again';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get ageJustNow => 'just now';

  @override
  String ageMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes ago',
      one: '1 minute ago',
    );
    return '$_temp0';
  }

  @override
  String ageHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours ago',
      one: '1 hour ago',
    );
    return '$_temp0';
  }

  @override
  String ageDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

  @override
  String bannerOffline(String age) {
    return 'You\'re offline. Showing what this phone saved $age.';
  }

  @override
  String bannerCouldNotRefresh(String age) {
    return 'Couldn\'t refresh. Showing what this phone saved $age.';
  }

  @override
  String memberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count members',
      one: '1 member',
      zero: 'No members',
    );
    return '$_temp0';
  }

  @override
  String contributionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count contributions',
      one: '1 contribution',
      zero: 'No contributions',
    );
    return '$_temp0';
  }

  @override
  String get statusPaid => 'Paid';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusConfirmed => 'Confirmed';

  @override
  String get statusLate => 'Late';

  @override
  String get statusUnknown => 'Status not recognised';

  @override
  String get statusNotSent => 'Not sent yet';

  @override
  String payTitle(String stokvel) {
    return 'Pay $stokvel';
  }

  @override
  String payCycle(String period) {
    return 'Cycle $period';
  }

  @override
  String get payAmountLabel => 'Amount in rand';

  @override
  String get payAmountHint => 'For example 500 or 1 250,50';

  @override
  String get payButton => 'Pay';

  @override
  String get payBusy => 'Saving…';

  @override
  String get payPendingButton => 'Payment pending';

  @override
  String get paySavedOffline =>
      'Saved on this phone. We\'ll send it when we reach the server; it isn\'t paid yet.';

  @override
  String get payPaid => 'Paid. The cycle is up to date.';

  @override
  String get payAlreadyPaid =>
      'You\'ve already paid for this cycle, so nothing more was sent.';

  @override
  String get payCycleClosed =>
      'This cycle is closed, so it can\'t take payments.';

  @override
  String payRefused(String reason) {
    return 'The payment wasn\'t accepted: $reason';
  }

  @override
  String payWaiting(int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      seconds,
      locale: localeName,
      other: 'Too many payments at once. We\'ll try again in $seconds seconds.',
      one: 'Too many payments at once. We\'ll try again in 1 second.',
    );
    return '$_temp0';
  }

  @override
  String payExpired(String day) {
    return 'A payment saved on $day couldn\'t be confirmed in time and won\'t be sent. Check this cycle and pay again if you need to.';
  }

  @override
  String pendingPayment(String amount) {
    return 'Pending payment: $amount. Not paid until the server confirms it.';
  }

  @override
  String get sendNow => 'Send now';

  @override
  String get amountRequired => 'Enter an amount.';

  @override
  String get amountInvalid => 'Use digits only, like 500 or 1 250,50.';

  @override
  String get amountGroups => 'Group the rand in threes, like 1 250.';

  @override
  String get amountCents => 'Write cents with two digits, like 500,50.';

  @override
  String get amountTooManyCents => 'Cents have two digits at most.';

  @override
  String get amountTooLarge => 'That amount is too large.';

  @override
  String get amountZero => 'Enter more than R 0,00.';

  @override
  String get signOutWithPendingTitle => 'A payment hasn\'t been sent';

  @override
  String signOutWithPendingBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count payments on this phone haven\'t reached the server. Signing out deletes them, and they won\'t be paid.',
      one: 'A payment on this phone hasn\'t reached the server. Signing out deletes it, and it won\'t be paid.',
    );
    return '$_temp0';
  }

  @override
  String get signOutAnyway => 'Sign out anyway';

  @override
  String get createTitle => 'New stokvel';

  @override
  String get createName => 'Stokvel name';

  @override
  String get createAmount => 'Monthly contribution, in rand';

  @override
  String get createDueDate => 'First due date';

  @override
  String get createPickDate => 'Choose a date';

  @override
  String get createDueDateRequired => 'Choose the first due date.';

  @override
  String get createNameRequired => 'Give the stokvel a name.';

  @override
  String get createButton => 'Create stokvel';

  @override
  String get createBusy => 'Creating…';

  @override
  String get newStokvel => 'New stokvel';

  @override
  String editCycleTitle(String period) {
    return 'Edit cycle $period';
  }

  @override
  String get editCycleTarget => 'Target, in rand';

  @override
  String get editCycleDueDate => 'Due date';

  @override
  String get editCycleStale =>
      'Someone else changed this cycle while you were editing. Here is the latest; check it and save again.';

  @override
  String get editCycleSaved => 'Saved.';

  @override
  String get editCycle => 'Edit cycle';

  @override
  String get contributionsTitle => 'Contributions';

  @override
  String get filterCycle => 'Cycle';

  @override
  String get filterStatus => 'Status';

  @override
  String get filterMember => 'Member';

  @override
  String get filterDates => 'Dates';

  @override
  String get filterAll => 'All';

  @override
  String get filterAnyone => 'Anyone';

  @override
  String get filterAnyDay => 'Any day';

  @override
  String get filterClear => 'Clear filters';

  @override
  String filterOneDay(String day) {
    return '$day';
  }

  @override
  String filterDayRange(String first, String last) {
    return '$first to $last';
  }

  @override
  String get listLoading => 'Loading contributions';

  @override
  String get listEmpty => 'Nobody has paid into this cycle yet.';

  @override
  String get listEmptyFiltered => 'No contributions match these filters.';

  @override
  String get listFailed => 'We couldn\'t load the contributions.';

  @override
  String get listMoreFailed => 'We couldn\'t load more.';

  @override
  String listEnd(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'That\'s all: $count contributions.',
      one: 'That\'s all: 1 contribution.',
      zero: 'That\'s everything.',
    );
    return '$_temp0';
  }

  @override
  String recordedOn(String day) {
    return 'Paid on $day';
  }

  @override
  String get viewContributions => 'All contributions';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get languageSystem => 'Follow the phone';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageAfrikaans => 'Afrikaans';
}
