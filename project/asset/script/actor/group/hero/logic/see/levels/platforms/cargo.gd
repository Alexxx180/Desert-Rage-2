extends Area2D

var hero: CharacterBody2D

func _enter_stand(stand: Area2D) -> void:
	stand.set_entered(hero)

func _exit_stand(stand: Area2D) -> void:
	stand.set_exited(hero)
