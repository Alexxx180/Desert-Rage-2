extends VBoxContainer

signal on_hidden()

@onready var animation: AnimationPlayer = $animation

enum { HIDDEN = 0, IN_PROCESS = 1, SHOWED = 2 }
var status: int = HIDDEN

func show_hint() -> void:
	_show_hint(IN_PROCESS, "appear")

func _show_hint(next: int, anim_name: String):
	status = next
	animation.play("hint_appearance/" + anim_name)

func on_showed() -> void:
	status = SHOWED

func on_hide() -> void:
	on_hidden.emit()

func _input(_event: InputEvent) -> void:
	if not Prompters.moved(): return

	match status:
		IN_PROCESS:
			status = HIDDEN
			animation.stop()
			on_hidden.emit()
		SHOWED:
			_show_hint(HIDDEN, "disappear")
