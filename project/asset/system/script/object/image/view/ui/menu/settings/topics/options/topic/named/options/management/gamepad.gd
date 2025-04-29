extends HFlowContainer

func get_items() -> Array[Control]:
	return [$preset, $movement, $inventory, $targeting,
		$ability, $ab, $xy, $abxy, $preview]
