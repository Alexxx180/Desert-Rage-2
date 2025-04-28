extends HFlowContainer

@onready var music: HSlider = $music
@onready var sound: HSlider = $sound
@onready var interface: HSlider = $interface

func get_items(items: FocusedItems) -> Array[Control]:
	items.grabbed.push_back(music)
	items.grabbed.push_back(sound)
	items.grabbed.push_back(interface)
	return [music.submit, sound.submit, interface.submit, $system]
