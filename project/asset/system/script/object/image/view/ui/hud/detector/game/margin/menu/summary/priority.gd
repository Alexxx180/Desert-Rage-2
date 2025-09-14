extends VBoxContainer

@onready var xp: ProgressBar = $margin/level/progress
@onready var count: Dictionary = {
	"ray": [$description/number/ray/normal, $description/number/ray/selected],
	"rock": [$description/number/rock/normal, $description/number/rock/selected]
}
@onready var next: Label = $description/next

var main: String = "ray"

func set_priority(no: int, summary: Dictionary) -> void:
	for hero in count:
		for caption in count[hero]:
			var lv: int = summary.hero[hero].of[no]
			caption.text = str(lv)
	next.text = str(summary.hero[main].of[no] + 1)
	next.visible = summary.hero[main].of[no] != PlayerXP.MAX_LV

func update_exp(value: int, maximum: int) -> void:
	xp.value = value
	xp.max_value = maximum
