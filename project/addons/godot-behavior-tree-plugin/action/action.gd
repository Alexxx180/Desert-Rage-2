extends BehaviorTreeBase

class_name BehaviorAction

""" Leaf Node. Executes code then proceed. """

func tick(_mark: Tick) -> int: return OK # Leaf Node
