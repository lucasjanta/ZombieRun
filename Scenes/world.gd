extends Node2D

@onready var sprite_2d = $Player/Sprite2D
@onready var camera = $Camera2D
@onready var tilemap = $TileMap
@onready var hud = $HUD

var newZombie = preload("res://Scenes/enemy_1.tscn")
var zombie_instance = null
var zombies_in_screen = []
var closest_zombie
var zombie_velocity

var powerShot = preload("res://Scenes/power_anim.tscn")
var power_instance = null
var power_in_screen = []

const PLAYER_START_POS := Vector2i(832, 376)
const CAM_START_POS := Vector2i(832, 324)

var speed : float
const INITIAL_SPEED : float = 0
var score : int
var combo : int = 0
var max_speed : float = 5
var high_score : int

var screen_size : Vector2i
var game_running : bool
var anim_exec = false

var player = null
var distance_enemy_player

var shoot_bar = preload("res://Scenes/shoot_bar.tscn")
var shoot_bar_instance = null
var mira : float =  0.0
var mira_mult = 1

var too_far = preload("res://Scenes/too_far.tscn")
var too_far_instance = null

var new_tileMap = preload("res://Scenes/tile_map.tscn")
var new_tileMap_instance = null
var tile_number : int
var tilemaps_added = []

var new_point = preload("res://Scenes/pontuation.tscn")
var new_point_instance = null
var all_points = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("Player")
	$HUD/Keys_Colision.connect("acerto", acertou) #sinal do acerto
	$HUD/Keys_Colision.connect("erro", errou) #sinal do erro
	screen_size = get_window().size
	speed = INITIAL_SPEED
	$GameOver.get_node("Button").pressed.connect(new_game)
	#foreground_handle()
	new_game()

func new_game():
	speed = 0
	score = 0
	combo = 0
	tile_number = 1
	show_score()
	game_running = false
	get_tree().paused = false
	
	for zombies in zombies_in_screen:
		zombies.queue_free()
	zombies_in_screen.clear()
	if power_in_screen != null:
		for powers in power_in_screen:
			powers.queue_free()
		power_in_screen.clear()
	if all_points != null:
		for point in all_points:
			point.queue_free()
		all_points.clear()
	if tilemaps_added != null:
		for tilemapzinhos in tilemaps_added:
			tilemapzinhos.queue_free()
		tilemaps_added.clear()
		
	$Player.position = PLAYER_START_POS
	$Player.velocity = Vector2i(0, 0)
	camera.position = CAM_START_POS 
	$HUD.get_node("EnterToPlayLabel").show()
	$GameOver.hide()

#EVERY FRAME 💚
func _process(_delta):
	if game_running:
		score += speed / 2
		show_score()
		player.position.x += speed
		#$Camera2D.position.x = find_distance(zombies_in_screen).distancia
		camera_control(find_distance(zombies_in_screen)) #camera movement
		hit_zombie(find_distance(zombies_in_screen)) #Die
		speed_control(find_distance(zombies_in_screen).distancia)
		more_floor(player.position.x)
		if player.position.x > PLAYER_START_POS.x:
			if Input.is_action_pressed("space"):
				if find_distance(zombies_in_screen).distancia < 900:
					if too_far_instance != null:
						too_far_instance.queue_free()
					shoot_bar_instance.cursor_movement(player_shooting())
					shoot_bar_instance.position = Vector2i(player.position.x - 100, player.position.y - 100)
					sprite_2d.animation = "spell"
					sprite_2d.play("spell")
					#if sprite_2d.
					
				else:
					print("muito distante")
					if too_far_instance == null:
						too_far_instance = too_far.instantiate()
						add_child(too_far_instance)
				if too_far_instance != null:
					too_far_instance.position = Vector2i(player.position.x - 50, player.position.y - 150)
			release_space(find_distance(zombies_in_screen).distancia)
			
	else: 
		if Input.is_action_just_pressed("enter"):
			game_running = true
			create_zombie(Vector2i(player.position.x-800,player.position.y), 3)
			$HUD.get_node("EnterToPlayLabel").hide()



func show_score():
	$HUD.get_node("ScoreLabel").text = "SCORE: " + str(score)
	$HUD.get_node("ComboLabel").text = "COMBO: " + str(combo)

func check_high_score():
	if score > high_score:
		high_score = score
	$HUD.get_node("HighScoreLabel").text = "HIGH SCORE: " + str(high_score)
#func att_combo():
	
func acertou():
	if speed < max_speed:
		speed += 2
		combo += 1
		
	
func errou():
	if speed > 3:
		speed -= 1.0
	combo = 0

func create_zombie(start_position, start_velocity):
	zombie_instance = newZombie.instantiate()
	zombie_instance.zombie_speed = start_velocity
	zombie_instance.position = start_position
	zombie_instance.body_entered.connect(hit_zombie)
	add_child(zombie_instance)
	zombies_in_screen.append(zombie_instance)
	return zombie_instance
	
func hit_zombie(body):
	if body.name == "Player":
		game_over()
	
func find_distance(array_zombies):
	for zombie_enemy in array_zombies:
		distance_enemy_player = zombie_enemy.position.distance_to(player.position)
		zombie_enemy.distancia = distance_enemy_player
	var menor_distancia = 10000
	for zombie_enemy in array_zombies:
		if zombie_enemy.distancia < menor_distancia:
			menor_distancia = zombie_enemy.distancia
			closest_zombie = zombie_enemy
	return closest_zombie

