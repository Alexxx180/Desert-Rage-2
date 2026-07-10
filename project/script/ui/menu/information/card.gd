extends Button

@onready var help: RichTextLabel = $help
@onready var image: TextureRect = $icon

var no: int

const TIME: float = 0.2
const MARGIN: String = "\n\n\n\n\n\n\n\n\n\n\n\n\n\n"

func translate() -> void:
	text = tr("H" + Def.hints[no] + "T") + MARGIN
	help.text = tr("H" + Def.hints[no] + "D") % [] # Def

func update_hint(next: int) -> void:
	no = next
	image.texture = ImageTexture.create_from_image(Def.help.get_layer_data(no))
	translate()

func _ready() -> void: pressed.connect(flip_the_card)

func flip_the_card() -> void:
	if image.visible:
		_change_state(image, help)
	else:
		_change_state(help, image)

func change_state(prev: CanvasItem, next: CanvasItem) -> Callable:
	return func(x: float):
		if -0.5 <= x and x <= 0.5 and prev.visible:
			prev.hide()
			next.show()
		self.scale = Vector2(abs(x), 1)

func _change_state(prev: CanvasItem, next: CanvasItem) -> void:
	var tween: Tween = create_tween()
	tween.set_parallel(false)
	tween.tween_method(change_state(prev, next), -1.0, 1.0, TIME)
