extends InputObserver # HELP = 

@onready var dialog: Node = $dialog
@onready var block: Node = $block
@onready var locale: Node = $locale

func _ready() -> void:
	dialog.cursor.block = block
