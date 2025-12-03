extends Node

enum { DIR = 1, QUARTER = 6, HALF = 12, FULL = 24 }

const HALF_DIR: float = 0.5

func set_priorities(split: SplitContainer) -> void:
# TODOT RELATION ABILITY
	split.navigation.set_property(HALF_DIR, [FULL], split.stack.status.ray.bag,
		[
			../stats/inventory/topic/scroll/margin/stack/flow/controls/summary/status
			../stats/inventory/ability/controls/hints/space/preview/help
			../stats/inventory/ability/controls/markers/margin/score/stack
		]
	)
	# focus

func controls(hud: CanvasLayer, group: Node2D, game: Control) -> void:
	# game TODOT ABILITY
	set_priorities(game.priorities)
