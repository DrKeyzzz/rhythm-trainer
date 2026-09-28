# Rhythm Dictation Trainer

A rhythmic dictation trainer for music students. Students listen to a rhythm, then rebuild it from an answer bank of half-measure (or one-beat) rhythms. It works on Chromebooks and on iPhones in Safari.

**Play:** https://drkeyzzz.github.io/rhythm-trainer/

## How it works

**Levels**
- **Easy:** quarters, eighths, basic sixteenth patterns (four sixteenths, eighth-two sixteenths, two sixteenths-eighth), dotted quarter-eighth, and eighth rests on the beat or right after a note.
- **Hard:** everything in Easy, plus syncopations (eighth-quarter-eighth, rest-quarter-eighth), dotted eighth-sixteenth and sixteenth-eighth-sixteenth figures, off-beat eighths, and eighth rests before sixteenths. Every Hard rhythm includes several of these harder pieces.

**Practice mode**
- Choose Easy or Hard, Simple meter (2/4, 3/4, 4/4) or Compound meter (6/8, 9/8, 12/8), and 2 or 4 measures. You can also lock one time signature.
- **Question** plays the rhythm after a one-measure count-in.
- **My Answer** plays what the student has built so far, including a partial answer, in a different sound.
- Tap a rhythm in the answer bank to fill the outlined slot. Tap a filled slot to select it; the next bank tap replaces it, or **Delete** empties it.
- **Check** marks each slot green or red and shows the correct rhythm. Students press **Next Rhythm** when they're ready.

**Slot sizes**
- 2/4, 4/4, 6/8 and 12/8 split into half measures.
- 3/4 and 9/8 split into one-beat slots, because those meters can't be halved on a beat.

**Challenge Mode**
- Students pick an **Easy** or **Hard** challenge.
- 5 rhythms, each 4 measures long, mixing simple and compound meters.
- Up to 4 plays of each question; **My Answer** is unlimited.
- Tempo is fixed at 72 so scores compare fairly.
- The leaderboard only appears after all 5 rhythms are finished. Easy and Hard have separate leaderboards.
- The score is the percent of correct slots, with ties broken by total time.

**Keyboard shortcuts**

| Key | Action |
|---|---|
| Space | Play question |
| A | Play my answer |
| 1–9 | Pick an answer-bank rhythm |
| ← → | Move between slots |
| Delete | Clear the selected slot |
| Enter | Check / Submit |
| Esc | Stop, or deselect a slot |

## Class leaderboard setup (one time, about 5 minutes)

Scores are saved in a free Supabase database. Until it's connected, the leaderboard runs in **test mode**: scores stay in each browser only, and the test PIN is 2468.

1. Go to **supabase.com**, click **Start your project**, and sign in with GitHub.
2. Click **New project**. Name it `rhythm-trainer`, make up a database password (you won't need it again), and click **Create new project**. Wait about a minute for it to finish.
3. In the left sidebar, open **SQL Editor**.
4. Paste in everything from [`supabase-setup.sql`](supabase-setup.sql). Change `2468` on the line marked **YOUR TEACHER PIN**, then click **Run**. It should say "Success".
5. Click the **Connect** button at the top of the page, or go to **Project Settings → API Keys**. Copy two things:
   - the **Project URL**, which looks like `https://abcdefgh.supabase.co`
   - the **publishable** key (starts with `sb_publishable_`), or the **anon public** key
6. Paste both into `const SUPABASE = { url: '', key: '' }` near the top of the script in `index.html`, and commit.

These two values are meant to be public. The database rules only let visitors read the board and add a score; deleting and resetting require your PIN.

**Managing scores:** at the bottom of the practice screen, click **Teacher** and enter your PIN. From there you can delete one entry (for example, an inappropriate name) or reset the whole leaderboard for a new marking period. You can also see scores in Supabase under **Table Editor → rhythm_scores**.

**Already ran the setup before Easy/Hard levels were added?** Run `supabase-setup.sql` again. It adds the level column and keeps your scores.

**To change your PIN later:** edit the PIN line in `supabase-setup.sql` and run the file again in the SQL Editor. Your scores are kept.

**Note:** Supabase pauses free projects after about a week with no visits. If that happens, the leaderboard shows a "couldn't reach" message. Log in to Supabase and click **Restore project**; your scores are kept.

## Changing the answer bank

All rhythms live in `const BANKS` near the top of the script in `index.html`. Each rhythm has a `level` (`'easy'` rhythms appear in both levels, `'hard'` rhythms only in Hard) and a list of durations in sixteenth-note units. A negative number is a rest; `-2` is an eighth rest.

| Value | Duration |
|---|---|
| 1 | sixteenth |
| 2 | eighth |
| 3 | dotted eighth |
| 4 | quarter |
| 6 | dotted quarter |
| 8 | half |
| 12 | dotted half |

Each rhythm's durations must add up to that bank's slot size. If one doesn't, the app shows a warning at the top of the page.
