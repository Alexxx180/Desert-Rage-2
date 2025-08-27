extends Button

@export var path: String = ""

func _ready() -> void:
	var chats: BoxContainer = get_node(path)
	chats.show_toggle.connect(func(state):
		visible = state)
	#print("chats: ", chats.name)
	#print("stop")
	pressed.connect(chats.show_from_panel)
