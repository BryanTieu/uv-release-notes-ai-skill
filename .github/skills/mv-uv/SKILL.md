---
name: mv-uv
description: Use only when explicitly invoked as /mv-uv to answer UniVerse release-note questions
user-invocable: true
disable-model-invocation: true
---

# UniVerse Release Notes Lookup

## Invocation Mode
- Explicit only: this skill should run only when the user directly invokes `/mv-uv`.
- Do not auto-load for general release-note questions unless explicit invocation is requested.

This skill enables AI-assisted question answering about UniVerse release notes, fixed issues, and product updates. Users can query release information across multiple product versions (11.2.4, 11.3.4, 14.2.1, etc.).

## Use Cases
- **Issue Lookup**: "What was fixed in issue UNV-5287?"
- **Release Information**: "What are the important changes in UniVerse 11.2.4?"
- **Version Comparison**: "What new features were added between 11.2.4 and 11.3.4?"
- **Component Specific**: "What backup tool fixes are in 11.2.4?"
- **Problem Solving**: "Does my version have a fix for Heartbleed?"

## Knowledge Base
Release notes are stored in `/docs/` as markdown files:
- `UV-11.2.4.md` - UniVerse 11.2.4 (October 2014)
- `UV-11.3.4.md` - UniVerse 11.3.4
- `UV-14.2.1.md` - UniVerse 14.2.1

## Document Structure
Each release notes file contains:
1. **Header** - Product name, version, release date
2. **Important News** - Key announcements (security fixes, breaking changes, requirements)
3. **Issues by Release** - Detailed list of fixes with issue number, description, and affected component

## Workflow for Answering Questions

### Step 1: Identify the Query Type
- **Version-specific**: User asks about a particular release (e.g., "11.2.4")
- **Issue-lookup**: User references an issue number (e.g., "UNV-5287")
- **Cross-version**: User compares versions or asks about evolution
- **Component-based**: User asks about a specific component (e.g., "Backup Tools")

### Step 2: Load Relevant Documentation
- For specific version: Load the corresponding UV-X.X.X.md file
- For issue number: Search all documents for the issue ID
- For broad questions: Load multiple or all available docs

### Step 3: Extract and Synthesize Information
- Locate the relevant section (Important News, Issues by Release, etc.)
- Extract issue numbers, descriptions, and components
- Cross-reference if needed
- Provide context (build number, release date, affected platforms)

### Step 4: Answer Comprehensively
- Include version and build information
- Mention affected components
- Note platform-specific details (AIX, Linux, Windows, etc.)
- Link related issues if applicable

## Quality Criteria
✓ Answers cite specific issue numbers or release features  
✓ Answers include version context and dates  
✓ Answers mention affected components or platforms  
✓ For issue lookups, provide full description from source  
✓ For version questions, highlight important news first  

## Example Prompts to Try
- "What issues were fixed in UniVerse 11.2.4?"
- "Tell me about issue UNV-5287"
- "What's the Heartbleed fix in this release?"
- "Which UniVerse version should I use if I need the backup tools fix?"
- "What changed between 11.2.4 and 11.3.4?"

## Related Skills & Customizations
- **Skill companion**: Use `.github/instructions/mv-release-notes.instructions.md` for shared release-note Q&A behavior
