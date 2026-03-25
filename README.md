# UniVerse Release Notes — VS Code Copilot Skill

This workspace contains a custom VS Code Copilot skill for answering questions about UniVerse release notes, issue fixes, and version updates.

## Quick Start

Invoke the skill explicitly in Copilot Chat using `/mv-uv`, then ask your question.

Copy and paste any of these into Copilot Chat:

- /mv-uv What was fixed in UNV-5287?
- /mv-uv Compare 11.2.4 and 11.3.4 for security-related updates.

## What Is Included

- `.github/skills/mv-uv/SKILL.md`: Skill definition for UniVerse release-note lookup behavior.
- `.github/instructions/mv-release-notes.instructions.md`: Workspace instruction rules for answer quality, strict response template, and citation format.
- `docs/`: Release note source documents used as the knowledge base. In git-based use this is sourced from the external GitHub repo `https://github.com/BryanTieu/mv-release-notes.git`. In zip-based use it can be downloaded automatically on first session.

## What This Skill Can Answer

- Issue lookups (example: `UNV-5287`)
- Version summaries (example: `11.2.4`)
- Version comparisons (example: `11.2.4 vs 11.3.4`)
- Component/platform impact questions (example: Backup Tools, AIX, Linux, Windows)
- Upgrade-impact and release-change questions

## How To Use

1. Open Copilot Chat in this workspace.
2. Invoke the skill explicitly: `/mv-uv`.
3. Ask a release-note question in natural language.
4. Include issue IDs and versions when possible for best precision.
5. For comparisons, explicitly name both versions.

## Recommended Prompt Patterns

- `What was fixed in UNV-5287?`
- `Summarize important changes in UniVerse 11.3.4.`
- `Compare 11.2.4 and 11.3.4 for security-related updates.`
- `Does 14.2.1 include changes that affect Python/OpenSSL compatibility?`
- `Which release mentions Backup Tools fixes?`

## Expected Answer Format

Responses are configured to follow this strict structure:

1. `Answer`
2. `Evidence`
3. `Not Found / Limits`
4. `Compared Versions` (comparison questions only)

## Citation Format

Every factual statement should include a source citation:

- `[source: docs/<file>.md | section: <section name>]`
- For multiple sources: `[sources: docs/<file1>.md | section: <section>; docs/<file2>.md | section: <section>]`

If information is missing, answers should include checked files:

- `[checked: docs/UV-11.2.4.md, docs/UV-11.3.4.md, docs/UV-14.2.1.md]`

## Tips For Best Results

- Use exact issue IDs when available.
- Ask one main question per message.
- Name versions explicitly.
- If you need full coverage, ask the assistant to check all files under `docs/`.

## Troubleshooting

- If answers are too broad: Add specific version or issue number.
- If answer says not found: Verify spelling and whether the issue appears in current `docs/` files.
- If citations are missing: Ask the assistant to re-answer with strict citation style.

## Extending The Skill

- Add new release note files under `docs/` using consistent naming (example: `UV-14.2.2.md`).
- Keep section headings in release notes clear to improve citation quality.
- Update `.github/skills/mv-uv/SKILL.md` if new workflows are needed.

## External Docs Repo

The release note source is stored in:

- `https://github.com/BryanTieu/mv-release-notes.git`

In a git-based workspace, `docs/` is configured as a git submodule. To pull the latest release notes into this workspace:

- `git submodule update --remote --merge docs`
- `./scripts/update-docs.ps1`

If this is the first time the repo has been cloned by another user:

- `git clone --recurse-submodules https://github.com/BryanTieu/uv-release-notes-ai-skill.git`
- or, after clone: `./scripts/update-docs.ps1 -Init`

## Reuse For Other Users

This skill is reusable by other users as long as they open this repository in VS Code with the `.github/` customizations intact.

Recommended sharing model:

1. Keep this repository as the reusable skill workspace.
2. Keep release notes in the external GitHub repo used by the `docs/` submodule.
3. Ask users to clone this repository with submodules.
4. Users open the repo in VS Code and use `/mv-uv`.

If you want broader reuse, this repository can also be turned into a GitHub template so other teams can create their own copy with the same skill setup.

## Zip Distribution Without Docs

You can zip this project without the `docs/` folder to keep the package smaller.

How it works for the recipient:

1. They unzip the project.
2. They open it in VS Code.
3. The session-start hook runs `./scripts/update-docs.ps1 -NonBlocking`.
4. If `docs/` is missing and the workspace is not operating as a git submodule checkout, the script downloads the markdown repository archive from GitHub and populates `docs/` automatically.
5. The skill can then read the downloaded markdown files normally.

Requirements for zip-based use:

- Internet access to GitHub on first use
- PowerShell available in VS Code environment

If the automatic fetch fails, the user can retry manually:

- `./scripts/update-docs.ps1`

## Will New Markdown Files Be Read?

Yes. New markdown files added to the external docs repository will be available to the skill after the local `docs/` submodule is updated.

How it works:

1. A new `.md` file is added to `https://github.com/BryanTieu/mv-release-notes.git`.
2. This workspace either pulls the latest submodule commit or downloads the latest repository archive.
3. The new file appears under `docs/` locally.
4. The skill can read it because the workflow and instructions operate against files in `docs/`.

To make newly added markdown files visible locally, run one of these:

- `git submodule update --remote --merge docs`
- `./scripts/update-docs.ps1`

This workspace also includes a Copilot session-start hook that attempts to refresh `docs/` automatically when a new agent session begins:

- `.github/hooks/docs-sync.json`

Important note:

- The skill does not read GitHub directly.
- It reads the local `docs/` folder.
- So new remote files become available once the local `docs/` folder has been refreshed.
- The automatic hook is non-blocking. If GitHub is unavailable, the session still continues and users can retry manually with `./scripts/update-docs.ps1`.

## Refresh After Changes

If slash commands do not appear immediately, reload the VS Code window and re-open Copilot Chat.

