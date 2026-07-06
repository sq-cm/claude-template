#!/usr/bin/env node
/**
 * extract.mjs — transcript extraction for the review-claudemd skill.
 *
 * Reads Claude Code session transcripts (~/.claude/projects/<project-slug>/*.jsonl),
 * keeps only the behavioural signal (user text, assistant text, tool-call digests),
 * strips hook noise / tool results / thinking mechanically, redacts secret-shaped
 * strings, and writes one plain-text file per session to --out.
 *
 * Zero dependencies. Node 18+.
 *
 * Usage:
 *   node extract.mjs --out <dir> [--count 20] [--min-size 20480]
 *                    [--since YYYY-MM-DD] [--exclude <sessionId>] [--project-dir <path>]
 */

import fs from 'node:fs';
import path from 'node:path';
import os from 'node:os';

// ---------- args ----------
const args = process.argv.slice(2);
function argVal(name, fallback) {
  const i = args.indexOf(name);
  return i !== -1 && args[i + 1] !== undefined ? args[i + 1] : fallback;
}
const OUT = argVal('--out');
const COUNT = parseInt(argVal('--count', '20'), 10);
const MIN_SIZE = parseInt(argVal('--min-size', '20480'), 10);
const SINCE = argVal('--since', null); // YYYY-MM-DD, filters on file mtime
const EXCLUDE = argVal('--exclude', null); // current session id (filename stem)
const PROJECT_DIR = path.resolve(argVal('--project-dir', process.cwd()));

if (!OUT) {
  console.error('error: --out <dir> is required');
  process.exit(1);
}
if (Number.isNaN(COUNT) || COUNT < 1) {
  console.error('error: --count must be a positive integer');
  process.exit(1);
}
if (Number.isNaN(MIN_SIZE) || MIN_SIZE < 0) {
  console.error('error: --min-size must be a non-negative integer (bytes)');
  process.exit(1);
}

// ---------- locate transcript dir ----------
// Claude Code stores transcripts under ~/.claude/projects/<slug>/ where <slug>
// is the project path with every non-alphanumeric character replaced by '-'.
const slug = PROJECT_DIR.replace(/[^a-zA-Z0-9]/g, '-');
const convoDir = path.join(os.homedir(), '.claude', 'projects', slug);
if (!fs.existsSync(convoDir)) {
  console.error(`error: transcript directory not found: ${convoDir}`);
  console.error('hint: run from the project root, or pass --project-dir <path>');
  process.exit(1);
}

// ---------- select sessions ----------
const sinceMs = SINCE ? Date.parse(SINCE) : null;
if (SINCE && Number.isNaN(sinceMs)) {
  console.error(`error: --since must be YYYY-MM-DD, got: ${SINCE}`);
  process.exit(1);
}
const sessions = fs
  .readdirSync(convoDir)
  .filter((f) => f.endsWith('.jsonl'))
  .map((f) => {
    const st = fs.statSync(path.join(convoDir, f));
    return { id: f.replace(/\.jsonl$/, ''), file: path.join(convoDir, f), size: st.size, mtimeMs: st.mtimeMs };
  })
  .filter((s) => s.id !== EXCLUDE)
  .filter((s) => s.size >= MIN_SIZE)
  .filter((s) => (sinceMs ? s.mtimeMs >= sinceMs : true))
  .sort((a, b) => b.mtimeMs - a.mtimeMs)
  .slice(0, COUNT);

if (sessions.length === 0) {
  console.error('error: no sessions matched the filters');
  process.exit(1);
}

