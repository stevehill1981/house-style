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

## Advisory pre-commit hook

`hooks/pre-commit-prose` runs Vale on staged markdown and prints suggestions when you commit. It **never blocks** — it's a nudge, not a gate (always exits 0), and it's a silent no-op if Vale isn't installed or the package isn't synced yet. It uses the repo-local `.vale.ini` if present, else the global `~/.vale.ini`.

Install it into one or more repos (symlinks, so a single edit here updates them all):

```bash
./install-hooks.sh /path/to/repo /path/to/another-repo
```

The installer skips any repo that already has a non-symlink `pre-commit` hook, so it won't clobber husky/lefthook setups.

### Rust repos — add a blocking format gate

`hooks/pre-commit-rust` runs the same advisory prose check **and then** a **blocking** `cargo fmt --all --check`, so formatting drift is caught at commit time instead of only at CI. It self-disables anywhere without a `Cargo.toml` (and only runs when the commit stages `.rs` files), so it's safe even if installed broadly. Unlike the prose check, this one **does** block — on failure it tells you to run `cargo fmt` and exits non-zero.

Install it with the `--rust` flag (it replaces the prose-only symlink):

```bash
./install-hooks.sh --rust /path/to/rust-repo
```

This is the one deliberate exception to the "never gates" rule: prose stays advisory; code formatting is deterministic, so it's a hard gate.

## Readability

Sentence length and grade level aren't a Vale job — formulas inflate grade for unavoidable domain nouns and choke on tables. The companion `prose-report.mjs` (in the website repo) owns that signal; the one actionable number is sentences over ~30 words.

## Cutting a new release

Edit the rules in `House198x/`, then:

```bash
zip -r House198x.zip House198x
gh release create vX.Y.Z House198x.zip --title vX.Y.Z --notes "what changed"
```

Consumers point at `releases/latest/download/House198x.zip`, so they pick up the new release on their next `vale sync` — no per-repo URL change needed.
