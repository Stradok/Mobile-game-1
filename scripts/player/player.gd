class_name Player
extends CharacterBody3D

enum State { GROUND, AIR, SWING }

var state := State.AIR
var yaw := 0.0
var pitch := -0.25
var anchor := Vector3.ZERO
var rope_len := 0.0
var _pivot: Node3D
var _rope: MeshInstance3D
var scripted := false  # tests call try_swing/release_swing directly

static func ensure_input() -> void:
	var keys := {move_f = KEY_W, move_b = KEY_S, move_l = KEY_A, move_r = KEY_D, jump = KEY_SPACE, swing = KEY_SHIFT}
	for a in keys:
		if not InputMap.has_action(a):
			InputMap.add_action(a)
			var e := InputEventKey.new()
			e.physical_keycode = keys[a]
			InputMap.action_add_event(a, e)

func _ready() -> void:
	ensure_input()
	var col := CollisionShape3D.new()
	var cap := CapsuleShape3D.new()
	cap.height = 1.8
	cap.radius = 0.4
	col.shape = cap
	col.position.y = 0.9
	add_child(col)
	var body := MeshInstance3D.new()
	var m := CapsuleMesh.new()
	m.height = 1.8
	m.radius = 0.4
	body.mesh = m
	body.position.y = 0.9
	add_child(body)
	_pivot = Node3D.new()
	_pivot.position.y = 1.6
	add_child(_pivot)
	var arm := SpringArm3D.new()
	arm.spring_length = 7.0
	arm.add_excluded_object(get_rid())
	_pivot.add_child(arm)
	var cam := Camera3D.new()
	cam.far = 600.0
	arm.add_child(cam)
	_rope = MeshInstance3D.new()
	_rope.mesh = ImmediateMesh.new()
	_rope.top_level = true
	add_child(_rope)

func _unhandled_input(ev: InputEvent) -> void:
	if ev is InputEventMouseButton and ev.pressed:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	elif ev is InputEventKey and ev.pressed and ev.keycode == KEY_ESCAPE:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif ev is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		yaw -= ev.relative.x * 0.003
		pitch = clampf(pitch - ev.relative.y * 0.003, -1.3, 0.6)

func try_swing() -> bool:
	var fwd := Vector3(velocity.x, 0, velocity.z)
	if fwd.length() < 2.0:
		fwd = Basis(Vector3.UP, yaw) * Vector3.FORWARD
	var a: Variant = AnchorFinder.find(self, fwd.normalized())
	if a == null:
		return false
	anchor = a
	rope_len = global_position.distance_to(anchor)
	state = State.SWING
	return true

func release_swing() -> void:
	if state != State.SWING:
		return
	velocity *= Tuning.get_value("release_boost")
	state = State.AIR
	(_rope.mesh as ImmediateMesh).clear_surfaces()

func _physics_process(dt: float) -> void:
	_pivot.rotation = Vector3(pitch, yaw, 0)
	var inp := Input.get_vector("move_l", "move_r", "move_f", "move_b")
	var wish := Basis(Vector3.UP, yaw) * Vector3(inp.x, 0, inp.y)
	var g := Tuning.get_value("gravity")

	if Input.is_action_just_pressed("swing") and state != State.SWING:
		try_swing()
	if state == State.SWING and not Input.is_action_pressed("swing") and not scripted:
		release_swing()

	match state:
		State.GROUND:
			var hv := Vector3(velocity.x, 0, velocity.z).move_toward(wish * Tuning.get_value("walk_speed"), Tuning.get_value("ground_accel") * dt)
			velocity = Vector3(hv.x, velocity.y, hv.z)
			if Input.is_action_just_pressed("jump"):
				velocity.y = Tuning.get_value("jump_velocity")
				state = State.AIR
			elif not is_on_floor():
				state = State.AIR
		State.AIR:
			velocity.y -= g * dt
			velocity += wish * Tuning.get_value("air_accel") * dt
		State.SWING:
			velocity.y -= g * dt
			velocity += wish * Tuning.get_value("swing_steer") * dt
			rope_len = maxf(rope_len - Tuning.get_value("swing_rope_shorten") * dt, Tuning.get_value("swing_min_rope"))
			velocity = velocity.limit_length(Tuning.get_value("swing_max_speed"))

	move_and_slide()

	if state == State.SWING:
		var off := global_position - anchor
		if off.length() > rope_len:
			var n := off.normalized()
			global_position = anchor + n * rope_len
			if velocity.dot(n) > 0.0:
				velocity -= n * velocity.dot(n)
		if is_on_floor():
			release_swing()
			state = State.GROUND
		_draw_rope()
	elif state == State.AIR and is_on_floor():
		state = State.GROUND


func _draw_rope() -> void:
	var im := _rope.mesh as ImmediateMesh
	im.clear_surfaces()
	im.surface_begin(Mesh.PRIMITIVE_LINES)
	im.surface_add_vertex(global_position + Vector3.UP * 1.4)
	im.surface_add_vertex(anchor)
	im.surface_end()
