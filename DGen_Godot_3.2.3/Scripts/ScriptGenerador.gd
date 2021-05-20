extends Spatial

const cuantos: int = 30
var room_center_x: float = 0
var room_center_z: float = 0
var room_x: float
var prev_room_x: float = 0
var room_z: float
var prev_room_z: float = 0
const room_y: float = 1.5
var player: KinematicBody
var pared_material
var piso_material
var ancho_pared: float = .1
var prev_habitacion: Spatial
var lado:int
var prev_lado: int
#Llamado cuando se inicializa el objeto
func _ready():
	#Obtener referencia al player para ignorar colision de la camara con paredes
	player = get_parent().get_node("Player")
	pared_material = load("res://Materials/paredes_material.tres")
	piso_material = load("res://Materials/piso_material.tres")
	
	for j in range(cuantos): #For para cada habitacion
		
		#Decidir en que lado aparecerá la siguiente habitación
		var encontrar_lado: bool = true
		var habitacion: Spatial
		var prev_room_center_x = room_center_x
		var prev_room_center_z = room_center_z
		
		while(encontrar_lado):
		
			#Randomizar tamaño habitacion
			randomize()
			room_x = rand_range(8,15)
			randomize()
			room_z = rand_range(8,15)
			#Sumar el tamaño de habitacion en las habitaciones posteriores a la primera
			
			habitacion = crear_habitacion_de_cuatro_paredes()
			
			if j != 0:
				if j%2 == 0:
					var randomizar: bool = true
					while(randomizar):
						randomize()
						lado = randi() % 4 
						if(prev_lado == 0 && lado == 1):
							randomizar = true
						elif prev_lado == 1 && lado == 0:
							randomizar = true
						elif prev_lado == 2 && lado == 3:
							randomizar = true
						elif prev_lado == 3 && lado == 2:
							randomizar = true
						else:
							randomizar = false
							
				if lado == 0: #Izquierda
					room_center_x = room_center_x - room_x - prev_room_x
				elif lado == 1: #Derecha
					room_center_x = room_center_x + room_x + prev_room_x
				elif lado == 2: #Arriba
					room_center_z = room_center_z - room_z - prev_room_z
				elif lado == 3: #Abajo
					room_center_z = room_center_z + room_z + prev_room_z
					
				
					
			prev_lado = lado	
			dar_escala_y_posicion_a_paredes(habitacion)
			yield(get_tree(),"physics_frame")
			yield(get_tree(),"physics_frame")
			print(habitacion.es_valida())
			if(habitacion.es_valida()):
				encontrar_lado = false
			else:
				habitacion.queue_free()
				room_center_x = prev_room_center_x
				room_center_z = prev_room_center_z
		
		
		#Si el que estamos creando es mayor, cambiar escala de su pared y borrar la pared del anterior
		#Si el que estamos creando es menor, borrar su pared y cambiar escala del anterior
		if j != 0:
			if lado == 0: #Izquierda
				if room_z > prev_room_z:
					prev_habitacion.get_node("pared_izquierda").queue_free()
					habitacion.get_node("pared_derecha").set_scale(Vector3(ancho_pared, room_y, (room_z/2)-.5))
					habitacion.get_node("pared_derecha").global_translate(Vector3(0,0,(room_z/2)+.5))
					var pared2 = crear_pared_y_meter_a_escena(habitacion)
					pared2.set_name("pared_derecha2")
					pared2.set_scale(Vector3(ancho_pared, room_y, (room_z/2)-.5))
					pared2.global_translate(Vector3(room_x,room_y,-(room_z/2)-.5))
					player.agregar_pared_a_ignorar(pared2)
					
					var puerta = load("res://Escenas/puerta.tscn").instance()
					habitacion.add_child(puerta)
					puerta.rotate_y(1.57)
					puerta.set_translation(Vector3(room_x,0.3,0))
					puerta.set_name("puerta")
					
				else:
					habitacion.get_node("pared_derecha").queue_free()
					prev_habitacion.get_node("pared_izquierda").set_scale(Vector3(ancho_pared, room_y, (prev_room_z/2)-.5))
					prev_habitacion.get_node("pared_izquierda").global_translate(Vector3(0,0,(prev_room_z/2)+.5))
					var pared2 = crear_pared_y_meter_a_escena(prev_habitacion)
					pared2.set_name("pared_izquierda2")
					pared2.set_scale(Vector3(ancho_pared, room_y, (prev_room_z/2)-.5))
					pared2.global_translate(Vector3(-prev_room_x,room_y,-(prev_room_z/2)-.5))
					player.agregar_pared_a_ignorar(pared2)
					
					var puerta = load("res://Escenas/puerta.tscn").instance()
					habitacion.add_child(puerta)
					puerta.rotate_y(1.57)
					puerta.set_translation(Vector3(room_x,0.3,0))
					puerta.set_name("puerta")
					
				prev_room_x = room_x
				prev_room_z = room_z
			elif lado == 1: #Derecha
				if room_z > prev_room_z:
					prev_habitacion.get_node("pared_derecha").queue_free()
					habitacion.get_node("pared_izquierda").set_scale(Vector3(ancho_pared, room_y, (room_z/2)-.5))
					habitacion.get_node("pared_izquierda").global_translate(Vector3(0,0,(room_z/2)+.5))
					var pared2 = crear_pared_y_meter_a_escena(habitacion)
					pared2.set_name("pared_izquierda2")
					pared2.set_scale(Vector3(ancho_pared, room_y, (room_z/2)-.5))
					pared2.global_translate(Vector3(-room_x,room_y,-(room_z/2)-.5))
					player.agregar_pared_a_ignorar(pared2)
					
					var puerta = load("res://Escenas/puerta.tscn").instance()
					habitacion.add_child(puerta)
					puerta.rotate_y(1.57)
					puerta.set_translation(Vector3(-room_x,0.3,0))
					puerta.set_name("puerta")
					
				else:
					habitacion.get_node("pared_izquierda").queue_free()
					prev_habitacion.get_node("pared_derecha").set_scale(Vector3(ancho_pared, room_y, (prev_room_z/2)-.5))
					prev_habitacion.get_node("pared_derecha").global_translate(Vector3(0,0,(prev_room_z/2)+.5))
					var pared2 = crear_pared_y_meter_a_escena(prev_habitacion)
					pared2.set_name("pared_derecha2")
					pared2.set_scale(Vector3(ancho_pared, room_y, (prev_room_z/2)-.5))
					pared2.global_translate(Vector3(prev_room_x,room_y,-(prev_room_z/2)-.5))
					player.agregar_pared_a_ignorar(pared2)
					
					var puerta = load("res://Escenas/puerta.tscn").instance()
					habitacion.add_child(puerta)
					puerta.rotate_y(1.57)
					puerta.set_translation(Vector3(-room_x,0.3,0))
					puerta.set_name("puerta")
					
				prev_room_x = room_x
				prev_room_z = room_z
			elif lado == 2: #Arriba
				if room_x > prev_room_x:
					prev_habitacion.get_node("pared_superior").queue_free()
					habitacion.get_node("pared_inferior").set_scale(Vector3((room_x/2)-.5, room_y, ancho_pared))
					habitacion.get_node("pared_inferior").global_translate(Vector3((room_x/2)+.5,0,0))
					var pared2 = crear_pared_y_meter_a_escena(habitacion)
					pared2.set_name("pared_inferior2")
					pared2.set_scale(Vector3((room_x/2)-.5, room_y, ancho_pared))
					pared2.global_translate(Vector3(-(room_x/2)-.5,room_y,room_z))
					agregar_area_pared_inferior(pared2)
					player.agregar_pared_a_ignorar(pared2)
					
					var puerta = load("res://Escenas/puerta.tscn").instance()
					habitacion.add_child(puerta)
					puerta.set_translation(Vector3(0,0.3,room_z))
					puerta.set_name("puerta")
					
				else:
					habitacion.get_node("pared_inferior").queue_free()
					prev_habitacion.get_node("pared_superior").set_scale(Vector3((prev_room_x/2)-.5, room_y, ancho_pared))
					prev_habitacion.get_node("pared_superior").global_translate(Vector3((prev_room_x/2)+.5,0,0))
					agregar_area_pared_inferior(prev_habitacion.get_node("pared_superior"))
					
					var pared2 = crear_pared_y_meter_a_escena(prev_habitacion)
					pared2.set_name("pared_superior2")
					pared2.set_scale(Vector3((prev_room_x/2)-.5, room_y, ancho_pared))
					pared2.global_translate(Vector3(-(prev_room_x/2)-.5,room_y,-prev_room_z))
					agregar_area_pared_inferior(pared2)
					player.agregar_pared_a_ignorar(pared2)
					
					var puerta = load("res://Escenas/puerta.tscn").instance()
					habitacion.add_child(puerta)
					puerta.set_translation(Vector3(0,0.3,room_z))
					puerta.set_name("puerta")
					
				prev_room_x = room_x
				prev_room_z = room_z
			elif lado == 3: #Abajo
				if room_x > prev_room_x:
					prev_habitacion.get_node("pared_inferior").queue_free()
					habitacion.get_node("pared_superior").set_scale(Vector3((room_x/2)-.5, room_y, ancho_pared))
					habitacion.get_node("pared_superior").global_translate(Vector3((room_x/2)+.5,0,0))
					agregar_area_pared_inferior(habitacion.get_node("pared_superior"))
					var pared2 = crear_pared_y_meter_a_escena(habitacion)
					pared2.set_name("pared_superior2")
					pared2.set_scale(Vector3((room_x/2)-.5, room_y, ancho_pared))
					pared2.global_translate(Vector3(-(room_x/2)-.5,room_y,-room_z))
					agregar_area_pared_inferior(pared2)
					player.agregar_pared_a_ignorar(pared2)
					
					var puerta = load("res://Escenas/puerta.tscn").instance()
					habitacion.add_child(puerta)
					puerta.set_translation(Vector3(0,0.3,-room_z))
					puerta.set_name("puerta")
					
				else:
					habitacion.get_node("pared_superior").queue_free()
					prev_habitacion.get_node("pared_inferior").set_scale(Vector3((prev_room_x/2)-.5, room_y, ancho_pared))
					prev_habitacion.get_node("pared_inferior").global_translate(Vector3((prev_room_x/2)+.5,0,0))
					var pared2 = crear_pared_y_meter_a_escena(prev_habitacion)
					pared2.set_name("pared_inferior2")
					pared2.set_scale(Vector3((prev_room_x/2)-.5, room_y, ancho_pared))
					pared2.global_translate(Vector3(-(prev_room_x/2)-.5,room_y,prev_room_z))
					agregar_area_pared_inferior(pared2)
					player.agregar_pared_a_ignorar(pared2)
					
					var puerta = load("res://Escenas/puerta.tscn").instance()
					habitacion.add_child(puerta)
					puerta.set_translation(Vector3(0,0.3,-room_z))
					puerta.set_name("puerta")
					
				prev_room_x = room_x
				prev_room_z = room_z
		else:
			prev_room_x = room_x
			prev_room_z = room_z
		
		prev_habitacion = habitacion
	
	player.generacion_finalizada()
	for habitaciones in get_children():
		habitaciones.get_node("habitacion_area").set_monitoring(false)


