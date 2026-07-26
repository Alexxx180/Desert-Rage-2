extends PhysicsBody2D

@export var no: int = 0
@onready var profile: AnimatedSprite2D = $profile

const TEXT: PackedStringArray = ["Это мои чуваки!", "Это среда, мои чуваки!", "Тебя зовут %s",
	"Среда? А... Да!", "Добро пожаловать, путники", "Джентельмены, сообщаю вам, что ныне средний день"]

func _ready() -> void: no = no * 2 + int(Time.get_date_dict_from_system()["weekday"] == 3)

func idle() -> void: HUD.menu.hint.hide()

func act(hero: CharacterBody2D) -> void:
	HUD.menu.hint.text = TEXT[no]
	if TEXT[no].contains("%s"):
		match hero.no:
			Def.RAY: HUD.menu.hint.text %= "RAY"
			Def.ROCK: HUD.menu.hint.text %= "ROCK"
	var tween = create_tween()
	tween.tween_property(profile, ^"frame", 3, 1.0)
	tween.tween_callback(func(): profile.frame = 0)
	HUD.menu.hint.position = position - Vector2(0, 128)
	HUD.menu.hint.show()
