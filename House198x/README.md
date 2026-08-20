# House198x prose style (Vale)

Advisory prose rules encoding the house Writing Principles. **Everything is a suggestion, not a gate.** The point is to catch the *avoidable* kind of writing difficulty — bloated words, filler, condescension, American spellings — without touching the legitimate difficulty of the subject matter.

Applies to all the text we produce: docs, READMEs, curriculum, blog posts, commits, release notes.

## Rules

| Rule | Maps to | Notes |
|------|---------|-------|
| `Substitutions` | "short words beat long ones", "tighten in sweeps" | Long word / redundant phrase → plainer form. High precision. Omits domain-legit words like "initialise". |
| `Weasel` | "non-essential information is an obstacle" | Intensifiers and hedges that add words, not meaning (very, really, a lot…). |
| `Condescending` | "warm, technical, never condescending" | simply, obviously, trivial, easy… Words that sting a stuck reader. **"just" is deliberately excluded** — too common and usually legitimate. |
| `InsideVoice` | "know what you're trying to say" — and who to | Pointers at artefacts a reader cannot open: a decision record, a plan, the private reference library. **Off by default** (`House198x.InsideVoice = NO`); enable per-glob on reader-facing paths only. Narrow on purpose — general process talk ("we decided", "deliberately left open") is often correct on a teaching page. |
| `BritishEnglish` | British English (colour, learnt, centre) | Clear American spellings (color→colour). Omits "program" (the documented exception), "-ise/-ize" (both valid British), and "meter" (a gauge is a meter; only the length unit is "metre"). |
| `Passive` | "strong verbs, active voice" | **Recommend OFF by default** (`House198x.Passive = NO`). Regex passive-detection is the noisiest rule there is, and passive is often correct in technical prose ("the interrupt is raised"). Toggle on for an occasional skim. |

## Tuning

Add or remove tokens in the `.yml` files, then re-cut the release (see the repo README). Keep each rule's hit count proportionate — a rule firing hundreds of times across a corpus is noise, not signal.
