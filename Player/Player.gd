extends KinematicBody2D

const MAX_SPEED = 80
const ACCELERATION = 500
const FRICTION = 500
const ROLL_SPEED = 100

var velocity = Vector2.ZERO
enum {
	MOVE, ROLL, ATTACK
}

var state = MOVE
var roll_vector = Vector2.RIGHT

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitbox

func _ready():
	animationTree.active = true
	
func _physics_process(delta):
	match state:
		MOVE: 
			move(delta)
		ROLL:
			roll()
		ATTACK:
			attack()
			
func move(delta):
	var input_vector = Vector2.ZERO
	swordHitbox.knockback = input_vector
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		animationState.travel("Run")
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		animationState.travel("Idle")
	
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	if Input.is_action_just_pressed("roll"):
		state = ROLL

func roll():
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	velocity = move_and_slide(velocity)
		
func attack():
	velocity = Vector2.ZERO
	animationState.travel("Attack")
	
func attack_finished():
	state = MOVE

func roll_finished():
	velocity = velocity * 0.7
	state = MOVE
