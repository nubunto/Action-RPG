extends Area2D

const GrassEffect = preload("res://Effects/GrassEffect.tscn")

func _ready():
	connect("area_entered", self, "_on_area_entered")

func _on_area_entered(area):
	var main = get_tree().current_scene
	var grass_effect = GrassEffect.instance()
	grass_effect.global_position = global_position
	main.add_child(grass_effect)
	queue_free()