func crear_pared_y_meter_a_escena(habitacion: Spatial):
	#Se crea la raiz, la colision y el mesh
	var pared_raiz = StaticBody.new()
	var pared_mesh = MeshInstance.new()
	var pared_colision = CollisionShape.new()
	var colision_colshape = BoxShape.new()
	#Se añaden el mesh y colision como hijos de la raiz
	pared_raiz.add_child(pared_mesh)
	pared_raiz.add_child(pared_colision)
	#Se asigna un colision shape a la colision
	colision_colshape.set_extents(Vector3(1,1,1))
	pared_colision.set_shape(colision_colshape)
	#Se asigna un mesh y material
	pared_mesh.set_mesh(load("res://Imports/Unit.obj"))
	pared_mesh.set_surface_material(0, pared_material)
	#Se añade a escena esta pared creada
	habitacion.add_child(pared_raiz)
	#Se devuelve para asignarle un tamaño y posicion en escena
	return pared_raiz

func agregar_area_pared_inferior(pared_inferior: StaticBody):
	var area = Area.new()
	var colision_area = CollisionShape.new()
	var colshape_colision_area = BoxShape.new()
	area.add_child(colision_area)
	colshape_colision_area.set_extents(Vector3(1,1,1))
	colision_area.set_shape(colshape_colision_area)
	area.scale.z = 10
	area.translate_object_local(Vector3(0,0,-1))
	pared_inferior.add_child(area)
	pared_inferior.set_script(load("res://Scripts/Area_pared_inferior.gd"))
	pared_inferior.area_added()

