extends State
class_name AutoState

var next_state

func _init(parent: Entity, sprite, next: State).(parent, sprite):
	next_state = next

func exit_condition() -> bool:
	return true

func _transition(depth = 0):
	if exit_condition():
		return _on_transition(next_state)._transition(depth + 1)
	
	return ._transition(depth)
