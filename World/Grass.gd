extends Node2D

func create_grass_effect():
	var GrassEffect = load("res://Effects/GrassEffect.tscn")
	var grassEffect = GrassEffect.instance()
	$Sprite.hide()
	add_child(grassEffect)
	yield(grassEffect, "finished")
		
func _on_HurtBox_area_entered(area):
	yield(create_grass_effect(), "completed")
	queue_free()
