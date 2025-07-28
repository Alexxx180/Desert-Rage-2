extends Node

var moves: Node

func sync(tree: AdvancedCharacterAnimation) -> void:
	moves.hero = tree.moves.hero
	moves.tree.direction = tree.direction
	moves.tree.request("go", tree.ask("go")) # set_speed(tree.scale)
	moves.set_base_stance("idle") # tree.pose
	moves.set_move_action(tree.ask("move")) # maze
	moves.tree.direct()
