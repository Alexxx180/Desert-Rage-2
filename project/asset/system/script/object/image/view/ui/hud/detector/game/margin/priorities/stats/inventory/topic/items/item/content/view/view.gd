extends Control

@onready var image: TextureRect = $image
@onready var both: TextureRect = $both

var prev: Vector2 = Vector2.ZERO
var prev_text: Texture2D = null
var inventory: Node

func _get_drag_data(at_position: Vector2) -> Variant:
	prev = at_position
	var preview: Control = Control.new()
	var preview_text: TextureRect = image.get_preview_texture()
	preview.add_child(preview_text)
	set_drag_preview(preview)
	prev_text = preview_text.texture
	image.texture = null
	return { "a": preview_text.texture, "b": both.texture, "c": self }

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	# print("prev: ", prev, " - at_position: ", at_position)
	return data is Dictionary

func _drop_data(at_position: Vector2, data: Variant) -> void:
	image.texture = data.a
	both.texture = data.b
	data.c.prev_text = null
	data.c.image.texture = null

func remove_item() -> void: image.hide() # for ui in [icon, image]: ui.hide()

func put_item(value: String) -> void:
	print("ICON VALUE: ", value)
	image.texture = ImageTexture.create_from_image(Image.load_from_file(value))
	image.show()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
		if prev_text != null:
			image.texture = prev_text
			prev_text = null
