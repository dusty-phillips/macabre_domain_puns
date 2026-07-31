# domain_puns

[![Package Version](https://img.shields.io/hexpm/v/domain_puns)](https://hex.pm/packages/domain_puns)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/domain_puns/)

## Description

This is a small CLI tool I made to help pick out a fun domain from a word or phrase. The goal is to
try to use the top-level domain as part of the word or phrase. For example, instead of
`myfavoritecolorisblue.com`, `myfavoritecoloris.blue` would be more fun.

Also, I wrote this to have a chance to learn and use [Gleam](https://gleam.run).

## Example

```console
$ gleam run -m domain_puns myfavoritecolorisblue
myfavoritecoloris.blue

# International domains are supported
$ gleam run -m domain_puns heyみんな
hey.みんな (hey.xn--q9jyb4c)
```

## Domains

The domains are sourced from <https://data.iana.org/TLD/tlds-alpha-by-domain.txt>, which is linked
from <https://www.icann.org/en/contracted-parties/registry-operators/resources/list-of-top-level-domains>.
