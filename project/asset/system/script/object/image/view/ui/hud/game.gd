extends CanvasLayer

const LEVEL: String = "%s/%s/%d"

@onready var detector: Control = $detector
@onready var processor: Node = $processor
@onready var relation: Node = $relation

func set_preview(group: Node2D, progress: HelpPreview) -> void:
	# TODO FIX HELP PREVIEW
	# detector.game.hints.set_preview(group, progress)
	pass

func set_transitions(ui: Dictionary, ost: Node) -> void:
	detector.game.visibility_changed.connect(func():
		if detector.game.visible:
			ost.player.process_mode = Node.PROCESS_MODE_ALWAYS
		else:
			ost.player.process_mode = Node.PROCESS_MODE_INHERIT
		ost.player.stream_paused = !detector.game.visible)
	
	relation.pause.settings.switch.transit_settings = func():
		detector.pause.hide(); ui.settings.show()
		ui.settings.first_focus()
		
	relation.pause.information.switch.transit_info = func():
		detector.pause.hide(); ui.information.show()

func _ready() -> void: relation.controls(self)
