# Technical Design

Engine: Godot 4.x, GDScript. 3D, Mobile renderer (Vulkan) with Compatibility fallback for low-end.

## Structure
```
project.godot
scenes/        player.tscn, playground.tscn, hud.tscn
scripts/
  player/      player.gd (state machine), swing.gd, zip.gd, glide.gd
  camera/      follow_cam.gd (speed-FOV, look-ahead)
  input/       touch_controls.gd (stick, buttons), input map
  world/       anchor_finder.gd, ledge_marker.gd
  core/        tuning.gd (loads data/tuning.json), game_settings.gd
data/          tuning.json  (all feel values: gravity, rope length, boost, drag...)
tests/         movement_test.gd (headless physics asserts)
```

## Player state machine
`Ground > Air > Swing | Zip | Glide > Air`. One active state, each state a node with `enter/exit/physics_update`. No cross-state calls except via transitions.

## Swing (physics)
- Anchor chosen by `anchor_finder`: sample candidate points on geometry ahead/above within a cone and range, score by alignment with velocity/camera and height; pick best.
- Rope as distance constraint: after integrating, if `|p - anchor| > L`, project onto sphere and remove outward velocity component. Gravity + steering force; slight rope shortening for speed.
- Release preserves tangential velocity plus small forward boost.

## Zip
Target = nearest `LedgeMarker` in view cone (aim assist). Interpolate with ease-in; on arrival apply grapple-boost impulse along up+forward.

## Glide
Lift/drag model: dive increases speed, pull-up converts speed to height with drag; stall below min speed.

## Data-driven
All feel values in `data/tuning.json`, hot-reloaded in debug builds. Debug overlay: speed, state, anchor, FPS.

## Testing
Headless Godot script drives the player with scripted input and asserts: swing conserves energy within tolerance, release velocity >= threshold, zip arrives at target, glide dive gains speed. Run: `godot --headless --script tests/movement_test.gd`.