func crear_habitacion_de_cuatro_paredes():
	var habitacion: Spatial = Spatial.new()
	add_child(habitacion)
	habitacion.set_script(load("res://Scripts/Habitacion.gd"))
	habitacion.set_name("habitacion")
	
	var area: Area = Area.new()
	var area_col = CollisionShape.new()
	area.add_child(area_col)
	area_col.set_shape(BoxShape.new())
	habitacion.add_child(area)
	area.set_name("habitacion_area")
	area.global_translate(Vector3(0,1.5,0))
	habitacion.area_added()
	
	#Se crean 3 paredes y un piso y se añaden a escena
	#Pared DE ARRIBA
	var pared_superior: StaticBody = crear_pared_y_meter_a_escena(habitacion)
	pared_superior.set_name("pared_superior")
	#Colision de camara ignore la pared superior
	player.agregar_pared_a_ignorar(pared_superior)
	
	#PARED DE LA IZQUIERDA
	var pared_izquierda: StaticBody = crear_pared_y_meter_a_escena(habitacion)
	pared_izquierda.set_name("pared_izquierda")
	#Colision de camara ignore la pared de la izquierda
	player.agregar_pared_a_ignorar(pared_izquierda)
	
	var pared_inferior: StaticBody = crear_pared_y_meter_a_escena(habitacion)
	pared_inferior.set_name("pared_inferior")	
	#Colision de camara ignore la pared de abajo
	player.agregar_pared_a_ignorar(pared_inferior)

	var piso: StaticBody = crear_pared_y_meter_a_escena(habitacion)
	piso.set_name("piso")
	#Tamaño del piso
	piso.get_child(0).set_surface_material(0, piso_material)

	
	var pared_derecha: StaticBody = crear_pared_y_meter_a_escena(habitacion)
	pared_derecha.set_name("pared_derecha")
	#Colision de camara ignore la pared de la derecha
	player.agregar_pared_a_ignorar(pared_derecha)
	
	return habitacion

