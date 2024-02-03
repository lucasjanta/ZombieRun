extends RigidBody2D
# Called when the node enters the scene tree for the first time.
var distancia : float
var zombie_speed : float
func _ready():
	#zombie_speed = randf_range(1,distancia/100)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += zombie_speed
	pass
