import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_af.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('af'),
    Locale('en'),
  ];

  /// Button: ask the server again.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// How old cached data is, under a minute.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get ageJustNow;

  /// No description provided for @ageMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 minute ago} other{{count} minutes ago}}'**
  String ageMinutes(int count);

  /// No description provided for @ageHours.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 hour ago} other{{count} hours ago}}'**
  String ageHours(int count);

  /// No description provided for @ageDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 day ago} other{{count} days ago}}'**
  String ageDays(int count);

  /// The cache banner when no answer came. age is ageMinutes etc.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline. Showing what this phone saved {age}.'**
  String bannerOffline(String age);

  /// No description provided for @bannerCouldNotRefresh.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t refresh. Showing what this phone saved {age}.'**
  String bannerCouldNotRefresh(String age);

  /// No description provided for @memberCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No members} one{1 member} other{{count} members}}'**
  String memberCount(int count);

  /// No description provided for @contributionCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No contributions} one{1 contribution} other{{count} contributions}}'**
  String contributionCount(int count);

  /// No description provided for @statusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get statusPaid;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @statusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get statusConfirmed;

  /// A contribution recorded after its cycle's due date.
  ///
  /// In en, this message translates to:
  /// **'Late'**
  String get statusLate;

  /// No description provided for @statusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Status not recognised'**
  String get statusUnknown;

  /// A payment in the phone's outbox.
  ///
  /// In en, this message translates to:
  /// **'Not sent yet'**
  String get statusNotSent;

  /// No description provided for @payTitle.
  ///
  /// In en, this message translates to:
  /// **'Pay {stokvel}'**
  String payTitle(String stokvel);

  /// No description provided for @payCycle.
  ///
  /// In en, this message translates to:
  /// **'Cycle {period}'**
  String payCycle(String period);

  /// No description provided for @payAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount in rand'**
  String get payAmountLabel;

  /// No description provided for @payAmountHint.
  ///
  /// In en, this message translates to:
  /// **'For example 500 or 1 250,50'**
  String get payAmountHint;

  /// No description provided for @payButton.
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get payButton;

  /// No description provided for @payBusy.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get payBusy;

  /// The Pay button while this cycle's payment waits in the outbox.
  ///
  /// In en, this message translates to:
  /// **'Payment pending'**
  String get payPendingButton;

  /// No description provided for @paySavedOffline.
  ///
  /// In en, this message translates to:
  /// **'Saved on this phone. We\'ll send it when we reach the server; it isn\'t paid yet.'**
  String get paySavedOffline;

  /// No description provided for @payPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid. The cycle is up to date.'**
  String get payPaid;

  /// No description provided for @payAlreadyPaid.
  ///
  /// In en, this message translates to:
  /// **'You\'ve already paid for this cycle, so nothing more was sent.'**
  String get payAlreadyPaid;

  /// No description provided for @payCycleClosed.
  ///
  /// In en, this message translates to:
  /// **'This cycle is closed, so it can\'t take payments.'**
  String get payCycleClosed;

  /// No description provided for @payRefused.
  ///
  /// In en, this message translates to:
  /// **'The payment wasn\'t accepted: {reason}'**
  String payRefused(String reason);

  /// No description provided for @payWaiting.
  ///
  /// In en, this message translates to:
  /// **'{seconds, plural, one{Too many payments at once. We\'ll try again in 1 second.} other{Too many payments at once. We\'ll try again in {seconds} seconds.}}'**
  String payWaiting(int seconds);

  /// No description provided for @payExpired.
  ///
  /// In en, this message translates to:
  /// **'A payment saved on {day} couldn\'t be confirmed in time and won\'t be sent. Check this cycle and pay again if you need to.'**
  String payExpired(String day);

  /// No description provided for @pendingPayment.
  ///
  /// In en, this message translates to:
  /// **'Pending payment: {amount}. Not paid until the server confirms it.'**
  String pendingPayment(String amount);

  /// No description provided for @sendNow.
  ///
  /// In en, this message translates to:
  /// **'Send now'**
  String get sendNow;

  /// No description provided for @amountRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount.'**
  String get amountRequired;

  /// No description provided for @amountInvalid.
  ///
  /// In en, this message translates to:
  /// **'Use digits only, like 500 or 1 250,50.'**
  String get amountInvalid;

  /// No description provided for @amountGroups.
  ///
  /// In en, this message translates to:
  /// **'Group the rand in threes, like 1 250.'**
  String get amountGroups;

  /// No description provided for @amountCents.
  ///
  /// In en, this message translates to:
  /// **'Write cents with two digits, like 500,50.'**
  String get amountCents;

  /// No description provided for @amountTooManyCents.
  ///
  /// In en, this message translates to:
  /// **'Cents have two digits at most.'**
  String get amountTooManyCents;

  /// No description provided for @amountTooLarge.
  ///
  /// In en, this message translates to:
  /// **'That amount is too large.'**
  String get amountTooLarge;

  /// No description provided for @amountZero.
  ///
  /// In en, this message translates to:
  /// **'Enter more than R 0,00.'**
  String get amountZero;

  /// No description provided for @signOutWithPendingTitle.
  ///
  /// In en, this message translates to:
  /// **'A payment hasn\'t been sent'**
  String get signOutWithPendingTitle;

  /// No description provided for @signOutWithPendingBody.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{A payment on this phone hasn\'t reached the server. Signing out deletes it, and it won\'t be paid.} other{{count} payments on this phone haven\'t reached the server. Signing out deletes them, and they won\'t be paid.}}'**
  String signOutWithPendingBody(int count);

  /// No description provided for @signOutAnyway.
  ///
  /// In en, this message translates to:
  /// **'Sign out anyway'**
  String get signOutAnyway;

  /// No description provided for @createTitle.
  ///
  /// In en, this message translates to:
  /// **'New stokvel'**
  String get createTitle;

  /// No description provided for @createName.
  ///
  /// In en, this message translates to:
  /// **'Stokvel name'**
  String get createName;

  /// No description provided for @createAmount.
  ///
  /// In en, this message translates to:
  /// **'Monthly contribution, in rand'**
  String get createAmount;

  /// No description provided for @createDueDate.
  ///
  /// In en, this message translates to:
  /// **'First due date'**
  String get createDueDate;

  /// No description provided for @createPickDate.
  ///
  /// In en, this message translates to:
  /// **'Choose a date'**
  String get createPickDate;

  /// No description provided for @createDueDateRequired.
  ///
  /// In en, this message translates to:
  /// **'Choose the first due date.'**
  String get createDueDateRequired;

  /// No description provided for @createNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Give the stokvel a name.'**
  String get createNameRequired;

  /// No description provided for @createButton.
  ///
  /// In en, this message translates to:
  /// **'Create stokvel'**
  String get createButton;

  /// No description provided for @createBusy.
  ///
  /// In en, this message translates to:
  /// **'Creating…'**
  String get createBusy;

  /// No description provided for @newStokvel.
  ///
  /// In en, this message translates to:
  /// **'New stokvel'**
  String get newStokvel;

  /// No description provided for @editCycleTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit cycle {period}'**
  String editCycleTitle(String period);

  /// No description provided for @editCycleTarget.
  ///
  /// In en, this message translates to:
  /// **'Target, in rand'**
  String get editCycleTarget;

  /// No description provided for @editCycleDueDate.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get editCycleDueDate;

  /// No description provided for @editCycleStale.
  ///
  /// In en, this message translates to:
  /// **'Someone else changed this cycle while you were editing. Here is the latest; check it and save again.'**
  String get editCycleStale;

  /// No description provided for @editCycleSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved.'**
  String get editCycleSaved;

  /// No description provided for @editCycle.
  ///
  /// In en, this message translates to:
  /// **'Edit cycle'**
  String get editCycle;

  /// No description provided for @contributionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Contributions'**
  String get contributionsTitle;

  /// No description provided for @filterCycle.
  ///
  /// In en, this message translates to:
  /// **'Cycle'**
  String get filterCycle;

  /// No description provided for @filterStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get filterStatus;

  /// No description provided for @filterMember.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get filterMember;

  /// No description provided for @filterDates.
  ///
  /// In en, this message translates to:
  /// **'Dates'**
  String get filterDates;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterAnyone.
  ///
  /// In en, this message translates to:
  /// **'Anyone'**
  String get filterAnyone;

  /// No description provided for @filterAnyDay.
  ///
  /// In en, this message translates to:
  /// **'Any day'**
  String get filterAnyDay;

  /// No description provided for @filterClear.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get filterClear;

  /// No description provided for @filterOneDay.
  ///
  /// In en, this message translates to:
  /// **'{day}'**
  String filterOneDay(String day);

  /// No description provided for @filterDayRange.
  ///
  /// In en, this message translates to:
  /// **'{first} to {last}'**
  String filterDayRange(String first, String last);

  /// No description provided for @listLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading contributions'**
  String get listLoading;

  /// No description provided for @listEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nobody has paid into this cycle yet.'**
  String get listEmpty;

  /// No description provided for @listEmptyFiltered.
  ///
  /// In en, this message translates to:
  /// **'No contributions match these filters.'**
  String get listEmptyFiltered;

  /// No description provided for @listFailed.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load the contributions.'**
  String get listFailed;

  /// No description provided for @listMoreFailed.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load more.'**
  String get listMoreFailed;

  /// No description provided for @listEnd.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{That\'s everything.} one{That\'s all: 1 contribution.} other{That\'s all: {count} contributions.}}'**
  String listEnd(int count);

  /// No description provided for @recordedOn.
  ///
  /// In en, this message translates to:
  /// **'Paid on {day}'**
  String recordedOn(String day);

  /// No description provided for @viewContributions.
  ///
  /// In en, this message translates to:
  /// **'All contributions'**
  String get viewContributions;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'Follow the phone'**
  String get languageSystem;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageAfrikaans.
  ///
  /// In en, this message translates to:
  /// **'Afrikaans'**
  String get languageAfrikaans;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['af', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'af':
      return AppLocalizationsAf();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
