# Graphics and Performance

Target: 60 fps mid-range phones, 30 fps floor on low-end, 120 fps cap option on high-end.

## Style
Low-poly, stylized neon city with simple unlit/cheap-lit materials. Silhouette and speed read well; keeps cost low.

## Presets
| | Low | Medium | High |
|---|---|---|---|
| Render scale | 0.6 | 0.8 | 1.0 |
| Shadows | off | 1 cascade | 2-3 cascades |
| MSAA | off | off | 2x |
| Particles | 25% | 60% | 100% |
| Post FX | off | bloom | bloom + fog |
| View distance | short | mid | long |

Auto-detect on first run from GPU/renderer + a short frame-time probe; manual override in Options. Also: FPS cap (30/60/120) and a **battery-saver** mode (30 fps, Low).

## Techniques
- Buildings via `MultiMeshInstance3D` (instancing) with a shared atlas material.
- Chunked city streaming: load/unload districts asynchronously with `ResourceLoader.load_threaded_request`.
- Pooling for drones, bullets, effects, pickups.
- Simple physics: custom movement (no rigid bodies for the player), collision on coarse meshes only.
- Budget: <=150 draw calls and <=300k tris on-screen on mobile.

## Device adaptation
Safe-area-aware HUD anchors, scalable button size and layout in Options, landscape only, optional gamepad/keyboard.

## Profiling plan
Godot monitors + debug overlay each milestone; record fps, draw calls, frame spikes on a low-end Android reference device.
