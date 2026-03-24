@tool
class_name AnimatedTextureRect extends TextureRect

@export var sprites: SpriteFrames
@export var current_animation: String = "default"
@export var frame_index: int = 0
@export_range(0.0, 10, 0.001) var speed_scale: float = 1.0
@export var auto_play: bool = false
@export var playing: bool = false

var refresh_rate: float = 1.0
var fps: float = 30.0
var frame_delta: float = 0.0

func _ready() -> void:
	sync_data()
	if sprites == null:
		process_mode = Node.ProcessMode.PROCESS_MODE_DISABLED
		assert(false, "No suitable sprite frames found, disabling")
	elif auto_play: play()

func sync_data() -> void:
	fps = sprites.get_animation_speed(current_animation)
	refresh_rate = sprites.get_frame_duration(current_animation, frame_index)

func play(animation: String = '') -> void:
	frame_index = 0
	frame_delta = 0.0
	if animation != '': current_animation = animation
	sync_data()
	resume()

func resume() -> void: playing = true
func pause() -> void: playing = false
func stop() -> void:
	pause()
	frame_index = 0

func loop_animation() -> void:
	if not sprites.get_animation_loop(current_animation):
		playing = false

func get_next_frame():
	frame_index += 1
	var frame_count = sprites.get_frame_count(current_animation)
	if frame_index >= frame_count:
		frame_index = 0
		loop_animation()
	sync_data()
	return sprites.get_frame_texture(current_animation, frame_index)

func _set_frame_delta(delta: float) -> void:
	frame_delta += speed_scale * delta
	if frame_delta >= refresh_rate / fps:
		texture = get_next_frame()
		frame_delta = 0

func assert_has_animation() -> void:
	var has: bool = sprites.has_animation(current_animation)
	if not has: pause()
	assert(has, "Animation %s doesn't exist" % current_animation)

func _process(delta: float) -> void:
	if playing:
		assert_has_animation()
		_set_frame_delta(delta)
