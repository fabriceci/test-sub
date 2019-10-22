tool
extends Area2D

export(String, "small", "normal", "big") var size = "small"
onready var sprite_small := $"mine-small"

onready var sprite_normal := $"mine"
onready var sprite_big := $"mine-big"
onready var coll_shape := $CollisionShape2D

func _ready():
	var is_editor = Engine.is_editor_hint()
	_setup()

func _setup():
	var shape = CircleShape2D.new()
	match size:
		"small":
			sprite_small.visible = true
			shape.radius = 11.5
			coll_shape.shape = shape
		"big":
			sprite_big.visible = true
			shape.radius = 25
			coll_shape.shape = shape
		_:
			sprite_normal.visible = true
			shape.radius = 16.0
			coll_shape.shape = shape