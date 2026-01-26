extends Control

@onready var scroll: ScrollContainer = $scroll
@onready var ui: Array = scroll.get_node("stack").get_children()
@onready var count: int = len(ui)

var select: int = 0

func _ready() -> void:
	for i in count:
		ui[i].margin.caption.hide()
		ui[i].showcase.pressed.connect(func(): _change(i))
		ui[i].update_hint(Defaults.ARRAY)

func _select_next(next: int) -> int:
	match next:
		-1: return count - 1
		count: return 0
	return next

func _change(next: int) -> void:
	ui[select].margin.caption.hide()
	select = _select_next(next)
	var caption: RichTextLabel = ui[select].margin.caption
	caption.show()
	caption.grab_focus()

func _input(event: InputEvent) -> void:
	for i in [["forward", -1], ["backward", 1]]:
		if Input.is_action_pressed(i[0]):
			_change(select + i[1])
