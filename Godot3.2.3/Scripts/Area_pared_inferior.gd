extends StaticBody
var area
var mesh
var new_material
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func area_added():
	area = get_child(1)
	area.connect("body_entered", self, "translucir")
	area.connect("body_exited", self, "opacar")
	
func mesh_added():
	mesh = get_child(2)
	new_material = mesh.get_surface_material(0).duplicate()
	mesh.set_surface_material(0, new_material)
	
func translucir(body):
	if body.get_script() == load("res://Scripts/Player.gd"):
		get_child(2).get_surface_material(0).set("flags_transparent", true)
		get_child(2).get_surface_material(0).set("albedo_color", Color(0,0,.2,.8))
	
func opacar(body):
	if body.get_script() == load("res://Scripts/Player.gd"):
		get_child(2).get_surface_material(0).set("albedo_color", Color(0,0,.2,1))
		get_child(2).get_surface_material(0).set("flags_transparent", false)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
