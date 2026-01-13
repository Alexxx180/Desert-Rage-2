extends Node

const PREVIEW: Dictionary = { "SIZE": Vector2(72, 72),
	"ICON": "res://asset/resource/media/image/inventory/" }

var logic: Node
var holder: Texture2D = null
var _image: TextureRect

func get_slot(slot: int) -> Dictionary: return logic.slot(slot)

func lmb_out(e: InputEventMouseButton) -> bool:
	return e.button_index == MOUSE_BUTTON_LEFT and e.is_released()

func move(e: InputEvent) -> void:
	if e is InputEventMouseButton and lmb_out(e):
		reset_texture(_image)

func put_item(item: Dictionary, image: TextureRect) -> void:
	var path: String = PREVIEW.ICON
	if item.has("item"):
		path += item.item.icon
	else:
		path += logic.item(item.id).item.icon
	var file: Image = Image.load_from_file(path)
	image.texture = ImageTexture.create_from_image(file)

func reset_holder() -> void: holder = null

func remove_item(image: TextureRect) -> void:
	image.texture = null

func reset_texture(image: TextureRect) -> void:
	if holder != null:
		image.texture = holder
		reset_holder()

func get_preview_rect() -> TextureRect:
	var image: TextureRect = TextureRect.new()
	image.texture = holder
	image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	image.size = PREVIEW.SIZE
	image.position -= PREVIEW.SIZE / 2
	return image

func set_preview(cell: CellDrag) -> CellDrag:
	_image = cell.image
	holder = cell.image.texture
	var preview: Control = Control.new()
	preview.add_child(get_preview_rect())
	cell.image.set_drag_preview(preview)
	remove_item(cell.image)
	return cell

func _input(event: InputEvent) -> void: move(event)
