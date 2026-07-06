extends HFlowContainer

@onready var music: HSlider = $music
@onready var sound: HSlider = $sound
@onready var interface: HSlider = $interface
@onready var system: Button = $system

func set_soundtrack_transition(settings: CanvasLayer, ost: CanvasLayer) -> void:
	system.pressed.connect(func(): settings.hide() ; ost.show())

func get_items(items: FocusedItems) -> Array[Control]:
	get_sound(items)
	return [music.submit, sound.submit, interface.submit, system]

func get_sound(items: FocusedItems) -> void:
	items.grabbed.push_back(music)
	items.grabbed.push_back(sound)
	items.grabbed.push_back(interface)
	var footer: Button = get_node("../footer")
	for slider in items.grabbed:
		slider.hold_focus.connect(footer.set_controls)
	music.set_neighbor("../../../header", sound.get_neighbor())
	sound.set_neighbor(music.get_neighbor(), interface.get_neighbor())
	interface.set_neighbor(sound.get_neighbor(), "../system")
	system.focus_neighbor_left = interface.get_neighbor()
