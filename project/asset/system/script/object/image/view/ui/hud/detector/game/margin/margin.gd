extends HFlowContainer

@onready var pause: Button = $pause
@onready var menu: Button = $menu

@onready var skills: PanelContainer = get_node("../hints/space/scroll/stack/skills")
@onready var status: HBoxContainer = $status
