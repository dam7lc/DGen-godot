extends Area
var player
# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_parent().get_children(): #Obtener referencia al player para ignorar colision de la camara con paredes
		if child.get_script() == load("res://Player.gd"):
			player = child



func _process(delta):
	#TODO: arreglar colision auxiliar para detectar mouse
	var pos = Vector3(player.translation.x/100, 0, player.translation.z/100)
	translate(pos)
