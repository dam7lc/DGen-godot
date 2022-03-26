extends CharacterBody3D


var direction: Vector3 = Vector3.FORWARD
var movement_speed: float
var acceleration: float = 10
var vertical_velocity: float = 0
var gravity: float = 20
var dash_cooldown: float = 2000
var last_dash_time = 0
var can_dash = true
var array_paredes_a_ignorar: Array
var springArm: SpringArm3D
var camera: Camera3D
var player_mesh: Node3D
var space_state: PhysicsDirectSpaceState3D
var mouse_at_x: float
var mouse_at_z: float
var new_spring_length: float = 12
var in_first_camera = false

func _ready():
	player_mesh = $Mesh
	camera = $SpringArm/Camera
	springArm = $SpringArm
	#springArm.add_excluded_object(.get_rid())
	array_paredes_a_ignorar = Array()
	
func _input(event):
	if event is InputEventMouseMotion:
		var from = Vector3()
		from = camera.project_ray_origin(event.position)
		var to = Vector3() 
		to = from + camera.project_ray_normal(event.position) * 5000 	
		
		if(space_state) and not in_first_camera:
			var ignore = Array()
			ignore.append(self)
			var params = PhysicsRayQueryParameters3D.new()
			params.from = from
			params.to = to
			params.exclude = ignore
			params.collision_mask = 0x7FFFFFFF
			params.collide_with_areas = true
			params.collide_with_bodies = true
			var result = space_state.intersect_ray(params)
			if(result):
				mouse_at_x = result.position.x
				mouse_at_z = result.position.z
				player_mesh.look_at(Vector3(result.position.x, -.9, result.position.z), Vector3(0,1,0))
				var pposition : float = player_mesh.position.y
				#print(pposition)
	if event is InputEventMouseButton:
		event as InputEventMouseButton
		if event.pressed and not in_first_camera:
			match event.button_index:
				MOUSE_BUTTON_WHEEL_UP:
					new_spring_length-=1
					if new_spring_length < 2:
						new_spring_length = 2
				MOUSE_BUTTON_WHEEL_DOWN: 
					new_spring_length+=1
					if new_spring_length > 50:
						new_spring_length = 50

	if Input.is_action_pressed("change_camera"):
		if in_first_camera:
			in_first_camera = false
			springArm.spring_length
			new_spring_length = 10
			springArm.position = Vector3(0,1,0)
			springArm.rotation = Vector3(200,0,0)
		else:
			springArm.spring_length=1
			springArm.position = Vector3(0,1,-1)
			springArm.rotation = Vector3(0,0,0)
			new_spring_length = 1
			in_first_camera = true
			
		
		
func _physics_process(delta):
	if (springArm.spring_length-new_spring_length):
		springArm.spring_length+=(new_spring_length-springArm.spring_length)*delta
	
	direction = Vector3(Input.get_action_strength("strafe_right")-Input.get_action_strength("strafe_left"),
						0,
						Input.get_action_strength("backward")-Input.get_action_strength("forward")).normalized() 
						
	if Input.is_action_pressed("forward") || Input.is_action_pressed("backward") || Input.is_action_pressed("strafe_left") || Input.is_action_pressed("strafe_right"):
		movement_speed = 8
	else:
		movement_speed = 0
	
	velocity = velocity.lerp(direction * movement_speed, delta * acceleration) + (Vector3.DOWN * vertical_velocity)
						
	
	if !is_on_floor():
		vertical_velocity += gravity * delta
	else:
		vertical_velocity = 0
	
	space_state = get_world_3d().direct_space_state
	
	if Input.is_action_just_pressed("dash"):
		
		var actual_time = Time.get_ticks_msec()
		if (actual_time-last_dash_time) > dash_cooldown:
			can_dash = true
		if can_dash:
			$AnimationTree.set("parameters/OneShot/active", true)
			last_dash_time = Time.get_ticks_msec()
			can_dash = false
	
		
	var mouse = Vector2(mouse_at_x, mouse_at_z).normalized()
	var rotation = -(Vector2(0,-1).angle_to(mouse))
	var anim_value = (Vector2(direction.x, direction.z).rotated(rotation)*Vector2(1,-1))
	move_and_slide()
	
	$AnimationTree.set("parameters/Direction/blend_position", anim_value)
	
func agregar_pared_a_ignorar(pared):
	array_paredes_a_ignorar.append(pared)

func generacion_finalizada():
	for pared in array_paredes_a_ignorar:
		springArm.add_excluded_object(pared)
