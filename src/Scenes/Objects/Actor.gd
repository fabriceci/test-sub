extends KinematicBody2D
class_name Actor

const FLOOR_NORMAL: = Vector2.DOWN
var state = 0

export var speed: = Vector2(20.0, 0)
export var gravity: = 3500.0
var _velocity: = Vector2.ZERO
var _transitions = {}

func _physics_process(delta: float) -> void:
	_velocity.y += gravity * delta
	
func change_state(event):
	if event == state: # nothing changed
		return
	var transition = [state, event]
	if not transition in _transitions:
		return
	
	state = _transitions[transition]
	enter_state()
	
	emit_signal("state_changed", state)

func enter_state():
	pass
