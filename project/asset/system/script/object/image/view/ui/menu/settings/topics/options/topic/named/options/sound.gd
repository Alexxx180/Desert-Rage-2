extends HFlowContainer

@onready var music: HSlider = $music
@onready var sound: HSlider = $sound
@onready var interface: HSlider = $interface

func get_items(items: FocusedItems) -> Array[Control]:
	items.grabbed.push_back(music)
	items.grabbed.push_back(sound)
	items.grabbed.push_back(interface)
	var system: Button = $system
	music.set_neighbor("../../../header", sound.get_neighbor())
	sound.set_neighbor(music.get_neighbor(), interface.get_neighbor())
	interface.set_neighbor(sound.get_neighbor(), "../system")
	system.focus_neighbor_left = interface.get_neighbor()
	return [music.submit, sound.submit, interface.submit, system]
