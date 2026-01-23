extends VBoxContainer

@onready var settings: Control = $ost/settings
@onready var options: Control = $options
@onready var playback: RichTextLabel = $playback/status
@onready var dropdown: HFlowContainer = $ost/scroll/margin/dropdown
@onready var progress: ProgressBar = $progress

func switch_mode() -> void:
	settings.tabs.switch_mode()
	options.switch_mode()
