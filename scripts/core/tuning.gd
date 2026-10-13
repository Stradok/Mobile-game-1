class_name Tuning
## All feel values live in data/tuning.json. Static so tests need no autoload.
static var _d: Dictionary = {}

static func get_value(key: String) -> float:
	if _d.is_empty():
		_d = JSON.parse_string(FileAccess.get_file_as_string("res://data/tuning.json"))
	return _d[key]
