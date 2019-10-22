extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var player = AudioStreamPlayer.new()
	self.add_child(player)
	player.stream = load("res://assets/sounds/track1.ogg")
	player.volume_db = -10.0
	var player2 = AudioStreamPlayer.new()
	self.add_child(player2)
	player2.stream = load("res://assets/sounds/underwater-ambiance.ogg")
	player2.volume_db = 12
	player2.play()
	player.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
