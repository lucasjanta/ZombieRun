extends Area2D

var imagens = [preload("res://Sprites/Keys/W.png"), 
			   preload("res://Sprites/Keys/S.png"), 
			   preload("res://Sprites/Keys/A.png"), 
			   preload("res://Sprites/Keys/D.png")] 


func random_key(objeto : Sprite2D) -> void:
	if imagens.size() == 0:
		return
	# Gera um índice aleatório dentro do intervalo do array
	var indice_aleatorio = randi() % imagens.size()
	# Atribui a imagem selecionada ao objeto
	objeto.texture = imagens[indice_aleatorio]
	objeto.name = str(indice_aleatorio)

# Called when the node enters the scene tree for the first time.
func _ready():
	random_key($SpriteKey)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

