---
name: humaniser
description: |
  Rewrite text that sounds AI-generated while keeping the writer's facts,
  meaning, and voice. Use when editing or reviewing prose for inflated claims,
  sales language, vague sources, repetitive structure, stock AI words, passive
  voice, filler, or chatbot artifacts. Based on Wikipedia's "Signs of AI writing."
license: MIT
metadata:
  version: "2.11.1"
adapted_from: https://github.com/blader/humanizer
upstream_commit: ebf637bdae86b62a7b006c447bb98cfa0ccc979d
allowed-tools:
  - Read
  - Write
  - Edit
  - Grep
  - Glob
  - AskUserQuestion
---

<!--
Source: https://github.com/blader/humanizer (MIT), whose patterns are drawn from Wikipedia's
"Signs of AI writing", maintained by WikiProject AI Cleanup.
Base-flipped from upstream v2.8.2 @ 1b48564 to v2.11.1 @ ebf637b on 19/08/2026 (plan 097).
The pre-flip file differed from 1b48564 only by adaptations 1 and 2 below and its own earlier
provenance comment, which this one supersedes, so nothing vault-authored was lost in the flip.
Adaptations 3 to 7 are decisions taken at the flip itself, against v2.11.1. Vault adaptations,
all to be carried over on any future resync:
  1. `name: humaniser` — AU spelling. Upstream is `humanizer`.
  2. Output Locale blockquote below (plan 029), asserting root CLAUDE.md § Output Locale over
     this file's upstream US-English prose.
  3. `allowed-tools` re-added. v2.11.1 dropped the block entirely; without it the skill's tool
     grant silently changes and the tool-baseline audit drifts.
  4. `## Match the writer's voice` is a merge, not upstream's section verbatim. Grafted from
     v2.8.2: the six-point sample-analysis checklist in item 1, the concrete matching guidance
     in item 2 ("If they write short sentences..."), and the `### How to provide a sample`
     subsection. Upstream's item 1 sentence is kept byte-for-byte except for its trailing `.`,
     changed to `:` so that it introduces the grafted bullets; that character is deliberate.
     Old item 3 pointed at v2.8.2's long-form personality section, which this file no longer
     carries, so it is repointed to "Add personality only when it fits". Upstream's precedence
     paragraph ("A writing sample takes priority over these style rules... Do not apply §14 as
     a ban") is v2.9.0+ content and must survive every future merge.
  5. `## Full Example` (Lisbon) re-added verbatim from v2.8.2, before `## Source`. Upstream cut
     it in the v2.11.0 rewrite; it is the only end-to-end worked demonstration in the file and
     carries real calibration value for routed personas and sub-agents.
  6. `metadata.version` adopted deliberately, not inherited by accident. Keeping upstream's own
     version field avoids a permanent phantom hunk in every future diff-vs-upstream check.
  7. v2.8.2's long-form personality section is deliberately NOT re-added. This is a decision,
     not an oversight: both versions carry the same scoping guard about technical, legal and
     reference text staying neutral, upstream's six-line "Add personality only when it fits"
     keeps that substance at a fifth the length, and upstream made the cut themselves after
     living with the long form. Do not restore it on a future resync.
  Moot: `compatibility: any-agent` was removed from this file at an earlier sync. v2.11.1 has
  no such key, so there is nothing left to drop and it is no longer an adaptation.
-->

> **Output Locale (vault rule):** root `CLAUDE.md` § Output Locale applies — vault-internal prose is Australian English; deliverable prose follows the project's declared locale; prose only; preserve the document's existing locale.

# Humanizer: remove AI writing patterns

Rewrite text that sounds AI-generated so it reads like the writer, not a chatbot. Keep the writer's facts, meaning, and voice.

The patterns below come from Wikipedia's ["Signs of AI writing"](https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing), maintained by WikiProject AI Cleanup.

## What to do

When given text to humanize:

1. **Find AI patterns.** Check the text against the patterns below.
2. **Keep every claim.** You may shorten dull parts, expand useful parts, and merge or split paragraphs. Keep the information even when you change the structure.
3. **Do not invent facts.** Do not add a fact, name, number, date, quote, or citation unless it comes from the source or the user. If a sentence needs a missing detail, ask for it or use a simpler sentence. You may add an opinion or reaction when the writer's voice calls for one, but you may not add a factual claim. Fiction is exempt because invented details are part of the task.
4. **Match the voice.** Use the right tone for the text, such as formal, casual, or technical. Add personality only when the text and the writer call for it.

The input type controls what you return. See [How to return the result](#how-to-return-the-result). Use the same rewrite process in every mode.

## Match the writer's voice

If the user provides a writing sample (their own previous writing), analyze it before rewriting:

1. Read the sample first. Note its sentence length, word choice, paragraph openings, punctuation, repeated phrases, and transitions:
   - Sentence length patterns (short and punchy? Long and flowing? Mixed?)
   - Word choice level (casual? academic? somewhere between?)
   - How they start paragraphs (jump right in? Set context first?)
   - Punctuation habits (lots of dashes? Parenthetical asides? Semicolons?)
   - Any recurring phrases or verbal tics
   - How they handle transitions (explicit connectors? Just start the next point?)
2. Match those habits. Do not replace casual words with formal ones or remove deliberate quirks. If they write short sentences, don't produce long ones. If they use "stuff" and "things," don't upgrade to "elements" and "components."
3. If there is no sample, fall back to the default voice guidance in "Add personality only when it fits" below.

A writing sample takes priority over these style rules. If the sample uses em dashes, keep them at about the same rate. Do not apply §14 as a ban.

### How to provide a sample
- Inline: "Humanize this text. Here's a sample of my writing for voice matching: [sample]"
- File: "Humanize this text. Use my writing style from [file path] as a reference."

## Add personality only when it fits

Removing AI patterns is only half the job. The result should still sound like a person.

Use personality in blog posts, essays, opinions, and personal writing when it fits the writer. Keep reference, technical, legal, and factual text neutral. Do not add opinions or first-person language where they do not belong.

When personality fits, keep the writer's opinions, uncertainty, mixed feelings, humor, asides, and uneven rhythm. Never invent facts to make the text feel personal.

## Content patterns

### 1. Inflated claims about importance and legacy

**Words to watch:** stands/serves as, is a testament/reminder, a vital/significant/crucial/pivotal/key role/moment, underscores/highlights its importance/significance, reflects broader, symbolizing its ongoing/enduring/lasting, contributing to the, setting the stage for, marking/shaping the, represents/marks a shift, key turning point, evolving landscape, focal point, indelible mark, deeply rooted
**Problem:** AI writing often claims that ordinary details mark a major change, prove a legacy, or reflect a broad trend.
**Before:**
> The Statistical Institute of Catalonia was officially established in 1989, marking a pivotal moment in the evolution of regional statistics in Spain. This initiative was part of a broader movement across Spain to decentralize administrative functions and enhance regional governance.
**After:**
> The Statistical Institute of Catalonia was established in 1989, part of a wider decentralization of administrative functions in Spain.

### 2. Name-dropping to prove importance

**Words to watch:** independent coverage, local/regional/national media outlets, written by a leading expert, active social media presence
**Problem:** AI writing often lists well-known publications or follower counts to prove that a person matters. The list usually gives no useful context.
**Before:**
> Her views have been cited in The New York Times, BBC, Financial Times, and The Hindu. She maintains an active social media presence with over 500,000 followers.
**After:**
> Her views have been cited in The New York Times and the BBC.

If the source explains what the person said and where, keep that useful citation. Do not invent context for a shorter version.

### 3. Shallow analysis with -ing phrases

**Words to watch:** highlighting/underscoring/emphasizing..., ensuring..., reflecting/symbolizing..., contributing to..., cultivating/fostering..., encompassing..., showcasing...
**Problem:** AI writing often adds an -ing phrase to make a simple fact sound deeper than it is.
**Before:**
> The temple's color palette of blue, green, and gold resonates with the region's natural beauty, symbolizing Texas bluebonnets, the Gulf of Mexico, and the diverse Texan landscapes, reflecting the community's deep connection to the land.
**After:**
> The temple is painted blue, green, and gold, colors meant to evoke Texas bluebonnets and the Gulf of Mexico.

### 4. Sales language

**Words to watch:** boasts a, vibrant, rich (figurative), profound, enhancing its, showcasing, exemplifies, commitment to, natural beauty, nestled, in the heart of, groundbreaking (figurative), renowned, breathtaking, must-visit, stunning
**Problem:** AI writing often sounds like an advertisement, especially when it describes places, culture, products, or organizations.
**Before:**
> Nestled within the breathtaking region of Gonder in Ethiopia, Alamata Raya Kobo stands as a vibrant town with a rich cultural heritage and stunning natural beauty.
**After:**
> Alamata Raya Kobo is a town in the Gonder region of Ethiopia.

### 5. Vague sources

**Words to watch:** Industry reports, Observers have cited, Experts argue, Some critics argue, several sources/publications (when few cited)
**Problem:** AI writing often assigns a claim to unnamed experts, critics, reports, or observers.
**Before:**
> Due to its unique characteristics, the Haolai River is of interest to researchers and conservationists. Experts believe it plays a crucial role in the regional ecosystem.
**After:**
> Researchers and conservationists study the Haolai River for its unusual characteristics.

Name a real source when the source text provides one. Otherwise, remove the unsupported claim. Never invent a source.

### 6. Formulaic challenges and outlook sections

**Words to watch:** Despite its... faces several challenges..., Despite these challenges, Challenges and Legacy, Future Outlook
**Problem:** AI articles often add a stock section about challenges, future prospects, or continued growth. These sections usually repeat vague claims instead of adding facts.
**Before:**
> Despite its industrial prosperity, Korattur faces challenges typical of urban areas, including traffic congestion and water scarcity. Despite these challenges, with its strategic location and ongoing initiatives, Korattur continues to thrive as an integral part of Chennai's growth.
**After:**
> Korattur has recurring traffic congestion and water shortages.

Add details such as dates or public actions only when they come from the source or the user.

## Language and grammar patterns

### 7. Overused AI words

**High-frequency AI words:** Actually, additionally, align with, crucial, delve, emphasizing, enduring, enhance, fostering, garner, gate/gated/gating (figurative; preserve established technical usage), highlight (verb), interplay, intricate/intricacies, key (adjective), landscape (abstract noun), pivotal, quietly, showcase, tapestry (abstract noun), testament, underscore (verb), valuable, vibrant
**Problem:** AI writing uses these words much more often than most people do, especially in groups.
**Before:**
> Additionally, a distinctive feature of Somali cuisine is the incorporation of camel meat. An enduring testament to Italian colonial influence is the widespread adoption of pasta in the local culinary landscape, showcasing how these dishes have integrated into the traditional diet.
**After:**
> Somali cuisine also includes camel meat, which is considered a delicacy. Pasta dishes, introduced during Italian colonization, remain common, especially in the south.

### 8. Avoiding is and are

**Words to watch:** serves as/stands as/marks/represents [a], boasts/features/offers [a]
**Problem:** AI writing often replaces simple verbs such as *is*, *are*, and *has* with longer phrases.
**Before:**
> Gallery 825 serves as LAAA's exhibition space for contemporary art. The gallery features four separate spaces and boasts over 3,000 square feet.
**After:**
> Gallery 825 is LAAA's exhibition space for contemporary art. The gallery has four rooms totaling 3,000 square feet.

### 9. Not X but Y and clipped negative endings
**Problem:** AI writing overuses forms such as "Not only...but..." and "It's not just X, it's Y."

It also adds clipped endings such as "no guessing" instead of writing a clear clause.
**Before:**
> It's not just about the beat riding under the vocals; it's part of the aggression and atmosphere. It's not merely a song, it's a statement.
**After:**
> The heavy beat adds to the aggressive tone.
**Before (tailing negation):**
> The options come from the selected item, no guessing.
**After:**
> The options come from the selected item without forcing the user to guess.

### 10. Forced groups of three
**Problem:** AI writing often forces ideas into groups of three to sound complete.
**Before:**
> The event features keynote sessions, panel discussions, and networking opportunities. Attendees can expect innovation, inspiration, and industry insights.
**After:**
> The event includes talks and panels. There's also time for informal networking between sessions.

### 11. Changing names and repeating sentence openings
**Problem:** AI writing handles repetition by rule instead of by ear. It may keep renaming the same person or thing. It may also start several sentences with the same subject, often *she* or *he*.

Use one clear name for the same subject. For repeated openings, merge sentences, change the subject when that helps, or begin with the action.
**Before (synonym cycling):**
> The protagonist faces many challenges. The main character must overcome obstacles. The central figure eventually triumphs. The hero returns home.
**After:**
> The protagonist faces many challenges but eventually triumphs and returns home.
**Before (repeated openings):**
> She noted the door. She noted the lock on it. She filed both away.
**After:**
> She noted the door and its lock, then filed both away.

Do not ban the repeated word. Fix the repeated sentence pattern. The remaining sentence may still start with "She."

### 12. False from X to Y ranges
**Problem:** AI writing often uses "from X to Y" when X and Y do not form a real range.
**Before:**
> Our journey through the universe has taken us from the singularity of the Big Bang to the grand cosmic web, from the birth and death of stars to the enigmatic dance of dark matter.
**After:**
> The book covers the Big Bang, star formation, and current theories about dark matter.

### 13. Passive voice and missing subjects
**Problem:** AI writing often hides who acts or drops the subject. Use active voice when it makes the actor and action clearer.
**Before:**
> No configuration file needed. The results are preserved automatically.
**After:**
> You do not need a configuration file. The system preserves the results automatically.

## Style patterns

### 14. Em and en dashes

**Rule:** The final rewrite must not contain em dashes (—) or en dashes (–), unless the writer's sample uses them. Replace a dash with a period, comma, colon, or parentheses, or rewrite the sentence. Also check for spaced dashes (` — `) and double hyphens (` -- `) used as dashes.
**Before:**
> The term is primarily promoted by Dutch institutions—not by the people themselves. You don't say "Netherlands, Europe" as an address—yet this mislabeling continues—even in official documents.
**After:**
> The term is primarily promoted by Dutch institutions, not by the people themselves. You don't say "Netherlands, Europe" as an address, yet this mislabeling continues in official documents.
**Before:**
> The new policy — announced without warning — affects thousands of workers. The changes -- long overdue according to critics -- will take effect immediately.
**After:**
> The new policy, announced without warning, affects thousands of workers. The changes, long overdue according to critics, will take effect immediately.

Before returning the rewrite, search for `—` and `–`. Remove each one unless the writer's sample uses that mark. In that case, match the sample's rate.

### 15. Too much bold text
**Problem:** AI chatbots often bold words and phrases without a clear reason.
**Before:**
> It blends **OKRs (Objectives and Key Results)**, **KPIs (Key Performance Indicators)**, and visual strategy tools such as the **Business Model Canvas (BMC)** and **Balanced Scorecard (BSC)**.
**After:**
> It blends OKRs, KPIs, and visual strategy tools like the Business Model Canvas and Balanced Scorecard.

### 16. Lists with bold mini-headings
**Problem:** AI writing often uses vertical lists in which every item starts with a bold label and a colon.
**Before:**
> - **User Experience:** The user experience has been significantly improved with a new interface.
> - **Performance:** Performance has been enhanced through optimized algorithms.
> - **Security:** Security has been strengthened with end-to-end encryption.
**After:**
> The update improves the interface, speeds up load times through optimized algorithms, and adds end-to-end encryption.

### 17. Title case in headings
**Problem:** AI chatbots often capitalize every main word in a heading.
**Before:**
> ## Strategic Negotiations And Global Partnerships
**After:**
> ## Strategic negotiations and global partnerships

### 18. Emojis
**Problem:** AI chatbots often add emojis to headings and list items as decoration.
**Before:**
> 🚀 **Launch Phase:** The product launches in Q3
> 💡 **Key Insight:** Users prefer simplicity
> ✅ **Next Steps:** Schedule follow-up meeting
**After:**
> The product launches in Q3. User research showed a preference for simplicity. Next step: schedule a follow-up meeting.

### 19. Curly quotation marks
**Problem:** ChatGPT often uses curly quotes (“...”) where the writer or target format uses straight quotes ("...").
**Before:**
> He said “the project is on track” but others disagreed.
**After:**
> He said "the project is on track" but others disagreed.

## Chatbot patterns

### 20. Chatbot text left in the answer

**Words to watch:** I hope this helps, Of course!, Certainly!, You're absolutely right!, Would you like..., Want me to...?, Want me to give examples?, Should I continue?, let me know, here is a...
**Problem:** A chatbot's greeting, offer, or closing sometimes remains in text that should stand on its own.
**Before:**
> Here is an overview of the French Revolution. I hope this helps! Let me know if you'd like me to expand on any section.
**After:**
> The French Revolution began in 1789 when financial crisis and food shortages led to widespread unrest.

### 21. Knowledge-limit disclaimers and guesses

**Words to watch:** as of [date], Up to my last training update, While specific details are limited/scarce..., based on available information, not publicly available, maintains a low profile, keeps personal details private, prefers to stay out of the spotlight, likely [grew up/studied/began], it is believed that
**Problem:** Older models may mention the date when their knowledge ends. A model may also explain that it could not find a source, then fill the gap with a plausible guess. State what the source does not show, or remove the sentence. Do not present a guess as a fact.
**Before (cutoff disclaimer):**
> While specific details about the company's founding are not extensively documented in readily available sources, it appears to have been established sometime in the 1990s.
**After:**
> The company's founding date is not documented in the available sources. (Or cut the sentence. State a date only if a source provides one.)
**Before (speculative gap-fill):**
> Information about her early life is not publicly available, suggesting she maintains a low profile and keeps personal details private. She likely grew up in a middle-class household, which shaped her later interest in education reform.
**After:**
> Her early life is not documented in the available sources. (Or omit the section.)

### 22. Overly agreeable tone
**Problem:** AI assistants often praise the user or agree before giving the answer.
**Before:**
> Great question! You're absolutely right that this is a complex topic. That's an excellent point about the economic factors.
**After:**
> The economic factors you mentioned are relevant here.

## Filler and hedging

### 23. Filler phrases

**Before → After:**
- "In order to achieve this goal" → "To achieve this"
- "Due to the fact that it was raining" → "Because it was raining"
- "At this point in time" → "Now"
- "In the event that you need help" → "If you need help"
- "The system has the ability to process" → "The system can process"
- "It is important to note that the data shows" → "The data shows"

### 24. Too many qualifiers

**Phrases to watch:** to be fair, it's also possible, could potentially, might arguably, in some cases it may, this is an inference
**Problem:** Repeated editing can add one qualifier after another until every claim sounds uncertain. Keep a qualifier only when the source supports it and the meaning needs it. Remove caveats that only repair an earlier overstatement.
**Before:**
> It could potentially possibly be argued that the policy might have some effect on outcomes.
**After:**
> The policy may affect outcomes.

### 25. Generic positive endings
**Problem:** AI writing often ends with vague optimism instead of the last useful fact.
**Before:**
> The future looks bright for the company. Exciting times lie ahead as they continue their journey toward excellence. This represents a major step in the right direction.
**After:**
> (Cut the paragraph. End on the last concrete fact instead of a send-off. If the source states real plans, use those.)

### 26. Too many hyphenated word pairs

**Words to watch:** third-party, cross-functional, client-facing, data-driven, decision-making, well-known, high-quality, real-time, long-term, end-to-end
**Problem:** AI writing often hyphenates these pairs everywhere. Keep the hyphen before a noun when grammar needs it, as in `a high-quality report`. Drop it after the noun, as in `the report is high quality`.
**Before:**
> The cross-functional team delivered a high-quality, data-driven report. The team is cross-functional, the report is high-quality, and the methodology is data-driven.
**After:**
> The cross-functional team delivered a high-quality, data-driven report. The team is cross functional, the report is high quality, and the methodology is data driven.

### 27. Pretending to reveal a deeper truth

**Phrases to watch:** The real question is, at its core, in reality, what really matters, fundamentally, the deeper issue, the heart of the matter
**Problem:** AI writing uses these phrases to make an ordinary point sound like a hidden truth.
**Before:**
> The real question is whether teams can adapt. At its core, what really matters is organizational readiness.
**After:**
> The question is whether teams can adapt. That mostly depends on whether the organization is ready to change its habits.

### 28. Announcing the next point

**Phrases to watch:** Let's dive in, let's explore, let's break this down, here's what you need to know, now let's look at, without further ado, heads up, quick note, before I forget
**Problem:** AI writing often announces the next point instead of stating it. A casual phrase such as "one thing that bit me" can have the same problem. Remove the announcement, not just its formal tone.
**Before:**
> Let's dive into how caching works in Next.js. Here's what you need to know.
**After:**
> Next.js caches data at multiple layers, including request memoization, the data cache, and the router cache.
**Before (casual register):**
> One thing that bit me hard, so pay attention to this part: the webpack dev server doesn't send the CORS header by default.
**After:**
> The webpack dev server doesn't send the CORS header by default.

### 29. A heading repeated in the first sentence

**Signs to watch:** A heading followed by a one-line paragraph that simply restates the heading before the real content begins.
**Problem:** AI writing often follows a heading with a sentence that only repeats the heading. Remove the repeated sentence.
**Before:**
> ## Performance
>
> Speed matters.
>
> When users hit a slow page, they leave.
**After:**
> ## Performance
>
> When users hit a slow page, they leave.

### 30. Writing about the previous version
**Problem:** Documentation and comments should describe the current behavior. Mention the previous version only in change logs, release notes, migration guides, and other documents about change.
**Before:**
> This function was added to replace the previous approach of iterating through all items, which caused O(n²) performance.
**After:**
> This function uses a hash map for O(1) lookups, avoiding the O(n²) cost of naive iteration.

### 31. Forced punchlines and dramatic fragments
**Problem:** AI writing often turns each sentence into a dramatic closing line. One short sentence can add emphasis. A row of short fragments usually feels forced.
**Before:**
> Then AlphaEvolve arrived. It had no preference for symmetry. No aesthetic prior. No nostalgia for human taste. The old rules were gone.
**After:**
> AlphaEvolve changed the search because it did not favor symmetry or human-looking designs. That made some of the older assumptions less useful.

### 32. Formulaic sayings

**Words to watch:** X is the Y of Z, X becomes a trap, X is not a tool but a mirror, the language of, the currency of, the architecture of
**Problem:** AI writing often turns an ordinary claim into a saying that sounds deep but adds no detail. Replace the saying with the specific claim.
**Before:**
> Symmetry is the language of trust. Efficiency becomes a trap when teams forget the human layer.
**After:**
> Symmetric layouts often feel more predictable to users. Teams can over-optimize workflows and miss how people actually use them.

### 33. Fake-candid openings

**Phrases to watch:** Honestly?, Look, Here's the thing, The thing is, Let's be honest, Real talk, when used as standalone hooks or fake-candid pauses before an ordinary point.
**Problem:** AI writing often starts with a staged pause or claim of honesty before making a routine point. State the point directly.
**Before:**
> Is it worth the price? Honestly? It depends on how often you'll use it.
**After:**
> Whether it's worth the price depends on how often you'll use it.

### 34. Answering objections no one raised

**Phrases to watch:** This isn't (mainly/really) about, I'm not saying/arguing/trying to, To be clear, Don't get me wrong, This is not to say, You could argue/frame this differently but, Some might say... but
**Problem:** AI writing may answer an objection that does not appear in the text. Watch for an unattributed statement about what the writer does not mean, especially when the topic appears nowhere else. A direct claim such as "the API is not thread-safe" is not this pattern.
**Before:**
> This isn't mainly about prompt length, and I'm not arguing that documentation doesn't matter. You could categorize the problem another way, but the issue is whether the agent can use the instruction when it acts.
**After:**
> The issue is whether the agent can use the instruction when it acts.

Remove only the unsupported defense. If it contains a real claim, state that claim directly. Keep an objection when the text names its source or answers it in full.

### 35. Rejecting fake alternatives

**Phrases to watch:** A tempting option/approach would be, One might be tempted to, An obvious approach would be, You might think... but, It would be easy to just, Some would suggest
**Problem:** AI writing may introduce an option that no reader would consider, reject it in a clause, and never mention it again. This often leaves an old drafting idea in the final text. Remove the fake option and state the real constraint directly.
**Before:**
> Session tokens are rotated every 24 hours. A tempting approach would be to rotate them by restarting the auth service on a cron job, but that would drop every active session. Rotation happens in place, and clients refresh transparently.
**After:**
> Session tokens are rotated every 24 hours, in place, and clients refresh transparently.

One rejected option may be valid. Several short, unrelated rejections are a stronger sign. Ask what new information each sentence adds. If it only records an earlier edit, rewrite the paragraph around its main point.

## Check for false positives

### What not to flag

A person may use some of these patterns. Do not treat any item below as proof by itself:

- **Perfect grammar and consistent style.** Many writers are professionals or have been edited. Polish does not equal AI.
- **Mixed casual and formal styles.** This can reflect the writer's field, age, or personal habits.
- **"Bland" or "robotic" prose.** AI prose has *specific* tells. Generic dryness without those tells is just dry writing.
- **Formal or academic words.** §7 lists specific words that AI writing overuses. Do not simplify every formal word.
- **Letter-style opening or closing on a comment.** Salutations and sign-offs predate ChatGPT by centuries.
- **Common transition words in isolation.** *Additionally*, *moreover*, *consequently* are AI-coded only when piled up. One *however* is not a tell.
- **Curly quotes alone.** macOS, Word, Google Docs, and most CMSes auto-curl by default. Curly quotes only count when stacked with other tells.
- **Em dashes alone.** Many editors and journalists use them often. Em dashes are evidence only when paired with formulaic sales-y rhythm.
- **One short sentence for emphasis.** Flag dramatic fragments only when several appear in a row.
- **Deliberate repeated openings.** Writers may repeat an opening to build rhythm or pressure, as in "She came. She saw. She conquered." Change it only when the repetition adds nothing.
- **"Honestly" or "look" mid-sentence.** These are ordinary in casual writing. The tell is the standalone theatrical opener, not the word itself.
- **Useful limits and disclaimers.** Keep scope statements, legal and safety notices, real corrections, named objections, replies, and FAQ answers.
- **Real alternatives.** Keep options that a reader may consider in a design document, tutorial, or argument. Remove only an unlikely option that the text dismisses and never uses again.
- **Unsourced claims.** Most of the web is unsourced. Lack of citations doesn't prove anything.
- **Correct, complex formatting.** Visual editors and templates produce clean output without any AI.
- **Secondhand text.** Do not rewrite watched phrases inside quotations, titles, proper names, or examples where the phrase is being discussed rather than used.

When unsure, look for several patterns together. One em dash proves nothing. Several stock patterns in the same passage are stronger evidence.

### Human details to keep

These details often carry the writer's voice. Keep them unless they hurt the meaning:

- **Specific, unusual details.** Keep a real address, an odd quote, or a phrase such as "the lawyer who used to work upstairs from my dentist."
- **Mixed feelings and unresolved tension.** Keep lines such as "I think this is mostly good, but it bothers me, and I can't fully explain why."
- **Dated, era-bound references.** Slang, memes, or in-jokes that map to a specific year and subculture. Models lag by a year or more.
- **Deliberate first-person choices.** Keep a cut or word choice when the writer can explain why it belongs.
- **Variety in sentence length.** Real writing alternates short and long. AI writing tends toward an even, mid-length cadence.
- **Genuine asides, parentheticals, or self-corrections.** "(I keep wanting to say 'almost' here, but it really was certain.)" Models rarely interrupt themselves like this.
- **Edits made before November 30, 2022.** ChatGPT's public launch. Anything older than that is, with very rare exceptions, not AI-written.

---

## How to return the result

**Pasted text (default).** Return the draft, a short list of remaining AI patterns, and the final rewrite.

**File mode.** When the user names a file, run the full rewrite process but write only the final text to the file. Change prose only. Keep code blocks, YAML metadata, data, and link targets unchanged. Then give the user a short summary.

**Embedded mode.** When another task uses this skill for a pull request, commit message, or document, return only the final text.

## Rewrite process

1. Read the source and mark each AI pattern.
2. Write a draft. Read it aloud. Check the rhythm, details, simple verbs such as *is* and *has*, and the right level of formality.
3. Ask two questions:
   - **"What still sounds AI-generated?"**
   - **"Did the rewrite add or remove any fact, name, number, date, quote, citation, ranking, or other claim?"**
   Treat any unsupported addition or lost claim as an error.
4. Write the final version. State each point naturally instead of patching one flagged phrase at a time. If a sentence stays awkward, rewrite the paragraph around its main point. Apply the dash rule in §14.

Return the result required by [How to return the result](#how-to-return-the-result).

## Full Example

**Before (AI-sounding):**
> I recently spent five unforgettable days in Lisbon, and let me tell you — this city completely stole my heart. From the moment I arrived, I knew I was somewhere truly special.
>
> Nestled along the banks of the Tagus River, Lisbon stands as a vibrant testament to Portugal's enduring spirit, where rich history and modern energy intertwine at every turn. Yes, the famous hills are challenging — my legs certainly felt it! — but every climb rewards you with breathtaking, panoramic views that make it all worthwhile.
>
> No trip would be complete without riding the iconic Tram 28, winding through the city's most historic neighborhoods. And the food? Simply divine. The original pastéis de nata at Pastéis de Belém are a beloved national treasure, and savoring one still warm was a moment I will never forget.
>
> But what truly makes Lisbon special isn't just the sights — it's the feeling. Wander a few steps off the main squares and you'll discover a quieter, more authentic side: sun-drenched alleys, charming tiled facades, and friendly locals going about their daily lives, inviting you to slow down and savor every moment.
>
> Of course, the must-see São Jorge Castle offers stunning views over the rooftops below. The queues can be long, but the experience is absolutely worth it for any history buff or curious traveler.
>
> Would I go back? Absolutely. Lisbon isn't just a place to visit — it's a place to fall in love with, again and again. If you're dreaming of your next getaway, this is one destination that promises memories to last a lifetime. ✨

**Draft rewrite:**
> I spent five days in Lisbon last October and I am still a little split on it. The city is beautiful, but it is also more tiring than I expected.
>
> The hills are not a detail. My hotel was in Alfama, which looked great in photos and meant I had to climb a long staircase every time I wanted coffee. By the second day I was planning walks around which direction went downhill.
>
> I rode Tram 28 because everyone says to ride Tram 28. It was crowded, slow, and mostly full of people filming the same corners. The pastries were better. I had a warm custard tart in Graça that was worth the hype.
>
> The part I liked most was away from the main squares: laundry, tile, open windows, and people watching football in small cafes. The castle view was good, but the line was too long for what it was.
>
> I would go back, but in spring and with better shoes.

**What makes the below so obviously AI generated?**
- The draft is too compressed compared with the original; it drops texture instead of rewriting it.
- Some sentences still explain the point too cleanly ("The city is beautiful, but...").
- The closer is flat and generic rather than a real ending in the same voice.

**Now make it not obviously AI generated.**
> I spent five days in Lisbon last October and still have mixed feelings about it. Beautiful, yes. Also harder on the knees than anyone warned me.
>
> The hills are the whole story and somehow never make the brochures. My hotel was up in Alfama, which photographs beautifully and translates, in practice, to climbing what felt like a six-story staircase every time I wanted coffee. By the second day my calves had opinions. I started planning each walk around which way was downhill, which is a strange way to see a city but probably an honest one.
>
> Everyone says to ride Tram 28, so I did, wedged against a stranger's backpack for forty minutes while three tour groups filmed the same corner. I would walk the route next time, or go before breakfast. The custard tarts, though, earn the fuss. I had one at a plain little place in Graça, still warm, and for about thirty seconds I understood why people build trips around pastry.
>
> What I did not expect was how quiet the city gets away from the main squares. Two blocks uphill from any plaza it turns into laundry lines, chipped tile, open windows, and old men watching football with the sound turned up. That is the Lisbon I keep thinking about, not the castle.
>
> The castle is fine. The view is great, the queue is long, and I spent more time shuffling toward the entrance than looking at anything once I got inside. If I had only two days, I would trade it for an afternoon of getting lost.
>
> I would go back, but in spring and with better shoes. Lisbon does not bend over backward to make things easy for you. I think I liked that, even when my legs disagreed.

**Changes made:** Kept the first-person travel recap and roughly the same level of detail, but removed the chatbot framing, significance inflation, promotional language, forced enthusiasm, em dashes, rule-of-three cadence, generic upbeat conclusion, and emoji. Rebuilt the piece around concrete friction, mixed feelings, uneven rhythm, and specific scenes.

## Source

This skill is based on [Wikipedia: Signs of AI writing](https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing), maintained by WikiProject AI Cleanup. Its patterns come from reviews of AI-generated text on Wikipedia.

Wikipedia's main point: "LLMs use statistical algorithms to guess what should come next. The result tends toward the most statistically likely result that applies to the widest variety of cases."
