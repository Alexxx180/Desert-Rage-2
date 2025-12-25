extends VBoxContainer

@onready var a: PanelContainer = $a
@onready var b: PanelContainer = $b

func hides() -> void: for i in [a, b]: i.hides()
func shows() -> void: for i in [a, b]: i.show()
