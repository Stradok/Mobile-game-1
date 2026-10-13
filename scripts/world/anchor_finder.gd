class_name AnchorFinder
## Fans rays forward/up from the player; returns the best swing anchor point, or null.

static func find(player: CharacterBody3D, fwd: Vector3) -> Variant:
	var space := player.get_world_3d().direct_space_state
	var origin := player.global_position + Vector3.UP * 1.5
	var range_ := Tuning.get_value("swing_range")
	var min_d := Tuning.get_value("swing_min_dist")
	var best: Variant = null
	var best_score := -INF
	for yaw_off in [-0.6, -0.3, 0.0, 0.3, 0.6]:
		for pitch in [0.5, 0.7, 0.9, 1.1]:
			var d: Vector3 = fwd.rotated(Vector3.UP, yaw_off) * cos(pitch) + Vector3.UP * sin(pitch)
			var q := PhysicsRayQueryParameters3D.create(origin, origin + d * range_)
			q.exclude = [player.get_rid()]
			var hit := space.intersect_ray(q)
			if hit.is_empty():
				continue
			var p: Vector3 = hit.position
			var dist := origin.distance_to(p)
			if dist < min_d:
				continue
			var flat := Vector3(p.x - origin.x, 0, p.z - origin.z).normalized()
			var score := flat.dot(fwd) * 20.0 - absf(dist - 35.0) * 0.3 + clampf(p.y - origin.y, 0.0, 40.0) * 0.2
			if score > best_score:
				best_score = score
				best = p
	return best
