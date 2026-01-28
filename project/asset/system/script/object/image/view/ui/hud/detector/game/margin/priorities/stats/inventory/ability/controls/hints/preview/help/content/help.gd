extends ScrollContainer

@onready var hints: VBoxContainer = $content/hints
@onready var books: VBoxContainer = $content/books

@onready var ui: Array = hints.kind.motion.get_children()
@onready var count: int = len(ui)

var select: int = 0

func hide_caption(no: int) -> void:
	ui[no].margin.caption.hide()

func _ready() -> void:
	for i in count:
		hide_caption(i)
		ui[i].showcase.pressed.connect(func():
			if not ui[i].helpiong:
				_change(i))

func _select_next(next: int) -> int:
	match next:
		-1: return count - 1
		count: return 0
	return next

func _change(next: int) -> void:
	hide_caption(select)
	select = _select_next(next)
	var caption: RichTextLabel = ui[select].margin.caption
	caption.show()
	caption.grab_focus()

func _input(_event: InputEvent) -> void:
	for i in [["list_up", -1], ["list_down", 1]]:
		if Input.is_action_pressed(i[0]):
			_change(select + i[1])
