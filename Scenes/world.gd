extends Node2D

@onready var sprite_2d = $Player/Sprite2D

var newZombie = preload("res://Scenes/enemy_1.tscn")
var zombie_instance = null
var zombies_in_screen = []
var zombie_speed : float = 3

const PLAYER_START_POS := Vector2i(576, 432)
const CAM_START_POS := Vector2i(576, 324)

var speed : float
var speed_multiplier : float
const INITIAL_SPEED : float = 0
const SPEED_MODIFIER : int = 5000
var score : int
var max_speed : float = 6

var screen_size : Vector2i
var game_running : bool
var anim_exec = false

var player = null
var enemy = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("Player")
	$HUD/Keys_Colision.connect("acerto", acertou) #sinal do acerto
	$HUD/Keys_Colision.connect("erro", errou) #sinal do erro
	screen_size = get_window().size
	speed = INITIAL_SPEED
	new_game()

func new_game():
	score = 0
	show_score()
	game_running = false
	$Player.position = PLAYER_START_POS
	$Player.velocity = Vector2i(0, 0)
	$Camera2D.position = CAM_START_POS
	$TileMap.position = Vector2i(0, 0)
	create_zombie()
	$HUD.get_node("SpaceToPlayLabel").show()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if game_running:
		#enemy1Speed = NORMAL_SPEED + score/SPEED_MODIFIER
		score += speed
		show_score()
		player.position.x += speed
		zombie_instance.position.x += zombie_speed
		$Camera2D.position.x = (player.position.x + zombie_instance.position.x)/2
		if speed > 0.4:
			speed-= 0.01
		if(speed > 2 and not anim_exec):
			sprite_2d.animation = "running"
			sprite_2d.play("running")
			anim_exec = true
		elif (speed < 2 and anim_exec):
			sprite_2d.animation = "idle"
			sprite_2d.stop()
			anim_exec = false
		if $Camera2D.position.x - $TileMap.position.x > screen_size.x * 1.5:
			print("agora") #MUDAR ISSO AQUI ❤
		#if $TileMap.global_position.x - zombie_instance.global_position.x > screen_size.x * 1.5:
			#var offset = Vector2(screen_size.x, 0)
			#$TileMap.global_position += offset
	# Mova os inimigos na direção oposta ao movimento do TileMap para compensar
			
	else: 
		if Input.is_action_just_pressed("space"):
			game_running = true
			$HUD.get_node("SpaceToPlayLabel").hide()
			
	#if $Player.position.x - $Enemy1.position.x > 500:
			#$Camera2D.position.x -= 50
func show_score():
	$HUD.get_node("ScoreLabel").text = "SCORE: " + str(score)
	
func acertou():
	if speed < max_speed:
		speed += 1.5
	print("Player Pos: ", player.position.x, "Enemy Pos:", zombie_instance.position.x)
	print("TileMap Pos: ", $TileMap.global_position.x)
func errou():
	if speed > 3:
		speed -= 3.0

func create_zombie():
	zombie_instance = newZombie.instantiate()
	#zombie_instance.position = ()
	#zombie_speed = randf_range(speed, speed + 3)
	add_child(zombie_instance)
	zombies_in_screen.append(zombie_instance)
	return zombie_instance
	
