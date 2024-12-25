extends CharacterBody3D

@onready var animation_player: AnimationPlayer = $Model/AnimationPlayer
@onready var model: Node3D = $Model

const SPEED = 9.0
const JUMP_VELOCITY = 13

var facing_dir = 1

func _ready():
	animation_player.play("Idle")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * 2

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		print("registered jump")
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_up", "ui_down", "ui_left", "ui_right")
	
	if Input.is_action_just_pressed("ui_left"):
			facing_dir = -1
	elif Input.is_action_just_pressed("ui_right"):
			facing_dir = 1
	else:
		pass
	
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.z = direction.z * SPEED
		animation_player.play("Sprint")
	else:
		velocity.z = move_toward(velocity.z, 0, SPEED)
		animation_player.play("Idle")
		
	if facing_dir == -1:
		model.rotation_degrees.y = 180
		#model.rotation.y = 180
	elif facing_dir == 1:
		model.rotation_degrees.y = 0
		#model.rotation.y = 0

	move_and_slide()
