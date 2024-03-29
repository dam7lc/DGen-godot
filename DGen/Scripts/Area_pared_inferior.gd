extends StaticBody3D
var area
var mesh
var new_material
var color
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func area_added():
	area = get_child(2)
	area.connect("body_entered", translucir)
	area.connect("body_exited", opacar)
	mesh = get_child(0)
	new_material = mesh.get_surface_override_material(0).duplicate()
	color = new_material.get("albedo_color")
	mesh.set_surface_override_material(0, new_material)
	
func translucir(body):
	if body.get_script() == load("res://Scripts/Jugador.gd"):
		get_child(0).get_surface_override_material(0).set("flags_transparent", true)
		get_child(0).get_surface_override_material(0).set("albedo_color", Color(color.r, color.g, color.b, .5))
	
func opacar(body):
	if body.get_script() == load("res://Scripts/Jugador.gd"):
		get_child(0).get_surface_override_material(0).set("albedo_color", Color(color.r, color.g, color.b, 1))
		get_child(0).get_surface_override_material(0).set("flags_transparent", false)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
