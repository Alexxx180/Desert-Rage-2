extends RayCast2D

@onready var vertices: Array[RayCast2D] = [self, $right, $left]
