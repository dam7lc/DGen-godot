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
	#Obtener referencia al player para ignorar colision de la camara con paredes
	player = get_parent().get_node("Player")
	pared_material = load("res://Materials/paredes_material.tres")
	piso_material = load("res://Materials/piso_material.tres")

	for j in range(cuantos): #For para cada habitacion
		
		#Randomizar tamaño habitacion
		randomize()
		room_x = rand_range(8,15)
		randomize()
		room_z = rand_range(8,15)

		#Sumar el tamaño de habitacion en las habitaciones posteriores a la primera
		if j != 0:
			room_center.x = room_center.x + (room_x)
			#room_center.y = room_center.x + (room_z/2)

		#Se crean 3 paredes y un piso y se añaden a escena
		var pared_superior: StaticBody = crear_pared_y_meter_a_escena()
		var pared_inferior: StaticBody = crear_pared_y_meter_a_escena()
		agregar_area_pared_inferior(pared_inferior)
		var pared_izquierda: StaticBody = crear_pared_y_meter_a_escena()
		var piso: StaticBody = crear_pared_y_meter_a_escena()

		#Si la habitacion es mas pequeña a la anterior generar paredes adicionales
		if room_z < prev_room_z :
			var dif = prev_room_z - room_z
			agregar_paredes_relleno(dif)

		#Tamaño de la pared de arriba
		pared_superior.set_scale(Vector3(room_x,room_y,ancho_pared))
		#Posicion de la pared de arriba
		pared_superior.global_translate(Vector3(room_center.x,room_y,(-room_z)+room_center.y))
		#Colision de camara ignore la pared superior
		player.agregar_pared_a_ignorar(pared_superior)

		if j != 0: #La primer pared debe ser completa (no entrada)
			#Tamaño de la pared de la izquierda
			pared_izquierda.set_scale(Vector3(ancho_pared, room_y, (room_z/2)-.5))
			#Posicion de la pared de la izquierda
			pared_izquierda.global_translate(Vector3((-room_x)+room_center.x,room_y,(room_center.y-room_z/2)-.5))
			#Colision de camara ignore la pared de la izquierda
			player.agregar_pared_a_ignorar(pared_izquierda)
			
			var pared_izquierda2: StaticBody = crear_pared_y_meter_a_escena()
			#Tamaño de la pared de la izquierda2
			pared_izquierda2.set_scale(Vector3(ancho_pared,room_y,(room_z/2)-.5))
			#Posicion de la pared de la izquierda2
			pared_izquierda2.global_translate(Vector3((-room_x)+room_center.x,room_y,(room_center.y+room_z/2)+.5))
			#Colision de camara ignore la pared de la izquierda2
			player.agregar_pared_a_ignorar(pared_izquierda2)
		else:
			#Tamaño de la pared de la izquierda
			pared_izquierda.set_scale(Vector3(ancho_pared,room_y,room_z))
			#Posicion de la pared de la izquierda
			pared_izquierda.global_translate(Vector3((-room_x)+room_center.x,room_y,room_center.y))
			#Colision de camara ignore la pared de la izquierda
			player.agregar_pared_a_ignorar(pared_izquierda)
			
		#Tamaño de la pared de abajo
		pared_inferior.set_scale(Vector3(room_x,room_y,ancho_pared))
		#Posicion pared de abajo
		pared_inferior.global_translate(Vector3(room_center.x,room_y,(room_z)+room_center.y))
		#Colision de camara ignore la pared de abajo
		player.agregar_pared_a_ignorar(pared_inferior)

		#Tamaño del piso
		piso.set_scale(Vector3(room_x,ancho_pared,room_z))
		#Posicion del piso
		piso.global_translate(Vector3(room_center.x,0,room_center.y))
		#Asignar material al piso
		piso.get_child(0).set_surface_material(0, piso_material)

		#Si es el ultimo cuarto generar pared de la derecha y no generar puerta
		if j == (cuantos-1):
			var pared_derecha: StaticBody = crear_pared_y_meter_a_escena()
			#Tamaño pared de la derecha
			pared_derecha.set_scale(Vector3(ancho_pared, room_y, room_z))
			#Posicion de la pared de la derecha
			pared_derecha.global_translate(Vector3((room_x)+room_center.x,room_y,room_center.y))
			#Colision de camara ignore la pared de la derecha
			player.agregar_pared_a_ignorar(pared_derecha)
		else:
			#Añadir la puerta
			var puerta = load("res://Escenas/puerta.tscn").instance()
			add_child(puerta)
			puerta.rotate_y(1.57)
			puerta.global_translate(Vector3(room_x+room_center.x,0.3,room_center.y))
			
		#Se suma el tamaño de la habitacion para que la siguiente pueda
		#calcular su posicion en la escena
		room_center.x = room_center.x + room_x
		prev_room_x = room_x
		prev_room_z = room_z

	player.generacion_finalizada()


func crear_pared_y_meter_a_escena():
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
	add_child(pared_raiz)
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

func agregar_paredes_relleno(dif):
	var paredrelleno1: StaticBody = crear_pared_y_meter_a_escena()
	paredrelleno1.set_scale(Vector3(ancho_pared,room_y,dif/2))
	paredrelleno1.global_translate(Vector3((-room_x)+room_center.x,room_y,(room_center.y+room_z+dif/2)))

	var paredrelleno2: StaticBody = crear_pared_y_meter_a_escena()
	paredrelleno2.set_scale(Vector3(ancho_pared,room_y,dif/2))
	paredrelleno2.global_translate(Vector3((-room_x)+room_center.x,room_y,(room_center.y-room_z-dif/2)))
