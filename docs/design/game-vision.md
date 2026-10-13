# Game Vision

Working title: **SKYLINE** (placeholder). Original IP. Offline, single-player, Godot 4, Android/iOS/desktop.

## Core fantasy
You are a lone vigilante who owns the sky of a dense neon city. Moving *is* the game: never touching the ground, chaining swings, zips and glides at speed, then dropping onto trouble.

## Core loop
- **Moment-to-moment:** swing, zip, glide, dive, chain. Speed meter rewards flow.
- **Short-term (1-3 min):** reach a rooftop objective, clear a patrol, collect a beacon.
- **Session (10-20 min):** 2-3 missions, upgrade a gadget.
- **Long-term:** unlock traversal upgrades (longer line, boost, wing handling), districts, cosmetics.

## Traversal (the pillar)
| Move | Reference feel | Design |
|---|---|---|
| Swing | Spider-Man 2 | Hold: auto-anchor ahead/above on geometry, pendulum rope, momentum preserved, release at arc bottom to launch, steer to pump speed |
| Zip | Batman | Tap a ledge/gargoyle: line pulls you to the point, snappy; release gives an upward **grapple-boost** |
| Glide/dive | Both | Wings/cape in air; dive trades height for speed, pull-up trades speed for height |
| Chain | - | swing > release > dive > zip-boost > swing; flow meter drives FOV, wind audio, haptics, score |

## Story (vertical-slice outline, expand later)
City of Veyra is run by the Halcyon Group, whose drones watch every street. A blackout leaves the skyline unmonitored; the Wraith (player) uses the window to dismantle Halcyon's relay towers. Factions: Halcyon security, street crews, an informant on the radio. Told through radio chatter and environmental details during play, not text dumps.

## Content plan (post-playground)
- 1 district, 3 enemy types (drone, patrol guard, heavy), 1 boss relay tower.
- 3-4 missions + repeatable: beacon runs, time trials, rooftop challenges.
- Gadgets as data (line length, boost power, glide drag).
- Later: more districts, NG+, cosmetics.

## UX goals
Onboarding in-world within 60 s; one-thumb-friendly controls; strong aim assist; readable HUD (speed meter, objective arrow); no menus mid-flow.
