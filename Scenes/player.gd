extends CharacterBody2D


const JUMP_VELOCITY = -400.0

@onready var sprite_2d = $Sprite2D
@onready var power = $power

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	#Animations
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Show velocity
	if Input.is_action_just_pressed("space"):
		print(velocity.x)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	

	move_and_slide()
