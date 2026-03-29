extends Label

var icons: Dictionary = {
	"min": "😖😣😩🫩🙄😧🥲🌚🗿",
	"med": "🫨😬😑😒😯🤕😆😮‍💨😦",
	"max": "😏🤨😪😁😎🥱🤠"
}

func faced(p: float) -> String:
	return "min" if p <= 0.2 else ("med" if p <= 0.8 else "max")

func change(portion: float) -> void:
	var icon: String = icons[faced(portion)]
	var no: int = randi_range(0, len(icon) - 1)
	text = icon[no]
