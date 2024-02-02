extends Node2D

@onready var sprite_2d = $Player/Sprite2D

var newZombie = preload("res://Scenes/enemy_1.tscn")
var zombie_instance = null
var zombies_in_screen = []
#var zombie_speed : float = 3

const PLAYER_START_POS := Vector2i(832, 376)
const CAM_START_POS := Vector2i(832, 324)

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
var distance_enemy_player

var shoot_bar = preload("res://Scenes/shoot_bar.tscn")
var shoot_bar_instance = null
var mira : float =  0.0
var mira_mult = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("Player")
	$HUD/Keys_Colision.connect("acerto", acertou) #sinal do acerto
	$HUD/Keys_Colision.connect("erro", errou) #sinal do erro
	screen_size = get_window().size
	speed = INITIAL_SPEED
	#foreground_handle()
	new_game()

func new_game():
	score = 0
	show_score()
	game_running = false
	$Player.position = PLAYER_START_POS
	$Player.velocity = Vector2i(0, 0)
	$Camera2D.position = CAM_START_POS 
	#$TileMap.position = Vector2i(0, 0)
	create_zombie()
	$HUD.get_node("SpaceToPlayLabel").show()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if game_running:
		#enemy1Speed = NORMAL_SPEED + score/SPEED_MODIFIER
		score += speed
		show_score()
		player.position.x += speed
		#if zombie_instance != null:
			#zombie_instance.position.x += zombie_speed
		$Camera2D.position.x = player.position.x
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
		find_distance(zombies_in_screen)
		if player.position.x > PLAYER_START_POS.x:
			if Input.is_action_pressed("space"):
				shoot_bar_instance.cursor_movement(player_shooting()) 
			if Input.is_action_just_released("space"):
				print("resultado: ", mira)
				kill_zombies(find_closest_enemy_pos(zombies_in_screen))
				mira = -150
				mira_mult = 1
				shoot_bar_instance.queue_free()
				sprite_2d.flip_h = false
				#shoot_bar_instance = null
			
			
	else: 
		if Input.is_action_just_pressed("space"):
			game_running = true
			$HUD.get_node("SpaceToPlayLabel").hide()
	
			
	
func show_score():
	$HUD.get_node("ScoreLabel").text = "SCORE: " + str(score)
	
func acertou():
	if speed < max_speed:
		speed += 1.5
	print(find_closest_enemy_pos(zombies_in_screen))
	#print("TileMap Pos: ", $TileMap.global_position.x)
func errou():
	if speed > 3:
		speed -= 3.0

func create_zombie():
	zombie_instance = newZombie.instantiate()
	zombie_instance.zombie_speed = randf_range(2,8)
	zombie_instance.position = Vector2i(460,400)
	#zombie_speed = randf_range(speed, speed + 3)
	add_child(zombie_instance)
	zombies_in_screen.append(zombie_instance)
	return zombie_instance
	
func find_closest_enemy_pos(zombies):
	var closest
	for i in range(zombies.size()):
		distance_enemy_player = zombies[i].position.distance_to(player.position)
		if closest == null:
			closest = zombies[i]
		elif distance_enemy_player < closest:
			closest = zombies[i]
		else:
			return
	return closest
	
func find_distance(array_zombies):
	for zombie_enemy in array_zombies:
		distance_enemy_player = zombie_enemy.position.distance_to(player.position)
		zombie_enemy.distancia = distance_enemy_player

func player_shooting():
	speed = 0
	sprite_2d.flip_h = true
	if shoot_bar_instance == null:
		shoot_bar_instance = shoot_bar.instantiate()
		add_child(shoot_bar_instance)
		shoot_bar_instance.position = player.position - Vector2(0,100)
	
	
	if mira_mult == 1:
		mira+= mira_mult * 2.5
		if mira == 150:
			mira_mult = -1
	if mira_mult == -1:
		mira+= mira_mult * 2.5
		if mira == -150:
			mira_mult = 1
	return mira
	
func kill_zombies(closest_zombie):
	if mira >= -15 and mira <= 15:
		closest_zombie.queue_free()
	
#func new_zombies_man(player_pos):
	#
	#if player_pos = 
	#create_zombie()
