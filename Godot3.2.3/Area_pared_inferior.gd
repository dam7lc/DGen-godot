extends Area


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "translucir")
	connect("body_exited", self, "opacar")


func translucir(body):
	if body.get_script() == load("Player.gd"):
		get_parent().get_child(2).get_surface_material(0).set("flags_transparent", true)
		get_parent().get_child(2).get_surface_material(0).set("albedo_color", Color(0,0,.2,.5))
	
func opacar(body):
	if body.get_script() == load("Player.gd"):
		get_parent().get_child(2).get_surface_material(0).set("albedo_color", Color(0,0,.2,1))
		get_parent().get_child(2).get_surface_material(0).set("flags_transparent", false)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
