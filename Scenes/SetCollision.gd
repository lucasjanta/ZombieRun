extends Node

signal acerto
signal erro
var combo = 0
var newKey = preload("res://Scenes/keys.tscn")
var chaves_adicionadas = []
var addedVelocityHit = 3.0
var newKeyinOrder
# Called when the node enters the scene tree for the first time.
func _ready():
	newKeyinOrder = new_key(Vector2(580,608))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("A_key"):
		hitted_or_missed(check_keys(newKeyinOrder))
		newKeyinOrder = new_key(Vector2(580,608))
	if Input.is_action_just_pressed("W_key"):
		hitted_or_missed(check_keys(newKeyinOrder))
		newKeyinOrder = new_key(Vector2(580,608))
	if Input.is_action_just_pressed("S_key"):
		hitted_or_missed(check_keys(newKeyinOrder))
		newKeyinOrder = new_key(Vector2(580,608))
	if Input.is_action_just_pressed("D_key"):
		hitted_or_missed(check_keys(newKeyinOrder))
		newKeyinOrder = new_key(Vector2(580,608))
	pass

func new_key(pos):
	var key_instance = newKey.instantiate()
	key_instance.position = pos
	add_child(key_instance)
	chaves_adicionadas.append(key_instance)
	return key_instance

func move_keys():
	for chave in chaves_adicionadas:
		chave.position.x -= 80
	if chaves_adicionadas.size() == 6:
		for i in range(chaves_adicionadas.size()-5):
			chaves_adicionadas[i].queue_free()
		chaves_adicionadas.clear()
			

func hitted_or_missed(hitOrMiss):
	if hitOrMiss:
		print("acertou")
		combo += 1
		emit_signal("acerto")
	else:
		print("errou")
		combo = 0
		emit_signal("erro")
		
func check_keys(key):
	move_keys()
	if key is Area2D:
		if Input.is_action_just_pressed("W_key"):
			if key.has_node("0"):
				print("true")
				return true
			else:
				print("false")
				return false
		
		elif Input.is_action_just_pressed("S_key"):
			if key.has_node("1"):
				print("true")
				return true
			else:
				print("false")
				return false
		elif Input.is_action_just_pressed("A_key"):
			if key.has_node("2"):
				print("true")
				return true
			else:
				print("false")
				return false
		elif Input.is_action_just_pressed("D_key"):
			if key.has_node("3"):
				print("true")
				return true
			else:
				print("false")
				return false
