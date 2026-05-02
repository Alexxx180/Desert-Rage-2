extends FocusedSlider

@export_range (0, 100, 1) var default_volume: float = 50
@export var bus_name: String = "Master"

const FILE: String = "user://settings.json"

var bus_index: int

# Sound Slider Focus

func _ready() -> void:
	super._ready()
	print("BUS: ", AudioServer.get_bus_name(0))
	bus_index = AudioServer.get_bus_index(bus_name)
	value_changed.connect(_on_value_changed)
	var json: Dictionary = Vault.get_json(FILE, func(s): pass)
	if json != Defaults.DICT:
		default_volume = json.music
	_init()

func _init() -> void:
	value = default_volume
	_set_value(default_volume)

func _set_value(next: float) -> void:
	var db: float = linear_to_db(next / max_value)
	AudioServer.set_bus_volume_db(bus_index, db)
	
func _on_value_changed(value_to_change: float) -> void:
	_set_value(value_to_change)
	Vault.set_json(FILE, { "music": value_to_change })
