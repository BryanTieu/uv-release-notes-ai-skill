---
applyTo: "docs/**/*.md"
description: "Use when answering questions about UniVerse/MV release notes, issue fixes, build updates, version comparisons, and upgrade-impact questions."
---

# MV Release Notes Answering Rules

## Objective
Provide accurate, source-grounded answers from release note markdown files under `docs/`.

## Required Answer Workflow
1. Determine intent:
- Issue lookup (for example: UNV-5287)
- Version summary (for example: 11.2.4)
- Comparison (for example: 11.2.4 vs 11.3.4)
- Component/platform impact (for example: Backup Tools, AIX/Linux)

2. Read the most relevant release note files first, then expand to more files only if needed.

3. Ground every claim in source text from the docs:
- Prefer exact issue IDs, build numbers, version labels, and release dates
- Avoid speculative statements

4. Return a concise, structured answer:
- Direct answer first
- Supporting details second (issue IDs, component, platform scope)
- If asked to compare versions, present differences clearly by version

5. If information is not present in the docs, say so explicitly and state what was checked.

## Quality Bar
- Include issue ID(s) when available
- Include version/build context when available
- Include component/platform qualifiers when available
- Distinguish "fixed", "changed", and "requirement/warning" language clearly
- Include citations for every factual claim

## Safe Behavior
- Do not invent release details
- Do not infer fixes across versions unless explicitly documented
- If docs conflict, call out the conflict and cite both entries

## Preferred Style for Responses
- Keep answers brief but specific
- Use bullet points for multiple fixes or changes
- Preserve original terminology from release notes (for example: "Important news", "Issues by release")

## Citation Style
Use a citation at the end of each factual bullet or sentence.

Required format:
- `[source: docs/<file>.md | section: <section name>]`

If section is unclear, use the nearest heading label:
- `[source: docs/<file>.md | section: <nearest heading>]`

If multiple sources support one statement:
- `[sources: docs/<file1>.md | section: <section>; docs/<file2>.md | section: <section>]`

Examples:
- `UNV-5287 fixed uvrestore restore failures when backup block size was not 512. [source: docs/UV-11.2.4.md | section: Issues by release]`
- `11.2.4 important news includes OpenSSL 1.0.1h shipping to address Heartbleed. [source: docs/UV-11.2.4.md | section: Important news]`

Missing-data citation format:
- `No explicit reference to issue UNV-99999 was found in the checked files. [checked: docs/UV-11.2.4.md, docs/UV-11.3.4.md, docs/UV-14.2.1.md]`

## Response Template (Strict)
When answering release-note questions, use this structure in order:

1. `Answer`
- 1 to 2 sentences with the direct conclusion only.

2. `Evidence`
- Bullet list of supporting facts.
- Each bullet must end with a citation in the required format.

3. `Not Found / Limits`
- If any requested detail is missing, explicitly say what was not found.
- Include checked-files notation.
- If everything was found, write: `None.`

4. `Compared Versions` (only for comparison questions)
- One bullet per version summarizing its relevant differences.
- Each bullet must include citations.

Default output example:
- `Answer`: UniVerse 11.2.4 includes a fix for the Heartbleed-related OpenSSL risk and documents backup-related issue fixes.
- `Evidence`:
	- OpenSSL 1.0.1h shipping is highlighted under Important news for 11.2.4. [source: docs/UV-11.2.4.md | section: Important news]
	- UNV-5287 describes uvbackup/uvrestore behavior correction in build 4709. [source: docs/UV-11.2.4.md | section: Issues by release]
- `Not Found / Limits`: None.
