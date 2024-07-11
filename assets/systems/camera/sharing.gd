extends Camera2D

func change(previous: Node, next: Node):
	previous.remove_child(self)
	next.add_child(self)
	self.set_owner(next)
	position = Vector2.ZERO
