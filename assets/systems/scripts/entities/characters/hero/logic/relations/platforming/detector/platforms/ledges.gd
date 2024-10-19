extends Node

func set_control(ledges: Area2D, processor: Node) -> void:
	#ledges.area_entered.connect(printing)
	ledges.area_entered.connect(processor.append)
	ledges.area_exited.connect(processor.remove)

func printing(ledge: Area2D) -> void:
	print(ledge.name)
	print("OOOPS")
