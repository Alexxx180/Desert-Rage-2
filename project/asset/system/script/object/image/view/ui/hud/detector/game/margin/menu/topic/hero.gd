extends PanelContainer

@onready var status: Label = $margin/description
@onready var timing: Timer = $hiding
@onready var health: ProgressBar = $health
@onready var aura: ProgressBar = $aura
@onready var slot: Label = $slot

func _ready() -> void:
	timing.timeout.connect(hide)

func reload_timer():
	if not status.visible:
		show()
	timing.start()
	return self

func notify(text: String) -> void:
	status.text = text
	reload_timer().show()

func new_slot(unicode: String) -> void:
	slot.text = unicode
	slot.modulate = Color.WHITE
	create_tween().tween_property(slot, "modulate", Color.TRANSPARENT, 2.0)

func hp_change(next: int) -> void:
	reload_timer().health.value = next

func ap_change(next: int) -> void:
	reload_timer().aura.value = next
