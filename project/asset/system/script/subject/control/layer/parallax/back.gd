extends ParallaxLayer

@export var speed: float = 0.5

@onready var group: Node2D = get_node("../../group")

var leader: CharacterBody2D:
	get: return group.deploy.party.leader

func _physics_process(delta):
	self.motion_offset = leader.position * speed
	# self.motion_offset.x += delta * speed
