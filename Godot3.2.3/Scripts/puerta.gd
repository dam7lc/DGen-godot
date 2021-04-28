extends KinematicBody
var area
var anim_player

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	area = get_node("Area")
	anim_player = get_node("AnimationPlayer")
	area.connect("body_entered", self, "jugador_entro")
	area.connect("body_exited", self, "jugador_sale")
	anim_player.stop(true)
	
func jugador_entro(body):
	if body.get_script() == load("res://Scripts/Player.gd") && area.overlaps_body(body):
		anim_player.play("Abrir")
	
func jugador_sale(body):
	if body.get_script() == load("res://Scripts/Player.gd"):
		anim_player.play("Cerrar")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
