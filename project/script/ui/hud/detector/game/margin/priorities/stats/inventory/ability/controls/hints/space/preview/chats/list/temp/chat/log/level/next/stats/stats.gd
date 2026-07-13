extends RichTextLabel

@onready var add: MarginContainer = $add
@onready var next: MarginContainer = $next
@onready var hexagon: Control = $hexagon

#func _ready() -> void:
#	for r in [add, next, hexagon]: reveal.timeout.connect(r.reveal_stats)

func set_stats(now: Array, prev: Array) -> void:
	var stats: Dictionary = { "now": now, "delta": MakeStats.delta(now, prev) }
	# add.set_stats(stats)
	next.set_stats(stats)
	hexagon.set_stats(stats.now, stats.delta)
