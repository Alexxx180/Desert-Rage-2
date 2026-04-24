extends Button

@onready var help: RichTextLabel = $help
@onready var image: TextureRect = $icon

@export var hint: HelpHint

const TIME: float = 0.2

func update_locale() -> void:
	text = hint.key("T")

func update_hint() -> void:
	icon.texture = hint.texture
	update_locale()
	help.hint = hint
	help.update_hint(Defaults.ARRAY)

func translate(controls: Node) -> void:
	update_locale()
	help.translate(controls)

func get_locale() -> RichTextLabel:
	return $showcase/margin.caption

func _ready() -> void:
	if hint: update_hint()
	pressed.connect(flip_the_card)

func flip_the_card() -> void:
	if image.visible:
		_change_state(image, help)
	else:
		_change_state(help, image)

func change_state(prev: CanvasItem, next: CanvasItem) -> Callable:
	return func(x: float):
		if Def.among(-0.5, x, 0.5) and prev.visible:
			prev.hide()
			next.show()
		# print_debug("TEST : ", x)
		self.scale = Vector2(abs(x), 1)

func _change_state(prev: CanvasItem, next: CanvasItem) -> void:
	var tween: Tween = create_tween()
	tween.set_parallel(false)
	tween.tween_method(change_state(prev, next), -1.0, 1.0, TIME)
