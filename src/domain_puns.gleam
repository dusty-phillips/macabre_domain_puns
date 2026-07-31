import argv
import domain_puns/domains
import domain_puns/punycode as punycode_helper
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import glidna/punycode

/// Representation of a selected domain.
pub type Domain {
  /// A typical domain. Only one representation, the text value.
  Standard(domain: String)
  /// A domain with punycode. Has both the actual text value, and its parsed version.
  Punycode(domain: String, parsed: String)
}

pub fn main() -> Nil {
  let args = argv.load()
  case args.arguments {
    [name] ->
      suggestions(domains.domains, name)
      |> list.each(fn(domain) {
        case domain {
          Standard(domain) -> io.println(domain)
          Punycode(domain, parsed) ->
            io.println(parsed <> " (" <> domain <> ")")
        }
      })
    _ -> args.program |> usage |> io.println_error
  }
}

fn usage(exe: String) -> String {
  exe <> " <PROJECT_NAME>"
}

/// Uses the list of top-level domains to suggest domains for your site's name.
pub fn suggestions(top_level: List(String), name: String) -> List(Domain) {
  top_level
  |> list.map(fn(tl) { string.lowercase(tl) })
  |> list.filter_map(fn(tl) { do_suggest(tl, name) })
}

/// Creates a suggestion for a single domain and project name.
fn do_suggest(top_level: String, name: String) -> Result(Domain, Nil) {
  case punycode_helper.matches_domain(top_level) {
    Ok(encoded) -> do_punycode_suggest(encoded, name)
    Error(Nil) -> do_plain_text_suggest(top_level, name)
  }
}

/// Creates a suggestion for a punycode domain. Takes the encoded punycode *without* the
/// `xn--` prefix
fn do_punycode_suggest(encoded: String, name: String) -> Result(Domain, Nil) {
  punycode.from_ascii(encoded)
  |> result.try(fn(domain) {
    do_plain_text_suggest_string(domain, name)
    |> result.map(fn(parsed) {
      let plain =
        parsed |> string.remove_suffix(domain)
        <> punycode_helper.prefix
        <> encoded
      Punycode(plain, parsed)
    })
  })
}

/// Creates a suggestion for a plain-text (not encoded) domain.
fn do_plain_text_suggest(
  top_level: String,
  name: String,
) -> Result(Domain, Nil) {
  case string.ends_with(name, top_level) {
    True ->
      do_plain_text_suggest_string(top_level, name) |> result.map(Standard)
    False -> Error(Nil)
  }
}

/// Creates a suggestion for a plain-text (not encoded) domain as a string.
fn do_plain_text_suggest_string(
  top_level: String,
  name: String,
) -> Result(String, Nil) {
  case string.ends_with(name, top_level) {
    True -> Ok(string.remove_suffix(name, top_level) <> "." <> top_level)
    False -> Error(Nil)
  }
}
