extends CanvasLayer

const LEVEL: String = "%s/%s/%d"

@onready var see: Control = $detector
@onready var processor: Node = $processor
@onready var relation: Node = $relation

func set_preview(group: Node2D, progress: HelpPreview) -> void:
	see.game.controls.preview.help.hints.set_preview(group, progress)

func set_transitions(ui: Dictionary, ost: Node) -> void:
	see.game.visibility_changed.connect(func():
		ost.player.process_mode = (Node.PROCESS_MODE_ALWAYS if see.game.visible
			else Node.PROCESS_MODE_INHERIT)
		ost.player.stream_paused = !see.game.visible)
	
	relation.pause.settings.switch.transit_settings = func():
		see.pause.hide(); ui.settings.show()
		ui.settings.first_focus()
		
	relation.pause.information.switch.transit_info = func():
		see.pause.hide(); ui.information.show()

func _ready() -> void: relation.controls(self)
