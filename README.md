# Rhythm Dictation Trainer

A rhythmic dictation trainer for music students. Students listen to a rhythm, then rebuild it from an answer bank of half-measure (or one-beat) rhythms. It works on Chromebooks and on iPhones in Safari.

**Play:** https://drkeyzzz.github.io/rhythm-trainer/

## How it works

**Welcome screen**
- The first time a student opens the app on a device, they enter their **first name, last initial and class code** (or check "I'm not in a class"). The app remembers them, so names fill in automatically on leaderboards and session reports.
- **👤 Name · Class** at the bottom of the page lets them change class or **switch student** on a shared computer. Each student's session report is kept separately.

**Leaderboards:** **Class** (only students with that class code) and **🌎 World** (everyone), each with Easy / Hard / Extreme tabs. After a challenge, students see their rank on both, like "#2 in Period 3 · #47 in the world."

**Levels**
- **Easy:** quarters, eighths, basic sixteenth patterns (four sixteenths, eighth-two sixteenths, two sixteenths-eighth), dotted quarter-eighth, and eighth rests on the beat or right after a note.
- **Hard:** everything in Easy, plus syncopations (eighth-quarter-eighth, rest-quarter-eighth), dotted eighth-sixteenth and sixteenth-eighth-sixteenth figures, off-beat eighths, and eighth rests before sixteenths. Every Hard rhythm includes several of these harder pieces.
- **Extreme:** the Hard pieces plus eighth-note triplets, quarter-note triplets, 3+3+2 (dotted eighth, dotted eighth, eighth), sixteenth-note syncopations, and in compound meter hemiola (three quarters in 12/8) and duplets (dotted eighths). It keeps a few basic pieces so rhythms still make musical sense, but drops most of the Easy ones so the bank stays manageable.

**Practice mode**
- Choose Easy, Hard or Extreme, Simple meter (2/4, 3/4, 4/4) or Compound meter (6/8, 9/8, 12/8), and 2 measures (the default) or 4 measures for extra challenge. You can also lock one time signature.
- **Question** plays the rhythm after a one-measure count-in.
- **My Answer** plays what the student has built so far, including a partial answer, in a different sound.
- Tap a rhythm in the answer bank to fill the outlined slot. Tap a filled slot to select it; the next bank tap replaces it, or **Delete** empties it.
- **Check** marks each slot green or red and shows the correct rhythm. Students press **Next Rhythm** when they're ready.
- Counts appear under each piece as it's placed: **1 e & a** in simple meter, **1 ta & ta a ta** in compound meter, **1 trip let** for triplets, and rests in parentheses, like **(&)**. Counts show in Practice mode only.
- **Rhythms in play** slider (above the answer bank): every visit starts with all rhythms. Slide left to remove the hardest pieces first (down to 2) so beginners have fewer choices; slide right to add them back, easiest first. **Edit** lets you tap individual pieces on or off. Challenge Mode always uses every rhythm.

**Slot sizes**
- 2/4, 4/4, 6/8 and 12/8 split into half measures.
- 3/4 and 9/8 split into one-beat slots, because those meters can't be halved on a beat.

**Challenge Mode**
- Students pick an **Easy**, **Hard** or **Extreme** challenge.
- 5 rhythms, each 4 measures long, mixing simple and compound meters.
- 4 regular plays of each question (blue), then 3 **extra listens** (gold). Each extra listen takes 10% off that rhythm's points. **My Answer** is unlimited.
- Tempo is fixed at 72 so scores compare fairly.
- The leaderboard only appears after all 5 rhythms are finished. Easy, Hard and Extreme have separate leaderboards.
- The score is the percent of correct slots, minus any extra-listen penalties, with ties broken by total time.

**Report Session** (button at the bottom of the practice screen and on the Challenge results screen)
- Saves every checked practice rhythm and finished challenge on that device for the day. A new day starts fresh automatically; **Start fresh** clears today early, for shared computers.
- **Session score (0–100):** 75 points for accuracy (Hard counts ×1.1, Extreme ×1.2; practicing with fewer rhythms in play counts ×0.7–1.0) + 25 points for effort (rhythms done toward a goal of 20, set in `CONFIG.dailyGoal`).
- Shows rhythms done, accuracy, practice time, average listens, best challenge scores, **Doing well** and **Needs work** skills with a suggested practice setting, the **rhythms they missed most** (with what they picked instead), and accuracy by skill and meter.
- **Save as image** makes a JPEG for Google Classroom (Downloads folder on a Chromebook; share sheet on iPhone).
- Each image has a **check code** at the bottom. If an image looks edited, open **Teacher → Check a report code** and type it in; it says whether the name, date, score and rhythm count still match.

