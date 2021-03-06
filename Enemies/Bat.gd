extends KinematicBody2D

const FRICTION = 200
var knockback = Vector2.ZERO
onready var stats = $Stats

func _physics_process(delta):
	#print(knockback)
	if knockback != Vector2.ZERO:
		knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
		knockback = move_and_slide(knockback)
	
func _on_HurtBox_area_entered(area):
	stats.health -= 1
	knockback = area.knockback * 120
		
func _on_Stats_no_health():
	queue_free()
