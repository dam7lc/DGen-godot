extends KinematicBody

var rot_x = 0
var rot_y = 0
var camera
var springArm
var isTP = false
var isFP = false
var prevtime = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
		camera = $SpringArm/Camera
		springArm = $SpringArm
		springArm.add_excluded_object(.get_rid())
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if event is InputEventMouseMotion:
		if isTP:
			rot_x += event.relative.x * .01
			rot_y += 0.0
			
			if event.relative.y < 0 and springArm.rotation_degrees.x < 0: #Se movio arriba
				
				rot_y += event.relative.y * .01
				 # first rotate in Y
				
			if event.relative.y > 0 and springArm.rotation_degrees.x > -40:
				
				rot_y += event.relative.y * .01 
			
			springArm.transform.basis = Basis() 
			springArm.rotate_x(-rot_y)
			springArm.rotate_y(-rot_x)
			
		if isFP:
			rot_x += event.relative.x * .01
			rot_y += 0.0
			
			if event.relative.y < 0 and rotation_degrees.x < 80: #Se movio arriba
				
				rot_y += event.relative.y * .01
				 # first rotate in Y
				
			if event.relative.y > 0 and rotation_degrees.x > -20:
				
				rot_y += event.relative.y * .01 
			
			transform.basis = Basis() 
			rotate_x(-rot_y)
			rotate_y(-rot_x)
		
	if Input.is_action_pressed("change_camera"):
		var time = OS.get_ticks_msec()
		if time > (prevtime + 500):
			
			if !isTP and !isFP:
				isTP = true
				springArm.set_length(3.0)
				springArm.set_translation(Vector3(0,1.5,1))
				camera.set_translation(Vector3(1.2,0,0))
			elif isTP:
				isTP = false
				isFP = true
				springArm.set_length(0)
				springArm.set_translation(Vector3(0,1.5,0))
				springArm.set_rotation_degrees(Vector3(0,0,0))
			elif isFP:
				isTP = false
				isFP = false
				springArm.set_length(20)
				springArm.set_translation(Vector3(0,0,0))
				springArm.set_rotation_degrees(Vector3(-30,0,0))
				camera.set_rotation_degrees(Vector3(0,0,0))
			prevtime = time
		
	
