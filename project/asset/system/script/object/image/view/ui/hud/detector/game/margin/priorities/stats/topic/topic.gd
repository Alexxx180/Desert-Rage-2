extends PanelContainer

@onready var content: HBoxContainer = $scroll/margin/content
@onready var stack: VBoxContainer = content.get_node("stack")
@onready var stamina: Control = content.get_node("margin/stamina")