func player_shooting():
	if speed > 0.1:
		speed -= 0.005
	sprite_2d.flip_h = true
	if shoot_bar_instance == null:
		shoot_bar_instance = shoot_bar.instantiate()
		add_child(shoot_bar_instance)
		#shoot_bar_instance.position = Vector2i(player.position.x - 100, player.position.y - 100)
	if mira_mult == 1:
		mira+= mira_mult * 4
		if mira >= 150:
			mira_mult = -1
	if mira_mult == -1:
		mira+= mira_mult * 4
		if mira <= -150:
			mira_mult = 1
	return mira

func kill_zombies(choosen):
	var sprite_enemy = choosen.get_node("Sprite2D")
	choosen.zombie_speed = 0
	print(sprite_enemy)
	sprite_enemy.animation = "death"
	sprite_enemy.play("death")
	power_instance = powerShot.instantiate()
	power_instance.position = choosen.position
	add_child(power_instance)
	power_in_screen.append(power_instance)
	
	if sprite_enemy.animation == "death" and sprite_enemy.frame == 6:
		choosen.queue_free()
		zombies_in_screen.erase(choosen)
		
func check_hit():
	var opt
	if mira >= -15 and mira <= 15:
		print("morre 3")
		kill_zombies(find_distance(zombies_in_screen))
		kill_zombies(find_distance(zombies_in_screen))
		kill_zombies(find_distance(zombies_in_screen))
		player.power.play()
		opt = 3
	if mira >= -55 and mira < -15 or mira > 15 and mira <= 55:
		print("morre 2")
		kill_zombies(find_distance(zombies_in_screen))
		kill_zombies(find_distance(zombies_in_screen))
		player.power.play()
		opt = 2
	if mira >= -100 and mira < -55 or mira > 55 and mira <= 100:
		print("morre1")
		kill_zombies(find_distance(zombies_in_screen))
		player.power.play()
		opt = 1
	if mira < -100 or mira > 100:
		print("errou")
		opt = 0
		
	return opt

func camera_control(inimigo_proximo):
	if inimigo_proximo != null:
		var distance = inimigo_proximo.distancia
		var target_position_far = Vector2(700/distance, 700/distance)
		var target_position_close = Vector2(1.5, 1.5)
		if distance < 466:
			camera.position.x = player.position.x - distance/3
			camera.zoom = target_position_close
		elif distance <= 700:
			camera.position.x = player.position.x - distance/3
			camera.zoom = target_position_far
		else:
			camera.position.x = player.position.x - 233
			camera.zoom = target_position_far
	if inimigo_proximo == null:
		$Camera2D.position.x = player.position.x
		
func random_velocity():
	zombie_velocity = randf_range(1, 6)
	return zombie_velocity
	
func game_over():
	check_high_score()
	get_tree().paused = true
	game_running = false
	$GameOver.show()

func speed_control(dist):
	if speed > 0:
			speed-= 0.012
	if speed > 2 and !anim_exec:
		sprite_2d.animation = "running"
		sprite_2d.play("running")
		anim_exec = true
	if (speed <= 2):
		sprite_2d.animation = "idle"
		sprite_2d.play()
		anim_exec = false
	if speed > 0 and dist > 900:
		speed-= 0.02
	
	
func release_space(distancia):
	if Input.is_action_just_released("space"):
		if distancia < 900:
				visual_effect_hit(check_hit())
				mira = -150
				mira_mult = 1
				if shoot_bar_instance != null:
					shoot_bar_instance.queue_free()
				if too_far_instance != null:
					too_far_instance.queue_free()
				sprite_2d.flip_h = false
				#shoot_bar_instance = null
				create_zombie(Vector2i(closest_zombie.position.x - 400,player.position.y), random_velocity())
				create_zombie(Vector2i(closest_zombie.position.x-400,player.position.y), random_velocity())
				create_zombie(Vector2i(closest_zombie.position.x-400,player.position.y), random_velocity())
				anim_exec = false
				speed_control(find_distance(zombies_in_screen).distancia)
		if distancia >= 900:
			if shoot_bar_instance != null:
					shoot_bar_instance.queue_free()
			if too_far_instance != null:
				too_far_instance.queue_free()
			sprite_2d.flip_h = false
				
	
func visual_effect_hit(option):
	if option == 0:
		print("errou")
		new_point_instance = new_point.instantiate()
		new_point_instance.get_node("pontosText").text = "MISS"
		new_point_instance.position = Vector2i(player.position.x, player.position.y - 200)
		add_child(new_point_instance)
		all_points.append(new_point_instance)
		
	if option == 1:
		print("oi")
		score += 200
		new_point_instance = new_point.instantiate()
		new_point_instance.get_node("pontosText").text = "+200pts"
		new_point_instance.position = Vector2i(player.position.x, player.position.y - 200)
		add_child(new_point_instance)
		all_points.append(new_point_instance)
		
	if option == 2:
		print("oi2")
		score += 500
		new_point_instance = new_point.instantiate()
		new_point_instance.get_node("pontosText").text = "+500pts"
		new_point_instance.position = Vector2i(player.position.x, player.position.y - 200)
		add_child(new_point_instance)
		all_points.append(new_point_instance)
	if option == 3:
		print("oi3")
		score += 1000
		new_point_instance = new_point.instantiate()
		new_point_instance.get_node("pontosText").text = "+1000pts"
		new_point_instance.position = Vector2i(player.position.x, player.position.y - 200)
		add_child(new_point_instance)
		all_points.append(new_point_instance)
		
func more_floor(distanciaJogador):
	if distanciaJogador > 6000 * tile_number:
		new_tileMap_instance = new_tileMap.instantiate()
		new_tileMap_instance.position = Vector2i(6472 * tile_number, -80)
		add_child(new_tileMap_instance)
		tilemaps_added.append(new_tileMap_instance)
		tile_number += 1
		
	
func adjust_velocity(dist):
	if speed > 0 and dist > 900:
		speed-= 0.001
