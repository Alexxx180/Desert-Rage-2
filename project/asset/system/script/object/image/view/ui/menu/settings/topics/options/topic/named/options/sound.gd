extends HFlowContainer

func get_items() -> Array[Control]:
	return [$music.submit, $sound.submit, $interface.submit, $system]
