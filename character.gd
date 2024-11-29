extends CharacterBody3D

const SPEED = 1.0
const RUN_SPEED = 2.5
const JUMP_VELOCITY = 3.5

var sensitivity = 0.5

@onready var head = $Head
@onready var body = $Armature
@onready var anime_player = $AnimationPlayer

@export var joystick: VirtualJoystick

func _input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		rotate_y(deg_to_rad(-event.relative.x * sensitivity))
		head.rotate_x(deg_to_rad(event.relative.y * sensitivity))
		body.rotate_y(deg_to_rad(event.relative.x * sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-70), deg_to_rad(85))

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		if anime_player.current_animation != "jump":
			anime_player.play("jump")

	# Get the input direction and handle the movement/deceleration.
	var input_dir := joystick.output
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		body.look_at(position + direction * 100)
		
		if Input.is_action_pressed("run"):
			velocity.x = direction.x * RUN_SPEED
			velocity.z = direction.z * RUN_SPEED
			if anime_player.current_animation != "run":
				anime_player.play("run")
		else:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			if anime_player.current_animation != "walk":
				anime_player.play("walk")
	else:
		if anime_player.current_animation != "jump":
			anime_player.play("jump")
		if is_on_floor() and velocity.length() == 0:
			if anime_player.current_animation != "idle":
				anime_player.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	move_and_slide()
