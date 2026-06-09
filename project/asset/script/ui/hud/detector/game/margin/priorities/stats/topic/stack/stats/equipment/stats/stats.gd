extends MarginContainer

@onready var bag: HBoxContainer = $value/bag
@onready var description: Label = $description
@onready var heroes: Array = [$value/heroes/ray, $value/heroes/rock] #@onready var heroes: HBoxContainer = $heroes
var main: VBoxContainer:
	get: return heroes[0] # @onready var description: VBoxContainer = $description

func set_stats(summary: Dictionary, hero: String) -> void:
	main.set_stats(summary.stats[hero]) # var summary: Dictionary = level.summary

func connect_description(opened: Button) -> void:
	opened.focus_entered.connect(func(): description.sets(opened.name)) # opened.focus_exited.connect(func(): caption.hide())
	opened.mouse_entered.connect(func(): description.sets(opened.name)) # opened.mouse_exited.connect(func(): caption.hide())

func _ready() -> void:
	for caption in main.stats: connect_description(caption) # for caption in description.get_children():
