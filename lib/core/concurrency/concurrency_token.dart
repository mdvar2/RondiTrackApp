/// The API's guard against a stale write, kept exactly as the API sent it.
///
/// For a stokvel or a cycle it is the `ETag` header, quotes included
/// (`"2324"`), which a `PUT` sends back as `If-Match`; a stale one is a
/// `412`. For a cycle's close preview it is the body's `version` (a 64-hex
/// string), which the close request sends back; a stale one is a `409`
/// (README "Contract notes", question 2).
///
/// Opaque: the app never parses, compares or builds one. It only keeps it
/// and gives it back.
extension type const ConcurrencyToken(String value);
