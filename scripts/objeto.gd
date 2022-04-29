extends RigidBody


func take_damage(instigator: Node):
	
	# el primero es para lanzar los objetos hacia adelante del personaje
	#apply_central_impulse((self.global_transform.origin - instigator.global_transform.origin)*5)
	var eje_x = get_viewport().get_mouse_position().x
	var eje_y = get_viewport().get_mouse_position().y
	var raton = Vector3(clamp((eje_x-500)/50, -4.3, 4.3),clamp((380-eje_y)/30, -3.5, 5),0)
	apply_central_impulse(raton)
	
	
	
	
	
