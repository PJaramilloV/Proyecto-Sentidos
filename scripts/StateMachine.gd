class_name StateMachine
extends Node

# Emitida al cambiar de estado
signal transitioned(state_name)

# Path al estado inicial
export var initial_state := NodePath("Idle")

# El estado actual
onready var state: State = get_node(initial_state)

func _ready() -> void:
	yield(owner, "ready")
	# Se le asigna el estado al personaje
	for child in get_children():
		child.state_machine = self
	state.enter()

# Se delegan los métodos
func _unhandled_input(event: InputEvent) -> void:
	state.handle_input(event)

func _process(delta: float) -> void:
	state.update(delta)

func _physics_process(delta: float) -> void:
	state.physics_update(delta)

# Se cambia el estado actual. Se llama a las funciones 'enter' y 'exit' respectivamente.
# Opcionalmente, se puede pasar un diccionario 'msg' al método 'enter'
func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
	# Basicamente, un assert()
	if not has_node(target_state_name):
		return

	state.exit()
	state = get_node(target_state_name)
	state.enter(msg)
	emit_signal("transitioned", state.name)
