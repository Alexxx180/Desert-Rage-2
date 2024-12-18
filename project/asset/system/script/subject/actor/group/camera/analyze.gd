extends Node2D

func get_analyze() -> Dictionary:
	return {
		"motion": {
			"jump": $gap,
			"land": $upland,
			"push": $box,
		}
	}
