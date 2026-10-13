extends SceneTree
## Run: godot --headless --path . --script tests/movement_test.gd

func _initialize() -> void:
	var pg: Node = load("res://scenes/playground.tscn").instantiate()
	root.add_child(pg)
	await physics_frame
	var p: Player = pg.player
	p.scripted = true
	# walk: lands on ground
	for i in 90:
		await physics_frame
	assert(p.state == Player.State.GROUND, "player should land on ground, state=%s" % p.state)
	# swing: from height, moving toward towers
	p.global_position = Vector3(20, 45, 20)
	p.velocity = Vector3(0, 0, -12)
	p.state = Player.State.AIR
	assert(p.try_swing(), "anchor should be found")
	var max_speed := 0.0
	var max_stretch := 0.0
	for i in 90:
		await physics_frame
		max_speed = maxf(max_speed, p.velocity.length())
		max_stretch = maxf(max_stretch, p.global_position.distance_to(p.anchor) - p.rope_len)
	assert(p.state == Player.State.SWING, "still swinging, state=%s" % p.state)
	assert(max_stretch < 0.6, "rope stretched %.2f" % max_stretch)
	assert(max_speed > 14.0, "swing should build speed, max=%.1f" % max_speed)
	var before := p.velocity.length()
	p.release_swing()
	assert(p.state == Player.State.AIR and p.velocity.length() >= before, "release keeps momentum")
	print("PASS movement_test: max_speed=%.1f stretch=%.2f" % [max_speed, max_stretch])
	quit()