func dar_escala_y_posicion_a_paredes(habitacion):
	habitacion.global_translate(Vector3(room_center_x,0,room_center_z))
	
	habitacion.get_node("habitacion_area").set_scale(Vector3(room_x-1,2,room_z-1))
	
	#Tamaño de la pared de arriba
	habitacion.get_node("pared_superior").set_scale(Vector3(room_x,room_y,ancho_pared))
	#Posicion de la pared de arriba
	habitacion.get_node("pared_superior").set_translation(Vector3(0,room_y,-room_z))
	
	#Tamaño de la pared de la izquierda
	habitacion.get_node("pared_izquierda").set_scale(Vector3(ancho_pared,room_y,room_z))
	#Posicion de la pared de la izquierda
	habitacion.get_node("pared_izquierda").set_translation(Vector3(-room_x,room_y,0))
	
	agregar_area_pared_inferior(habitacion.get_node("pared_inferior"))
	#Tamaño de la pared de abajo
	habitacion.get_node("pared_inferior").set_scale(Vector3(room_x,room_y,ancho_pared))
	#Posicion pared de abajo
	habitacion.get_node("pared_inferior").set_translation(Vector3(0,room_y,room_z))
	
	habitacion.get_node("piso").set_scale(Vector3(room_x,ancho_pared,room_z))
	#Posicion del piso
	habitacion.get_node("piso").set_translation(Vector3(0,ancho_pared,0))
	#Asignar material al piso
	
	#Tamaño pared de la derecha
	habitacion.get_node("pared_derecha").set_scale(Vector3(ancho_pared, room_y, room_z))
	#Posicion de la pared de la derecha
	habitacion.get_node("pared_derecha").set_translation(Vector3(room_x,room_y,0))
