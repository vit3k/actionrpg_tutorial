extends Node2D

signal finished

onready var animatedSprite = $AnimatedSprite

func _ready():
	animatedSprite.frame = 0
	animatedSprite.play("Animate")	
	#yield(animatedSprite, "animation_finished")
	#queue_free()

func _on_AnimatedSprite_animation_finished():
	emit_signal("finished")
	queue_free()
