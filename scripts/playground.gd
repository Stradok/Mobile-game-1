extends Node3D
## Box-city test playground: ground, random towers, sun, HUD.

var player: Player
var _hud: Label

func _ready() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 7
	_box(Vector3(0, -0.5, 0), Vector3(900, 1, 900), Color(0.15, 0.15, 0.18))
	for x in range(-200, 201, 40):
		for z in range(-200, 201, 40):
			var h := rng.randf_range(20, 90)
			var w := rng.randf_range(14, 22)
			_box(Vector3(x, h / 2, z), Vector3(w, h, w), Color.from_hsv(rng.randf_range(0.5, 0.75), 0.4, rng.randf_range(0.4, 0.8)))
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-50, 30, 0)
	add_child(sun)
	var env := WorldEnvironment.new()
	env.environment = Environment.new()
	env.environment.background_mode = Environment.BG_COLOR
	env.environment.background_color = Color(0.45, 0.6, 0.8)
	env.environment.fog_enabled = true
	env.environment.fog_density = 0.004
	add_child(env)
	player = Player.new()
	player.position = Vector3(20, 2, 20)
	add_child(player)
	var layer := CanvasLayer.new()
	_hud = Label.new()
	_hud.position = Vector2(16, 16)
	layer.add_child(_hud)
	add_child(layer)

func _process(_dt: float) -> void:
	_hud.text = "%s  speed %.1f  fps %d\nWASD move, Space jump, hold Shift swing, click to capture mouse" % [
		Player.State.keys()[player.state], player.velocity.length(), Engine.get_frames_per_second()]

func _box(pos: Vector3, size: Vector3, color: Color) -> void:
	var b := StaticBody3D.new()
	b.position = pos
	var mi := MeshInstance3D.new()
	var bm := BoxMesh.new()
	bm.size = size
	var mat := StandardMaterial3D.new()
	mat.albedo_color = color
	bm.material = mat
	mi.mesh = bm
	var cs := CollisionShape3D.new()
	var bs := BoxShape3D.new()
	bs.size = size
	cs.shape = bs
	b.add_child(mi)
	b.add_child(cs)
	add_child(b)
