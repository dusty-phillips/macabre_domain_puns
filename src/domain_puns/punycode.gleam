//// Module for working with punycode.

import gleam/string

/// Prefix for punycode internationalized domains.
pub const prefix: String = "xn--"

/// Checks if a domain string is a punycode domain. If it is, it returns the punycode
/// string with the leading prefix for internationalized domains removed.
pub fn matches_domain(domain: String) -> Result(String, Nil) {
  let lower = string.lowercase(domain)
  case string.starts_with(lower, prefix) {
    True -> string.remove_prefix(lower, prefix) |> Ok
    False -> Error(Nil)
  }
}
