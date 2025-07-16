extends HFlowContainer

@onready var pause: Button = $pause
@onready var analyze: Button = $help
@onready var menu: Button = $menu

@onready var skills: PanelContainer = get_node("../hints/scroll/stack/skills")
