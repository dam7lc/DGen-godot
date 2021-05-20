extends Spatial

var valida = true
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func es_valida():
	return valida
	
func area_added():
	var area: Area = get_node("habitacion_area")
	area.connect("area_entered", self, "overlap")
	
func overlap(area):
	if(area.get_parent().get_script() == load("res://Scripts/Habitacion.gd")):
		valida = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
