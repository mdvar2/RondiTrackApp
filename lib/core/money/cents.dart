/// A whole number of South African cents.
///
/// Every amount in the domain is [Cents]. The API sends money as `int64`
/// cents (`amountPaid`, `amountOwed`, `arrearsCents`, `collectedCents`, ...),
/// and the app keeps it that way all the way to the screen. There is no
/// `double` anywhere near money.
extension type const Cents(int value) {
  /// No money.
  static const zero = Cents(0);

  /// Whether this amount is below zero.
  bool get isNegative => value < 0;

  /// Whether this amount is exactly zero.
  bool get isZero => value == 0;

  /// The sum of two amounts.
  Cents operator +(Cents other) => Cents(value + other.value);

  /// The difference of two amounts.
  Cents operator -(Cents other) => Cents(value - other.value);

  /// Whether this amount is less than [other].
  bool operator <(Cents other) => value < other.value;

  /// Whether this amount is greater than [other].
  bool operator >(Cents other) => value > other.value;
}
