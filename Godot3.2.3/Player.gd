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
const GRAVITY = -24.8
var vel = Vector3()
const MAX_SPEED = 20
const JUMP_SPEED = 10
const ACCEL = 4.5
var dir = Vector3()

const DEACCEL= 16
const MAX_SLOPE_ANGLE = 40

# Called when the node enters the scene tree for the first time.
func _ready():
		camera = $SpringArm/Camera
		springArm = $SpringArm
		springArm.add_excluded_object(.get_rid())
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if isTP:
			rot_x += event.relative.x * .01
			rot_y += 0.0
			
			if event.relative.y < 0 and springArm.rotation_degrees.x < 0: #Se movio arriba
				
				rot_y += event.relative.y * .01
				 # first rotate in Y
				
			elif event.relative.y > 0 and springArm.rotation_degrees.x > -40:
				
				rot_y += event.relative.y * .01 
			
			springArm.transform.basis = Basis() 
			springArm.rotate_x(-rot_y)
			transform.basis = Basis()
			rotate_y(-rot_x)
			#springArm.rotate_y(-rot_x)
			
		elif isFP:
			rot_x += event.relative.x * .01
			rot_y += 0.0
			
			if event.relative.y < 0 and rotation_degrees.x < 80: #Se movio arriba
				
				rot_y += event.relative.y * .01
				 # first rotate in Y
				
			elif event.relative.y > 0 and rotation_degrees.x > -20:
				
				rot_y += event.relative.y * .01 
			
			transform.basis = Basis() 
			rotate_x(-rot_y)
			rotate_y(-rot_x)
	elif event is InputEventMouseMotion and (!isTP and !isFP):
		var median_x = get_viewport().size.x/2
		var median_y = get_viewport().size.y/2
		var median_vector = Vector2(median_x, median_y)
		var new_vector = median_vector - event.position
		new_vector = Vector2(-new_vector.x, new_vector.y)
		#print(new_vector.angle())
		
		$Unit.transform.basis = Basis(Vector3(0, 1, 0), new_vector.angle()) 
		
#		if event.position.x > median_x:
#			print("Derecha")
#		elif event.position.x < median_x: 
#			print("Izquierda")
#		if event.position.y > median_y:
#			print("Arriba")
#		elif event.position.y < median_y:
#			print("Abajo")
		#print("normal", event.position)
		#print("global", event.global_position)
		
	if Input.is_action_pressed("change_camera"):
		var time = OS.get_ticks_msec()
		if time > (prevtime + 250):
			
			if !isTP and !isFP:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				isTP = true
				springArm.set_length(5.0)
				springArm.set_translation(Vector3(1,1.5,-.5))
				camera.set_translation(Vector3(0,0,0))
			elif isTP:
				isTP = false
				isFP = true
				springArm.set_length(0)
				springArm.set_translation(Vector3(0,1.5,0))
				springArm.set_rotation_degrees(Vector3(0,0,0))
			elif isFP:
				isTP = false
				isFP = false
				springArm.set_length(30)
				springArm.set_translation(Vector3(0,1,0))
				springArm.set_rotation_degrees(Vector3(-50,0,0))
				set_rotation_degrees(Vector3(0,0,0))
				camera.set_rotation_degrees(Vector3(0,0,0))
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			prevtime = time
		
func _physics_process(delta):
	process_input(delta)
	process_movement(delta)

func process_input(delta):
	dir = Vector3()
	var cam_xform = camera.get_global_transform()
	var input_movement_vector = Vector2()
	if Input.is_action_pressed("forward"):
		input_movement_vector.y += 1
	if Input.is_action_pressed("backward"):
		input_movement_vector.y -= 1
	if Input.is_action_pressed("strafe_left"):
		input_movement_vector.x -= 1
	if Input.is_action_pressed("strafe_right"):
		input_movement_vector.x += 1
	
	input_movement_vector = input_movement_vector.normalized()
	dir += -cam_xform.basis.z * input_movement_vector.y
	dir += cam_xform.basis.x * input_movement_vector.x
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			vel.y = JUMP_SPEED
	# ----------------------------------

	# ----------------------------------
	# Capturing/Freeing the cursor
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE and (isTP or isFP):
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func process_movement(delta):
	dir.y = 0
	dir = dir.normalized()

	vel.y += delta * GRAVITY

	var hvel = vel
	hvel.y = 0

	var target = dir
	target *= MAX_SPEED

	var accel
	if dir.dot(hvel) > 0:
		accel = ACCEL
	else:
		accel = DEACCEL

	hvel = hvel.linear_interpolate(target, accel * delta)
	vel.x = hvel.x
	vel.z = hvel.z
	vel = move_and_slide(vel, Vector3(0, 1, 0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))
	