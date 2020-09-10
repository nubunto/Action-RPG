extends KinematicBody2D

export (int) var MAX_SPEED = 110
export (int) var ACCELERATION = 120
export (float) var FRICTION = 0.25

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE setget set_state
var motion = Vector2.ZERO

onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")

func set_state(value):
	state = value

func _ready():
	animation_tree.active = true

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			pass
		ATTACK:
			attack_state()

func move_state(delta):
	var input_vector = get_input_vector()
	apply_forces(input_vector)
	apply_friction(input_vector)
	update_animations(input_vector)
	move()
	transition_attack()

func attack_state():
	animation_state.travel("Attack")

func get_input_vector():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return input_vector.normalized()

func apply_forces(input_vector):
	motion = motion.move_toward(input_vector * MAX_SPEED, ACCELERATION)

func apply_friction(input_vector):
	if input_vector == Vector2.ZERO:
		motion = motion.linear_interpolate(Vector2.ZERO, FRICTION)

func update_animations(input_vector):
	if input_vector != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Run/blend_position", input_vector)
		animation_tree.set("parameters/Attack/blend_position", input_vector)
		animation_state.travel("Run")
	else:
		animation_state.travel("Idle")

func move():
	motion = move_and_slide(motion)

func transition_attack():
	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func transition_move():
	state = MOVE
