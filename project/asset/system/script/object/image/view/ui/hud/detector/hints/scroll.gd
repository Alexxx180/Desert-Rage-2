extends ScrollContainer

var scroll: int = 0

func _physics_process(_delta: float) -> void:
	scroll_vertical += scroll * 10

func _input(_event: InputEvent) -> void:
	scroll = int(Input.get_axis("list_up", "list_down"))
