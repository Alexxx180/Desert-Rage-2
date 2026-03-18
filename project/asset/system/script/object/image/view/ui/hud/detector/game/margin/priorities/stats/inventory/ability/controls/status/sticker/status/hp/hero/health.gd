extends MarginContainer

@onready var damage: PanelContainer = $damage
@onready var status: HBoxContainer = $damage/status
@onready var points: HBoxContainer = $damage/status/margin/points
@onready var back: TextureRect = $damage/back

const MAX: float = 0.95

var icons: Dictionary = {
	"max": "😖😣😩🫩🙄😧🥲🌚🗿",
	"med": "🫨😬😑😒😯🤕😆😮‍💨😦",
	"min": "😏🤨😪😁😎🥱🤠🙂‍↔️"
}

func faced(p: float) -> String:
	return "max" if p <= 0.2 else ("med" if p <= 0.8 else "min")

func change(hp: Node) -> void:
	show()
	points.change(hp)
	var portion: float = hp.points / hp.maximum
	back.texture.fill_to.y = MAX * portion
	var icon: String = icons[faced(portion)]
	var no: int = randi_range(0, len(icon) - 1)
	status.face.text = icon[no]
