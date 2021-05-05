extends Spatial

const cuantos: int = 4
var room_center: Vector2 = Vector2(0,0)
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

#Llamado cuando se inicializa el objeto
func _ready():
	#Obtener referencia al player para ignorar colision de la camara con paredes
	player = get_parent().get_node("Player")
	pared_material = load("res://Materials/paredes_material.tres")
	piso_material = load("res://Materials/piso_material.tres")

	for j in range(cuantos): #For para cada habitacion
		
		#Decidir en que lado aparecerá la siguiente habitación
		
		
		#Randomizar tamaño habitacion
		randomize()
		room_x = rand_range(8,15)
		randomize()
		room_z = rand_range(8,15)

		
		#Sumar el tamaño de habitacion en las habitaciones posteriores a la primera
		if j != 0:
			randomize()
#			var lado:int = randi() % 4 
#			print(lado)
			var lado = 0
			if lado == 0: #Izquierda
				if j == 1:
					prev_habitacion.get_node("pared_izquierda").set_translation(Vector3(prev_room_x,room_y,0))
				else:
					prev_habitacion.get_node("pared_izquierda").set_translation(Vector3(prev_room_x,room_y,(-prev_room_z/2)-.5))
					prev_habitacion.get_node("pared_izquierda2").set_translation(Vector3(prev_room_x,room_y,(prev_room_z/2)+.5))
					prev_habitacion.get_node("puerta").set_translation(Vector3(prev_room_x,0.3,0))
					print(prev_habitacion.get_child(5).name)
				room_center.x = room_center.x - room_x - prev_room_x
			elif lado == 1: #Derecha
				room_center.x = room_center.x + room_x + prev_room_x
			elif lado == 2: #Arriba
				room_center.y = room_center.y + room_z + prev_room_z
			elif lado == 3: #Abajo
				room_center.y = room_center.y - room_z - prev_room_z
			
	
		var habitacion: Spatial = Spatial.new()
		habitacion.global_translate(Vector3(room_center.x,0,room_center.y))
		#Se crean 3 paredes y un piso y se añaden a escena
		var pared_superior: StaticBody = crear_pared_y_meter_a_escena(habitacion)
		pared_superior.set_name("pared_superior")
		var pared_inferior: StaticBody = crear_pared_y_meter_a_escena(habitacion)
		pared_inferior.set_name("pared_inferior")
		var pared_izquierda: StaticBody = crear_pared_y_meter_a_escena(habitacion)
		pared_izquierda.set_name("pared_izquierda")
		var piso: StaticBody = crear_pared_y_meter_a_escena(habitacion)
		piso.set_name("piso")
		add_child(habitacion)
		
		

		#Tamaño de la pared de arriba
		pared_superior.set_scale(Vector3(room_x,room_y,ancho_pared))
		#Posicion de la pared de arriba
		pared_superior.set_translation(Vector3(0,room_y,-room_z))
		#Colision de camara ignore la pared superior
		player.agregar_pared_a_ignorar(pared_superior)

		if j != 0: #La pared izquierda de la primera habitacion debe ser completa (no entrada)
			#Tamaño de la pared de la izquierda
			pared_izquierda.set_scale(Vector3(ancho_pared, room_y, (room_z/2)-.5))
			#Posicion de la pared de la izquierda
			pared_izquierda.set_translation(Vector3(-room_x,room_y, (-room_z/2)-.5))
			#Colision de camara ignore la pared de la izquierda
			player.agregar_pared_a_ignorar(pared_izquierda)
			
			var pared_izquierda2: StaticBody = crear_pared_y_meter_a_escena(habitacion)
			pared_izquierda2.set_name("pared_izquierda2")
			#Tamaño de la pared de la izquierda2
			pared_izquierda2.set_scale(Vector3(ancho_pared,room_y,(room_z/2)-.5))
			#Posicion de la pared de la izquierda2
			pared_izquierda2.set_translation(Vector3(-room_x,room_y,(room_z/2)+.5))
			#Colision de camara ignore la pared de la izquierda2
			player.agregar_pared_a_ignorar(pared_izquierda2)
			
			var puerta = load("res://Escenas/puerta.tscn").instance()
			habitacion.add_child(puerta)
			puerta.rotate_y(1.57)
			puerta.set_translation(Vector3(-room_x,0.3,0))
			puerta.set_name("puerta")
			
			#Si la habitacion es mas pequeña a la anterior generar paredes adicionales
			if room_z < prev_room_z :
				var dif = prev_room_z - room_z
				agregar_paredes_relleno(dif, habitacion)
		else:
			#Tamaño de la pared de la izquierda
			pared_izquierda.set_scale(Vector3(ancho_pared,room_y,room_z))
			#Posicion de la pared de la izquierda
			pared_izquierda.set_translation(Vector3(-room_x,room_y,0))
			#Colision de camara ignore la pared de la izquierda
			player.agregar_pared_a_ignorar(pared_izquierda)
			
		#Tamaño de la pared de abajo
		pared_inferior.set_scale(Vector3(room_x,room_y,ancho_pared))
		#Posicion pared de abajo
		pared_inferior.set_translation(Vector3(0,room_y,room_z))
		#Colision de camara ignore la pared de abajo
		player.agregar_pared_a_ignorar(pared_inferior)

		#Tamaño del piso
		piso.set_scale(Vector3(room_x,ancho_pared,room_z))
		#Posicion del piso
		piso.set_translation(Vector3(0,ancho_pared,0))
		#Asignar material al piso
		piso.get_child(0).set_surface_material(0, piso_material)

		#Si es el ultimo cuarto generar pared de la derecha y no generar puerta
		if j == (cuantos-1):
			var pared_derecha: StaticBody = crear_pared_y_meter_a_escena(habitacion)
			#Tamaño pared de la derecha
			pared_derecha.set_scale(Vector3(ancho_pared, room_y, room_z))
			#Queremos saber donde se encuentra la habitacion anterior
			if (prev_habitacion.translation.x-habitacion.translation.x) > 0:#Esta a la derecha
				#Posicion de la pared de la derecha
				pared_derecha.set_translation(Vector3(-room_x,room_y,0))
				pared_izquierda.set_translation(Vector3(room_x,room_y, (-room_z/2)-.5))
				habitacion.get_node("pared_izquierda2").set_translation(Vector3(room_x,room_y, (room_z/2)+.5))
				habitacion.get_node("puerta").set_translation(Vector3(room_x,0.3,0))
			else:
				#Posicion de la pared de la derecha
				pared_derecha.set_translation(Vector3(room_x,room_y,0))
			#Colision de camara ignore la pared de la derecha
			player.agregar_pared_a_ignorar(pared_derecha)
			
		#Se suma el tamaño de la habitacion para que la siguiente pueda
		#calcular su posicion en la escena
		prev_room_x = room_x
		prev_room_z = room_z
		prev_habitacion = habitacion

	player.generacion_finalizada()


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

func agregar_paredes_relleno(dif: float, habitacion: Spatial):
	var paredrelleno1: StaticBody = crear_pared_y_meter_a_escena(habitacion)
	paredrelleno1.set_scale(Vector3(ancho_pared,room_y,dif/2))
	paredrelleno1.global_translate(Vector3(-room_x,room_y,room_z+(dif/2)))

	var paredrelleno2: StaticBody = crear_pared_y_meter_a_escena(habitacion)
	paredrelleno2.set_scale(Vector3(ancho_pared,room_y,dif/2))
	paredrelleno2.global_translate(Vector3(-room_x,room_y,-room_z-(dif/2)))