**Big screens:** the app sizes itself to the window. On a smart board or projector in full screen (F11) it grows to fill the screen while keeping the whole question and answer bank visible. Phones and normal laptop or Chromebook windows stay at normal size. Use **A− / A+** at the bottom of the page to nudge the size; the app remembers it on that computer.

**Keyboard shortcuts**

| Key | Action |
|---|---|
| Space | Play question |
| A | Play my answer |
| 1–9, 10+ | Pick an answer-bank rhythm by its number (for 10 and up, type both digits quickly) |
| ← → | Move between slots |
| Delete | Clear the selected slot |
| Enter | Check / Submit |
| Esc | Stop, or deselect a slot |

## Class leaderboard setup (one time, about 10 minutes)

Scores are saved in a free Firebase (Google) database. Until it's connected, the leaderboard runs in **test mode**: scores stay in each browser only, and the test Teacher PIN is 2468.

Use a Google account that's allowed to create Firebase projects. Many school accounts block it; a personal Gmail works fine.

1. Go to **console.firebase.google.com** and click **Create a project**. Name it `rhythm-trainer`. You can turn off Google Analytics. Click **Create project**.
2. In the left menu, open **Build → Firestore Database** and click **Create database**. Pick a location near you, choose **Start in production mode**, and click **Create**.
3. Open the **Rules** tab. Replace everything with the contents of [`firestore.rules`](firestore.rules), change `teacher@example.com` to **your** Google email, and click **Publish**.
4. Open **Build → Authentication**, click **Get started**, choose **Google**, switch it on, pick your email as the support email, and click **Save**. Then go to the **Settings** tab → **Authorized domains** → **Add domain** and add `drkeyzzz.github.io`.
5. Click the gear ⚙ → **Project settings**. Under **Your apps**, click the web icon `</>`, name it `rhythm-trainer`, and click **Register app** (skip hosting). Copy the `apiKey`, `authDomain`, `projectId` and `appId` values.
6. Paste them into `const FIREBASE = { ... }` near the top of the script in `index.html`, and commit.

These values are meant to be public. The rules only let visitors read the board and add a properly formed score. Only your Google account can delete scores.

**Classes:** click **Teacher → Sign in with Google → My classes**, type a class name and click **Create class**. Each class gets a 5-character code (like `K7QMA`) to give students. Any teacher can sign in and make their own classes; they can only manage their own.

**Managing scores:** **Teacher → Scores** shows each of your classes. You can delete one entry (for example, an inappropriate name) or reset a class for a new marking period. The admin email in `firestore.rules` (and `CONFIG.adminEmails` in `index.html`) can also manage the **World** board. You can see everything in the Firebase console under **Firestore Database**.

**Free limits:** the free plan allows 50,000 reads and 20,000 new scores per day, far more than a school needs. It never pauses for inactivity.

## Changing the answer bank

All rhythms live in `const BANKS` near the top of the script in `index.html`. Each rhythm has a `level` (`'easy'` rhythms appear in both levels, `'hard'` rhythms only in Hard) and a list of durations in sixteenth-note units. A negative number is a rest; `-2` is an eighth rest. Triplets use `'t8'` (eighth-note triplet note), `'t4'` (quarter-note triplet note) and `'tr8'` (triplet eighth rest).

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

## Radio Delay (bonus tool)

`radio-delay/` is a separate page that delays a live radio broadcast so it lines up with a game on streaming TV: https://drkeyzzz.github.io/rhythm-trainer/radio-delay/

- **Sources:** another browser tab (Chrome/Edge, with "Also share tab audio"), a direct stream link, or the microphone / a line-in cable (works on iPhone).
- **Delay:** 0 to 10 minutes, with ±0.2 / 1 / 5 / 30 second nudges and a slider. The delay is saved between visits.
- **Sync helper:** tap "Heard it" at a moment on the radio, then "Saw it" at the same moment on TV, and it adds the gap.
- **Pause radio:** holds the radio while you pause the TV and picks up where it left off.
