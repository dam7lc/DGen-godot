extends KinematicBody
var area: Area
var anim_player: AnimationPlayer
var colision: CollisionShape

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	area = get_node("Area")
	anim_player = get_node("AnimationPlayer")
	colision = get_node("CollisionShape")
	area.connect("body_entered", self, "jugador_entro")
	area.connect("body_exited", self, "jugador_sale")
	anim_player.stop(true)
	anim_player.playback_speed = 3.0
	
func jugador_entro(body):
	if body.get_script() == load("res://Scripts/Jugador.gd") && area.overlaps_body(body):
		colision.disabled = true
		if anim_player.is_playing():
			anim_player.queue("Abrir")
		else:
			anim_player.play("Abrir")
		
	
func jugador_sale(body):
	if body.get_script() == load("res://Scripts/Jugador.gd"):
		colision.disabled = false
		if anim_player.is_playing():
			anim_player.queue("Cerrar")
		else:
			anim_player.play("Cerrar")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
