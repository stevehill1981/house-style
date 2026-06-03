# house-style

The house [Vale](https://vale.sh) style — `House198x` — packaged so every repo and draft lints prose against the same rules. One canonical copy, versioned via releases, no drift.

It encodes the house Writing Principles as **advisory** rules (suggestions, never gates): catch the avoidable kind of writing difficulty — bloated words, filler, condescension, American spellings, runaway sentence length — and leave the legitimate difficulty of the subject matter alone. Rule-by-rule rationale is in [`House198x/README.md`](House198x/README.md).

## Use it in a repo

Add a `.vale.ini` at the repo root:

```ini
StylesPath = .vale
Packages = https://github.com/stevehill1981/house-style/releases/latest/download/House198x.zip
MinAlertLevel = suggestion

[formats]
mdx = md

[*.{md,mdx}]
BasedOnStyles = House198x
# Passive voice is the noisiest rule and often correct in technical prose; off by default.
House198x.Passive = NO
```

Then sync the package and lint:

```bash
vale sync          # downloads House198x into .vale/ (gitignore it)
vale path/to/docs  # lint
```

Add `.vale/` to `.gitignore`. Re-run `vale sync` after a new style release.

## Use it everywhere (drafts, emails, the KB)

A global `~/.vale.ini` with the same `Packages` line makes `vale <file>` work in any directory — no per-repo config needed for one-off prose. A repo's own `.vale.ini` overrides the global one when present.

## Readability

Sentence length and grade level aren't a Vale job — formulas inflate grade for unavoidable domain nouns and choke on tables. The companion `prose-report.mjs` (in the website repo) owns that signal; the one actionable number is sentences over ~30 words.

## Cutting a new release

Edit the rules in `House198x/`, then:

```bash
zip -r House198x.zip House198x
gh release create vX.Y.Z House198x.zip --title vX.Y.Z --notes "what changed"
```

Consumers point at `releases/latest/download/House198x.zip`, so they pick up the new release on their next `vale sync` — no per-repo URL change needed.
