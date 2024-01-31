extends CharacterBody2D

@onready var sprite_2d = $Sprite2D


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	self.velocity.x = 500

func _physics_process(delta):
	#Animations
	#if(velocity.x > 1 || velocity.x < -1):
		#sprite_2d.animation = "running"
	#else:
		#sprite_2d.animation = "idle"
	# Add the gravity.
	
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("space"):
		#FIX THE SHOOTING
		print("Velocidade do Player: ", velocity.x)
		return

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction = Input.get_axis("left", "right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, 25)

	move_and_slide()

	var isLeft = velocity.x < 0
	sprite_2d.flip_h = isLeft
