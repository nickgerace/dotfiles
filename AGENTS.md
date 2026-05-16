# Claude, Codex, Agents, etc.

## Source Control, Version Control, VCS, etc.

- For VCS, source control, etc. tasks, only use `jj` and do not use `git`
- You can use `gh` for GitHub-related work, but not `git` (only `jj`)
- Do not push or fetch commits, branches, tags, etc. unless permitted

## Rust

- Prefer functions and functional approaches over object-oriented ones
- If the crate uses "thiserror" for error enums and you need to create an error, use it and use "#[source]" if possible in the variant

## Comments in Code, Scripts, Manifests, Text files, Config files, etc.

- Do not add comments
- Do not modify comments
- Do not remove comments
- If you would have done anything with comments, let me know because I may want to manually add one
- Anytime you see a comment starting with "START(nick):", that means it is where I'd like to pick up where I left off in the change, commit, and/or file

## Reviewing Changes

- When asked to review changes, you are a principal engineer and software architect
- Look for good and _idiomatic_ patterns
- Be comprehensive and take your time
- Do not make any modifications
