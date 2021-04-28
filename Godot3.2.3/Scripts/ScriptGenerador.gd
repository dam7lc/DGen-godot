extends Spatial

const cuantos = 3
var room_center = Vector2(0,0)
var room_x
var prev_room_x = 0
var room_z
var prev_room_z = 0
const room_y = 1.5
var player
var pared_material
var piso_material
var ancho_pared: float = .1

#Llamado cuando se inicializa el objeto
func _ready():
	
	for child in get_parent().get_children(): #Obtener referencia al player para ignorar colision de la camara con paredes
		if child.get_script() == load("res://Scripts/Player.gd"):
			player = child
	
	pared_material = load("res://Materials/paredes_material.tres")
	piso_material = load("res://Materials/piso_material.tres")
	
	for j in range(cuantos): #For para cada habitacion
		
		#Randomizar tamaño habitacion
		randomize()
		room_x = rand_range(8,15)
		randomize()
		room_z = rand_range(8,15)
		
		if j != 0:
			room_center.x = room_center.x + (room_x) 	
			#room_center.y = room_center.x + (room_z/2)
		
		
		var paredes = Array()
		
		#Se crean los tipos de objeto para 4 paredes y 1 piso
		for i in range(5): #for para cada pared y piso
			
			paredes.append(StaticBody.new())
			var pared_colision = CollisionShape.new()
			var colshape = BoxShape.new()
			colshape.set_extents(Vector3(1,1,1))
			pared_colision.set_shape(colshape)
			paredes[i].add_child(pared_colision)
			
			if i == 3: #Si es la pared de abajo generar una colision en area adicional
				var area_col = Area.new()
				var paredes_colisiones2 = CollisionShape.new()
				var colshape2 = BoxShape.new()
				colshape2.set_extents(Vector3(1,1,1))
				paredes_colisiones2.set_shape(colshape2)
				area_col.add_child(paredes_colisiones2)
				paredes[i].add_child(area_col)
				paredes[i].set_script(load("res://Scripts/Area_pared_inferior.gd"))
				paredes[i].area_added()
					
			
			var pared_mesh = MeshInstance.new()
			pared_mesh.set_mesh(load("res://Imports/Unit.obj"))
			pared_mesh.set_surface_material(0, pared_material)
			paredes[i].add_child(pared_mesh)	
			if paredes[i].get_script() == load("res://Scripts/Area_pared_inferior.gd"):
				paredes[i].mesh_added()
			add_child(paredes[i])
			
		#Termina For
		#Si la habitacion es mas pequeña generar paredes adicionales
		
		if room_z < prev_room_z : 
			var dif = prev_room_z - room_z
			var paredrelleno1 = StaticBody.new()
			var pared_colision = CollisionShape.new()
			var pared_mesh = MeshInstance.new()
			var colshape = BoxShape.new()
			pared_mesh.set_mesh(load("res://Imports/Unit.obj"))
			pared_mesh.set_surface_material(0, pared_material)
			paredrelleno1.add_child(pared_mesh)
			colshape.set_extents(Vector3(1,1,1))
			pared_colision.set_shape(colshape)
			paredrelleno1.add_child(pared_colision)
			paredes.append(paredrelleno1)
			paredrelleno1.set_scale(Vector3(ancho_pared,room_y,dif/2))
			paredrelleno1.global_translate(Vector3((-room_x)+room_center.x,room_y,(room_center.y+room_z+dif/2)))
			add_child(paredrelleno1)
			
			
			var paredrelleno2 = StaticBody.new()
			var pared_colision2 = CollisionShape.new()
			var pared_mesh2 = MeshInstance.new()
			var colshape2 = BoxShape.new()
			pared_mesh2.set_mesh(load("res://Imports/Unit.obj"))
			pared_mesh2.set_surface_material(0, pared_material)
			paredrelleno2.add_child(pared_mesh2)
			colshape2.set_extents(Vector3(1,1,1))
			pared_colision2.set_shape(colshape2)
			paredrelleno2.add_child(pared_colision2)
			paredes.append(paredrelleno2)
			paredrelleno2.set_scale(Vector3(ancho_pared,room_y,dif/2))
			paredrelleno2.global_translate(Vector3((-room_x)+room_center.x,room_y,(room_center.y-room_z-dif/2)))
			add_child(paredrelleno2)
		
		var puerta = load("res://Escenas/puerta.tscn").instance()
		
		add_child(puerta)
		puerta.rotate_y(1.57)
		puerta.global_translate(Vector3(room_x+room_center.x,0.3,room_center.y))
		#Tamaño de pared0(pared de arriba)
		#Tamaño del mesh
		paredes[0].get_child(1).scale.x = room_x
		paredes[0].get_child(1).scale.y = room_y
		paredes[0].get_child(1).scale.z = ancho_pared
		#Tamaño de la colision
		paredes[0].get_child(0).scale.x = room_x
		paredes[0].get_child(0).scale.y = room_y
		paredes[0].get_child(0).scale.z = ancho_pared
		#Posicion pared0
		paredes[0].global_translate(Vector3(room_center.x,room_y,(-room_z)+room_center.y))
		
		#player ignore paredes
		player.agregar_pared_a_ignorar(paredes[0])
		
		if j != 0: #La primer pared debe ser completa (no entrada)
			
			#Tamaño de pared1(pared de la izquierda)
			#Tamaño del mesh
			paredes[1].get_child(1).scale.z = room_z/2-.5
			paredes[1].get_child(1).scale.y = room_y
			paredes[1].get_child(1).scale.x = ancho_pared
			#Tamaño de Collision
			paredes[1].get_child(0).scale.x = ancho_pared
			paredes[1].get_child(0).scale.z = room_z/2-.5
			paredes[1].get_child(0).scale.y = room_y
			#Posicion pared1
			paredes[1].global_translate(Vector3((-room_x)+room_center.x,room_y,(room_center.y-room_z/2)-.5))
			#player ignore paredes
			player.agregar_pared_a_ignorar(paredes[1])
			
			#Tamaño de pared2(pared de la izquierda 2)
			#Tamaño del mesh
			paredes[2].get_child(1).scale.z = room_z/2-.5
			paredes[2].get_child(1).scale.y = room_y
			paredes[2].get_child(1).scale.x = ancho_pared
			#Tamaño de Collision
			paredes[2].get_child(0).scale.z = room_z/2-.5
			paredes[2].get_child(0).scale.y = room_y
			paredes[2].get_child(0).scale.x = ancho_pared
			#Posicion pared2
			paredes[2].global_translate(Vector3((-room_x)+room_center.x,room_y,(room_center.y+room_z/2)+.5))
			#player ignore paredes
			player.agregar_pared_a_ignorar(paredes[2])
			
		else:
			paredes[1].get_child(1).scale.z = room_z
			paredes[1].get_child(1).scale.y = room_y
			paredes[1].get_child(1).scale.x = ancho_pared
			
			paredes[1].get_child(0).scale.z = room_z
			paredes[1].get_child(0).scale.x = ancho_pared
			paredes[1].get_child(0).scale.y = room_y
			
			paredes[1].global_translate(Vector3((-room_x)+room_center.x,room_y,room_center.y))
			#player ignore paredes
			player.agregar_pared_a_ignorar(paredes[1])
			
			paredes[2].get_child(1).scale.z = 0
			paredes[2].get_child(1).scale.y = 0
			
			paredes[2].get_child(0).scale.z = 0
			paredes[2].get_child(0).scale.x = 0
			paredes[2].get_child(0).scale.y = 0
			
			paredes[2].global_translate(Vector3((-room_x)+room_center.x,room_y,room_center.y+room_z/3))
			#player ignore paredes
			player.agregar_pared_a_ignorar(paredes[2])
		
		#Tamaño de pared3(pared de abajo)
		paredes[3].get_child(2).scale.x = room_x
		paredes[3].get_child(2).scale.y = room_y
		paredes[3].get_child(2).scale.z = ancho_pared
		#Tamaño de colision
		paredes[3].get_child(0).scale.x = room_x
		paredes[3].get_child(0).scale.y = room_y
		paredes[3].get_child(0).scale.z = ancho_pared
		
		paredes[3].get_child(1).scale.x = room_x
		paredes[3].get_child(1).scale.y = .5
		paredes[3].get_child(1).scale.z = 1
		paredes[3].get_child(1).translate_object_local(Vector3(0.0,-2,-1))
		#Posicion pared 3
		paredes[3].global_translate(Vector3(room_center.x,room_y,(room_z)+room_center.y))
		player.agregar_pared_a_ignorar(paredes[3])
		
		
		#Tamaño del piso
		paredes[4].get_child(1).scale.x = room_x
		paredes[4].get_child(1).scale.y = .2
		paredes[4].get_child(1).scale.z = room_z 
		paredes[4].get_child(1).set_surface_material(0, piso_material)
		#Tamaño de Colision
		paredes[4].get_child(0).scale.x = room_x
		paredes[4].get_child(0).scale.y = .2
		paredes[4].get_child(0).scale.z = room_z
		#Posicion piso
		paredes[4].global_translate(Vector3(room_center.x,0,room_center.y))
		
		room_center.x = room_center.x + room_x
		prev_room_x = room_x 
		prev_room_z = room_z
		
		
		
	player.generacion_finalizada()
		
	

