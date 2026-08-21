# AI-Cinema Skill Drops — Provenance Manifest

Non-git upstream (YouTube-channel file drops), so provenance is recorded as
per-file SHA-256 hashes of the local snapshot at adoption time, plus the PR
that adopted each drop. Verify a snapshot with the command in each section.

## Drop record

| Drop | Adopted | PR(s) | Snapshot path | Hashes |
|------|---------|-------|---------------|--------|
| 3.0  | 14/07/2026 | #197 | `Notes/Team/AI Cinematic World/` (partial — see note) | not hashed at adoption; folder hashed below as found on 21/08/2026 |
| 2    | 04/08/2026 | #260, #261 | `Notes/Team/AI Cinematic World/` | as above |
| 3    | 19/08/2026 | #288 | `Notes/Team/Joey's Skill Files 081626/` | § Drop 3 hashes |

> Drops 1–2 predate this manifest; their hashes record the folder as it
> exists today, not as it was at adoption. Only drop 3 onward is a true
> at-adoption fingerprint baseline for future drops.

## Drop 3 hashes (`Notes/Team/Joey's Skill Files 081626/`)

Command used (run from inside the snapshot folder):

```
find . -type f -print0 | sort -z | xargs -0 sha256sum
```

```
ff8371ba48cc05f37a3b17287b1c16b2466f1654185ad5064a40b6da2c64f6c5 *./banana-pro-director-30/SKILL.md
d5de4cc6edcb9c36df76edfc1977eefed6bb72ef1cc40a9fbc0fdcc64f496b88 *./character-builder/SKILL.md
4373a22447545127fb183dc56ad7a6110c016e35c8ce8665e2addedca51575d0 *./cinema-director-v3/SKILL.md
84bae39ff58e9a0e1ad5422faabd340ecf428cb14e12b3dd138ccf625a46a327 *./story-bible-builder/character-interview.md
7478dc7d14fdcc204101c98f5eb5c9320f9cb4ee142916c636194ae9fe674c90 *./story-bible-builder/character-section-format.md
80aeaaaefd7dace7749fe99b4dd42ed3ef8b2e82403df0614e0b0f9fcfd6d43f *./story-bible-builder/example-bible-excerpts.md
c3f44e2d8e890da070fb1b41bd498cd9bfb71d3550048f1c74d4bea5e00f8145 *./story-bible-builder/SKILL.md
b8dd88d66df00d6b9cf8aa576b7bb711f1053a70db8113e430a2bc0ed544d94e *./transcript.md
```

## AI Cinematic World hashes (`Notes/Team/AI Cinematic World/`)

Command used (run from inside the snapshot folder):

```
find . -type f -print0 | sort -z | xargs -0 sha256sum
```

```
a1020b5196f12c1cbb53cf1432e344f291953b976b8ca17bb3a7679b45ca3f5e *./Cinema Skill Files/banana-pro-director-30/SKILL.md
4e5516970dbfc464730f65570317ecd8508c90cd1f31169143bb96c311539b8e *./Cinema Skill Files/character-builder/SKILL.md
57d9c538ec8aa4b79807a68bd17a7d1d3f024f079bedbdc8c848e7577f53f5ba *./Cinema Skill Files/cinema-director/SKILL.md
84bae39ff58e9a0e1ad5422faabd340ecf428cb14e12b3dd138ccf625a46a327 *./Cinema Skill Files/story-bible-builder/character-interview.md
7478dc7d14fdcc204101c98f5eb5c9320f9cb4ee142916c636194ae9fe674c90 *./Cinema Skill Files/story-bible-builder/character-section-format.md
80aeaaaefd7dace7749fe99b4dd42ed3ef8b2e82403df0614e0b0f9fcfd6d43f *./Cinema Skill Files/story-bible-builder/example-bible-excerpts.md
c3f44e2d8e890da070fb1b41bd498cd9bfb71d3550048f1c74d4bea5e00f8145 *./Cinema Skill Files/story-bible-builder/SKILL.md
8d03b38ec0f64e2af9eaac587f31daec8f899e88f6de65a073fb23e776e0dc08 *./Everything You Need to Start Building Your AI Cinematic World (and my thoughts on HF’s updated T&C).md
```
