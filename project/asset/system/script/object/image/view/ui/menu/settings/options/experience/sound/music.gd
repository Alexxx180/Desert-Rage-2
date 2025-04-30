extends FocusedSlider

@export_range (0, 100, 1) var default_volume: float = 50
@export var bus_name: String = "Master"

var bus_index: int

func _ready() -> void:
	super._ready()
	print("BUS: ", AudioServer.get_bus_name(0))
	bus_index = AudioServer.get_bus_index(bus_name)
	value_changed.connect(_on_value_changed)
	_init()

func _init() -> void:
	value = default_volume
	_on_value_changed(default_volume)
	
func _on_value_changed(value_to_change: float) -> void:
	var db: float = linear_to_db(value_to_change / max_value)
	AudioServer.set_bus_volume_db(bus_index, db)
