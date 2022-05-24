class_name State
extends Node

# La state machine que el Nodo va a settear
var state_machine = null

# Recibe un evento: Input
func handle_input(_event: InputEvent) -> void:
	pass

# == _process()
func update(_delta: float) -> void:
	pass

# == _physics_process()
func physics_update(_delta: float) -> void:
	pass

# Llamada al entrar al estado. El parámetro 'msg' es un diccionario de data
# arbitraria que puede ser utilizada por el estado
func enter(_msg := {}) -> void:
	pass

# Llamada al salir del estado. Utilizada para limpiar el estado
func exit() -> void:
	pass

