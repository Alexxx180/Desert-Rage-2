extends VBoxContainer

@export var preview: HelpPreview

#@onready var help: Button = $help
@onready var motion: VBoxContainer = $motion
@onready var behavior: BehaviorTree = $behavior
@onready var blackboard: BehaviorBlackboard = $blackboard

func toggle_help() -> void: #motion.toggle_hints()
	behavior.tick(self, blackboard)

func progress(hint: String, act: String) -> void:
	blackboard.get_value("preview")[hint][act] = true

func _ready() -> void:
	blackboard.set_value("hide", true)
	blackboard.set_value("show", preview.clone())
	blackboard.set_value("preview", preview.help)
	#motion.show_help_button.connect(_on_hide)
