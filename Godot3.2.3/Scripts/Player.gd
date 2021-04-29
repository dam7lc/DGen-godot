extends KinematicBody

var rot_x = 0
var rot_y = 0
var camera
var collision
var springArm
var isTP = false
var isFP = false
var prevtime = 0
var player_mesh
var space_state
var array_paredes_a_ignorar
var can_dash
var last_dash_time = 0
var mouse_at_x = 0
var mouse_at_y = 0

const GRAVITY = -24.8
var vel = Vector3()
const MAX_SPEED = 9
const ACCEL = 4.5
var dir = Vector3()

const DEACCEL= 16
const MAX_SLOPE_ANGLE = 40


func _ready():
		camera = $SpringArm/Camera
		collision = $CollisionShape
		springArm = $SpringArm
		springArm.add_excluded_object(.get_rid())
		player_mesh = $Mesh
		array_paredes_a_ignorar = Array()

func agregar_pared_a_ignorar(pared):
	array_paredes_a_ignorar.append(pared)

func _input(event): 
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		#Si estamos en tercera persona, mover la camara con mouse
		if isTP:
			rot_x += event.relative.x * .01 
			rot_y += 0.0 
			
			if event.relative.y < 0 and springArm.rotation_degrees.x < 0: #Se movio arriba
				
				rot_y += event.relative.y * .01 
				 # primero Y
				
			elif event.relative.y > 0 and springArm.rotation_degrees.x > -40:
				
				rot_y += event.relative.y * .01 
			
			springArm.transform.basis = Basis() 
			springArm.rotate_x(-rot_y)
			
			transform.basis = Basis()
			rotate_y(-rot_x)
			#springArm.rotate_y(-rot_x)
			
		elif isFP: #si estamos en primera persona, mover la camara con el mouse
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
		var from = camera.project_ray_origin(event.position)
		var to = from + camera.project_ray_normal(event.position) * 5000 	
		
		if(space_state):
			var ignore = Array()
			ignore.append(self)
			var result = space_state.intersect_ray(from, to, ignore, 0x7FFFFFFF, true, true)
			if(result):
				mouse_at_x = result.position.x
				mouse_at_y = result.position.z
				player_mesh.look_at(Vector3(result.position.x, -.8, result.position.z), Vector3(0,1,0))
			
		
		
	if Input.is_action_pressed("change_camera"):
		var time = OS.get_ticks_msec()
		if time > (prevtime + 250): #Retardo para poder cambiar de camara de nuevo
			
			if !isTP and !isFP: #si estamos en la vista desde arriba, cambiar a tercera persona
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				isTP = true
				springArm.set_length(5.0)
				springArm.set_translation(Vector3(1,1.5,-.5))
				camera.set_translation(Vector3(0,0,0))
				springArm.clear_excluded_objects()
				player_mesh.set_rotation_degrees(Vector3(0,0,0))
			elif isTP: #Si estamos en tercera persona, cambiar a primera persona
				isTP = false
				isFP = true
				springArm.set_length(0)
				springArm.set_translation(Vector3(0,1.5,-1))
				springArm.set_rotation_degrees(Vector3(0,0,0))
			elif isFP: #Si estamos en primera persona, cambiar a vista hacia arriba
				isTP = false
				isFP = false
				springArm.set_length(10)
				springArm.set_translation(Vector3(0,1,0))
				springArm.set_rotation_degrees(Vector3(-50,0,0))
				set_rotation_degrees(Vector3(0,0,0))
				camera.set_rotation_degrees(Vector3(0,0,0))
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				for pared in array_paredes_a_ignorar:
					springArm.add_excluded_object(pared)
			prevtime = time
		
func generacion_finalizada():
	for pared in array_paredes_a_ignorar:
		springArm.add_excluded_object(pared)
		
func _physics_process(delta):
	process_input(delta)
	process_movement(delta)
	space_state = get_world().direct_space_state
	
func process_input(delta):
	dir = Vector3()
	var cam_xform = collision.get_global_transform()
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
		if Input.is_action_just_pressed("dash"):
			var actual_time = OS.get_ticks_msec()
			if (actual_time-last_dash_time) > 1000:
				can_dash = true
			if can_dash:
				$AnimationTree.set("parameters/OneShot/active", true)
				vel += -cam_xform.basis.z * input_movement_vector.y * 80
				vel += cam_xform.basis.x * input_movement_vector.x * 80
				last_dash_time = OS.get_ticks_msec()
				can_dash = false
			
	
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE and (isTP or isFP):
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func process_movement(delta):
	dir.y = 0
	
	var mouse = Vector2(mouse_at_x, mouse_at_y).normalized()
	var rotation = Vector2(-1,0).angle_to_point(mouse)
	var anim_value = Vector2(dir.x, dir.z).rotated(rotation)
	
	$AnimationTree.set("parameters/Direction/blend_position", anim_value)
	print(anim_value)
	
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
	vel = move_and_slide(vel, Vector3(0, 1, 0), true, 4, deg2rad(MAX_SLOPE_ANGLE))
	
