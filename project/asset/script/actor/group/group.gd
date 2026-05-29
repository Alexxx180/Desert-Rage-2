extends Node2D

enum { DEPLOYED, OVERWORLD, CASUAL }

@onready var camera: Camera2D = $camera

@export_group("Deployment")
@export_flags_3d_render var mode: int
@export_flags_3d_physics var enemy: int

@export var hints_texture: CompressedTexture2DArray
@export_flags_3d_navigation var eye_seeker_navigation: int ## AI strategy. Move | C = to, F = from
@export_flags_3d_navigation var spider_navigation: int ## AI strategy. Move | C = to, F = from

var ray: CharacterBody2D:
	get: return Works.uploads(self, Def.ray, "group/ray", HUD.REF, upload_hero)
var rock: CharacterBody2D:
	get: return Works.uploads(self, Def.rock, "group/rock", HUD.REF, upload_hero)

var party: Array[CharacterBody2D]:
	get: return [ray, rock]
var work: GroupWork
