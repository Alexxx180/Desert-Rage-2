extends Label

var stats: Dictionary = {
	"power": "SPWD", "influence": "SNFD",
	"vitality": "SVTD", "reaction": "SRCD"
}

func sets(stat: String) -> void:
	text = tr(stats[stat])
