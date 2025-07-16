extends PanelContainer

@onready var slap: Button = $margin/ray/left/weapon/knuckles/slap

func init_focus() -> void: slap.grab_focus()
