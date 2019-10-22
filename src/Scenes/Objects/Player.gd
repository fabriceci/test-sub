extends KinematicBody2D

var speed = 20;
onready var animationPlayer := $AnimationPlayer
onready var sprite := $SpriteContainer
onready var timer := $Timer
var can_dash := "ready"

func _ready():
	pass # Replace with function body.
	
func _physics_process(delta: float) -> void:
	var direction := Vector2(	Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
							Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")	
							)
	if direction.length() > 1:
		direction.normalized()
		
	var absX := abs(direction.x)
	var absY := abs(direction.y)

	if can_dash == "no" : 
		animationPlayer.play("Rush")
	elif absX > 0:
			animationPlayer.play("Swim")
	elif absY > 0:
		animationPlayer.play("Swim")
	else:
		animationPlayer.play("Idle")
		
	if direction.x < 0:
		sprite.scale = Vector2(-1,1)
	elif direction.x > 0:
		sprite.scale = Vector2.ONE
		
	if (direction.x > 0 && direction.y < 0) || (direction.x < 0 && direction.y > 0):
		self.rotation_degrees = -45
	elif (direction.x > 0 && direction.y > 0) || (direction.x < 0 && direction.y < 0) :
		self.rotation_degrees = 45
	elif absY > 0:
		if sprite.scale == Vector2(-1,1):
			self.rotation_degrees = -90 * direction.y
		else:
			self.rotation_degrees = 90 * direction.y
	else:
		self.rotation_degrees = 0
	
	var _speed = 100 if can_dash == "no" else speed
	var velocity = Vector2(_speed * direction.x, _speed * direction.y)
	
	if Input.is_action_pressed("ui_accept") && can_dash == "ready":
		can_dash = "no"
		timer.start()
		

	velocity = move_and_slide(velocity, Vector2.DOWN)

func _on_Timer_timeout():
	if can_dash == "no": 
		can_dash = "wait"
		timer.start()
	else:
		can_dash = "ready"
