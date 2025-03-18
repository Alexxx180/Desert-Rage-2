extends CanvasLayer

@export var progress: HelpPreview
@onready var hud: Control = $hud

func _ready() -> void:
	var group: Node2D = get_node("../group")
	for hero in group.deploy.party.heroes:
		hero.logic.processors.hud.display = hud
		#hero.plot.connect(hud.detector.game.chat.add_blocks)
	hud.detector.game.margin.hints.preview = progress
