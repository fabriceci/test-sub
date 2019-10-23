extends Actor

onready var animationPlayer := $AnimationPlayer
onready var sprite := $SpriteContainer
onready var timer := $Timer

enum States { IDLE, WALK, RUN, DASH, DASH_RECOVERY, HIT }
const SPEED = {States.WALK: 20, States.RUN: 40, States.DASH: 100 }

var can_dash := "ready"

func _init():
	_transitions = {
		[States.IDLE, States.WALK]: States.WALK,
		[States.IDLE, States.RUN]: States.RUN,
		[States.IDLE, States.DASH]: States.DASH,
		[States.WALK, States.IDLE]: States.IDLE,
		[States.WALK, States.RUN]: States.RUN,
		[States.WALK, States.DASH]: States.DASH,
		[States.RUN, States.STOP]: States.IDLE,
		[States.RUN, States.WALK]: States.WALK,
		[States.RUN, States.DASH]: States.DASH,
	}

func _ready():
	pass # Replace with function body.
	
func _physics_process(delta: float) -> void:
	
	var input = process_input()
	var wanted_state = new_state(input, _velocity)
	change_state(wanted_state)
	rotate_scale_sprite(input)

	if state == States.DASH:
		yield(get_tree().create_timer(1), "timeout")
		change_state(States.DASH_RECOVERY)
		yield(get_tree().create_timer(2), "timeout")
		change_state(States.IDLE)
		
	_velocity = calculate_move_velocity(_velocity, input.direction)
	var colision = move_and_collide(_velocity)

func enter_state():
	match state:
		States.DASH:
			animationPlayer.play("Rush")
		States.WALK, States.RUN:
			animationPlayer.play("Swim")
		_:
			animationPlayer.play("Idle")

func rotate_scale_sprite(input):
	var direction = input.direction
	if direction.x < 0:
		sprite.scale = Vector2(-1,1)
	elif direction.x > 0:
		sprite.scale = Vector2.ONE
		
	if (direction.x > 0 && direction.y < 0) || (direction.x < 0 && direction.y > 0):
		self.rotation_degrees = -45
	elif (direction.x > 0 && direction.y > 0) || (direction.x < 0 && direction.y < 0) :
		self.rotation_degrees = 45
	elif abs(direction.y) > 0:
		if sprite.scale == Vector2(-1,1):
			self.rotation_degrees = -90 * direction.y
		else:
			self.rotation_degrees = 90 * direction.y
	else:
		self.rotation_degrees = 0

func calculate_move_velocity(_velocity: Vector2, direction : Vector2) -> Vector2:
	if state in SPEED:
		_velocity.x = SPEED[state] * direction.x
		_velocity.y = SPEED[state] * direction.y
	return _velocity
	
func process_input():
	return {
		direction = get_direction(),
		is_running = Input.is_action_pressed("run"),
		is_dashing = Input.is_action_just_pressed("ui_accept")
	}
	
func new_state(input, velocity):
	if input.direction == Vector2():
		return States.IDLE
	elif input.is_dashing:
		return States.DASH
	elif input.is_running:
		return States.RUN
	else:
		return States.WALK
	
func get_direction() -> Vector2:
	var out: = Vector2.ZERO
	out.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	out.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")	
	return out.normalized()
	
func _on_Timer_timeout():
	if can_dash == "no": 
		can_dash = "wait"
		timer.start()
	else:
		can_dash = "ready"