// ---------- redaction ----------
// Order matters: PEM first (multi-line-ish), then specific token shapes, then generic assignments.
const REDACTIONS = [
  [/-----BEGIN [A-Z ]+-----[\s\S]*?-----END [A-Z ]+-----/g, '[REDACTED:pem]'],
  [/\bsk-[A-Za-z0-9_-]{10,}\b/g, '[REDACTED:api-key]'],
  [/\bgh[pousr]_[A-Za-z0-9]{20,}\b/g, '[REDACTED:github-token]'],
  [/\bxox[baprs]-[A-Za-z0-9-]{10,}\b/g, '[REDACTED:slack-token]'],
  [/\bAKIA[A-Z0-9]{16}\b/g, '[REDACTED:aws-key]'],
  [/\beyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9._-]{10,}\b/g, '[REDACTED:jwt]'],
  [/\b(bearer)\s+[A-Za-z0-9._~+/=-]{15,}/gi, '$1 [REDACTED:token]'],
  [/\b((?:api[_-]?key|access[_-]?token|auth[_-]?token|secret|password|passwd|token)\s*[=:]\s*)["']?[^\s"']{8,}/gi, '$1[REDACTED:credential]'],
  [/\b[A-Fa-f0-9]{48,}\b/g, '[REDACTED:hex]'], // 48+ so 40-char git SHAs survive
  // Require a '+' or trailing '=' so long paths / URL segments don't false-positive.
  [/\b(?=[A-Za-z0-9/]*[+=])[A-Za-z0-9+/]{64,}={0,2}(?![A-Za-z0-9+/=])/g, '[REDACTED:base64]'],
];
function redact(text) {
  let out = text;
  for (const [re, sub] of REDACTIONS) out = out.replace(re, sub);
  return out;
}

// ---------- noise stripping ----------
function stripNoise(text) {
  return text
    .replace(/<system-reminder>[\s\S]*?<\/system-reminder>/g, '')
    .replace(/<local-command-stdout>[\s\S]*?<\/local-command-stdout>/g, '')
    .replace(/<local-command-caveat>[\s\S]*?<\/local-command-caveat>/g, '')
    .trim();
}

// ---------- tool-call digests ----------
const TRUNC = 200;
function firstLine(s) {
  return String(s ?? '').split('\n')[0].slice(0, TRUNC);
}
function toolDigest(name, input = {}) {
  switch (name) {
    case 'Bash':
    case 'PowerShell':
      return firstLine(input.command);
    case 'Read':
    case 'Write':
    case 'Edit':
    case 'NotebookEdit':
      return input.file_path ?? '';
    case 'Glob':
    case 'Grep':
      return input.pattern ?? '';
    case 'Agent':
      return `${input.subagent_type ?? 'general-purpose'} — ${firstLine(input.prompt)}`;
    case 'Skill':
      return `${input.skill ?? ''} ${firstLine(input.args ?? '')}`.trim();
    case 'AskUserQuestion': {
      const qs = Array.isArray(input.questions) ? input.questions.map((q) => q.question) : [];
      return firstLine(qs.join(' | '));
    }
    default: {
      try {
        return JSON.stringify(input).slice(0, TRUNC);
      } catch {
        return '';
      }
    }
  }
}

// ---------- per-session extraction ----------
fs.mkdirSync(OUT, { recursive: true });
const manifest = [];

const extracted = [];

for (const s of sessions) {
  // Whole-file read is fine at observed transcript sizes (≤ a few MB per session).
  const lines = fs.readFileSync(s.file, 'utf8').split('\n').filter(Boolean);
  const out = [];
  const toolNames = new Map(); // tool_use id → tool name, for digesting user answers
  for (const raw of lines) {
    let o;
    try {
      o = JSON.parse(raw);
    } catch {
      continue;
    }
    if (o.isSidechain === true) continue; // subagent chatter, not the main conversation
    if (o.type === 'user') {
      if (o.isMeta) continue;
      const c = o.message?.content;
      if (typeof c === 'string') {
        const cmd = c.match(/<command-name>([\s\S]*?)<\/command-name>/);
        if (cmd) {
          const cmdArgs = c.match(/<command-args>([\s\S]*?)<\/command-args>/);
          out.push(`USER (command): ${cmd[1].trim()} ${cmdArgs ? cmdArgs[1].trim() : ''}`.trim());
          continue;
        }
        const text = stripNoise(c);
        if (text) out.push(`USER: ${text}`);
      } else if (Array.isArray(c)) {
        for (const b of c) {
          if (b.type === 'text') {
            const text = stripNoise(b.text ?? '');
            if (text) out.push(`USER: ${text}`);
          } else if (b.type === 'tool_result' && toolNames.get(b.tool_use_id) === 'AskUserQuestion') {
            // User decisions/answers are prime Missing-lens signal — keep, digested.
            const rc = b.content;
            const text = stripNoise(
              typeof rc === 'string'
                ? rc
                : Array.isArray(rc)
                  ? rc.filter((x) => x.type === 'text').map((x) => x.text).join(' ')
                  : ''
            );
            if (text) out.push(`USER (answer): ${text.slice(0, 500)}`);
          }
          // all other tool_result blocks: dropped
        }
      }
    } else if (o.type === 'assistant') {
      const c = o.message?.content;
      if (!Array.isArray(c)) continue;
      for (const b of c) {
        if (b.type === 'text') {
          const text = (b.text ?? '').trim();
          if (text) out.push(`ASSISTANT: ${text}`);
        } else if (b.type === 'tool_use') {
          toolNames.set(b.id, b.name);
          out.push(`TOOL: ${b.name} — ${toolDigest(b.name, b.input)}`);
        }
        // thinking blocks: dropped
      }
    }
    // every other line type (attachment, system, mode, snapshots, ...): dropped
  }

  extracted.push({ session: s, body: redact(out.join('\n\n')) + '\n' });
}

// ---------- sparse-session filter ----------
// A raw file can pass --min-size yet extract to almost nothing (tool_result- or
// sidechain-heavy sessions). Near-empty bodies carry no analytical signal and would
// also poison prefix-dedupe (a lone "/clear" line prefix-matches everything).
const MIN_EXTRACTED = 500;
const sparse = extracted.filter((a) => a.body.length < MIN_EXTRACTED).map((a) => a.session.id);
const substantive = extracted.filter((a) => a.body.length >= MIN_EXTRACTED);

// ---------- fork/resume dedupe ----------
// Session forks and resumes duplicate whole histories into new .jsonl files. If one
// extracted body is a prefix of another (or identical), keep the longer and drop the
// shorter so the same conversation isn't counted twice as evidence.
const dropped = [];
const kept = substantive.filter((a, ai) => {
  const dup = substantive.some((b, bi) => {
    if (b === a) return false;
    if (b.body === a.body) return bi < ai; // identical: keep the first (most recent)
    // slice(0,-1): ignore the trailing newline when prefix-matching
    return b.body.length > a.body.length && b.body.startsWith(a.body.slice(0, -1));
  });
  if (dup) dropped.push(a.session.id);
  return !dup;
});

for (const { session: s, body } of kept) {
  const dest = path.join(OUT, `session-${s.id}.txt`);
  fs.writeFileSync(dest, body);
  manifest.push({
    file: dest,
    session: s.id,
    lastActive: new Date(s.mtimeMs).toISOString(),
    rawBytes: s.size,
    extractedBytes: Buffer.byteLength(body),
  });
}

// ---------- manifest ----------
console.log(
  JSON.stringify(
    { transcriptDir: convoDir, sessions: manifest.length, skippedSparse: sparse, droppedForkDuplicates: dropped, files: manifest },
    null,
    2
  )
);
