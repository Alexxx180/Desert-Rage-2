extends Control

func _ready() -> void:
	var control: Control = get_parent()
	control.focus_entered.connect(func():
		self.grab_focus())
