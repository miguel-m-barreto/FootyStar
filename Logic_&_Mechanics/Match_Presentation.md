# Footy Star v1.0.1
## Match Presentation System (2D Circles + Commentary)

This module defines the **visual and narrative layer** for matches. It wraps around the logical engine in Match.md and presents the game in a way inspired by classic Football Manager: 2D circles on a field with live commentary. Users can watch at variable speeds or skip to the end.

---

## 1 Core principles
- **Keep it lightweight**: 2D circles and simple animations (no 3D).  
- **Highlight the user’s player** with a distinctive outline or glow.  
- **Drive presentation from Match.md events**: each "moment" is visualized and narrated.  
- **Control speed and skipping**: user can accelerate or jump to summary.  
- **Always provide a final report** regardless of watching or skipping.

---

## 2 Visual layer (2D Circles Engine)
- Players: circles sized equally, color-coded by team.  
- User’s player: same circle plus **special border/highlight**.  
- Ball: smaller contrasting circle that moves along passes/shots/dribbles.  
- Field: green background, white lines for touchlines, halfway line, penalty boxes, goal areas, center circle.  
- Movements:  
  - **Pass**: ball linearly moves from passer to receiver.  
  - **Dribble**: player circle moves with ball attached.  
  - **Shot**: ball moves rapidly toward goal; if goal, enters net; else, saved/blocked/wide.  
- Timing: each moment mapped to an animation lasting ~1–3 seconds at x1 speed.

---

## 3 Commentary layer
- Commentary is text-only, appearing in a panel (side or bottom).  
- Templates filled with event data (player names, teams, minute).  
- Examples:  
  - “{minute} — {player} tries his luck from distance… just wide!”  
  - “{minute} — GOAL for {team}! {player} with the finish!”  
  - “{minute} — Brilliant save by the keeper!”  
- Commentary frequency: 1–2 lines per "moment".  
- Variation: multiple templates per event type to avoid repetition.

---

## 4 Speed controls
- User can select playback speed: **x1, x2, x3, x4**.  
- Speed affects animation duration and commentary pacing.  
- **Skip Game** option: bypass visualisation; engine runs full simulation instantly and generates final summary.  
- **Exit to Summary**: button during playback to jump straight to final report.

---

## 5 Final Summary screen
Shown always, even if user skips or exits early.

Format:  
```
Team A   2 – 1   Team B
Goals: Player A (12’), Player B (34’), Player C (88’)

Match Stats:
Shots: 12 | 8
Pass Accuracy: 87% | 80%
Possession: 55% | 45%

Ratings:
Player A 7.2, Player B 7.5, Player C 8.1, ...
```
Contents:
- Scoreline and goals with minutes.  
- Team match stats (shots, pass %, possession, tackles).  
- Individual player ratings from Match.md.  
- MVP/MOM highlight.  
- Export button: save screenshot or report to Career History.

---

## 6 Integration with Match.md
- Match.md computes events, probabilities, ratings.  
- Match Presentation subscribes to events and animates/narrates them.  
- Skip Game: run Match.md to conclusion, skip presentation, show summary.  
- Ratings and XP/SP from Match.md remain unchanged by presentation.

---

## 7 UI/UX design
- **Top panel**: scoreline and match clock.  
- **Main field area**: 2D circles simulation.  
- **Commentary panel**: scrolling text feed.  
- **Controls**: x1/x2/x3/x4 buttons, Skip, Exit to Summary.  
- **Highlight**: user’s player outlined at all times.

---

## 8 Dev notes
- Use deterministic seeds: same match events always produce same animations.  
- Event queue: each Match.md "moment" is converted to {minute, type, actors}.  
- Commentary templates: stored in data/locale files for easy expansion/localisation.  
- Performance: simulation runs decoupled from presentation (logic <-> rendering).  
- Optional: audio cues for goals, whistle, crowd cheer (not MVP).

---

## 9 Future hooks
- Replay key moments at higher fidelity.  
- Add minimal "heatmaps" post-game (ball possession zones).  
- Optional extended commentary packs (different styles).

