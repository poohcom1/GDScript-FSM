"""
	A state that auto-transitions to an arbitrary state given a condition,
		regardless of the target state's condition.

	Example usages include transitioning to 'idle' state after landing a jump,
		or transitioning to the next combo after animation has finished.
"""
extends State
class_name AutoState

var next_state

func _init(parent: Entity, name, next: State).(parent, name):
	next_state = next

func exit_condition() -> bool:
	return true

func _transition(depth = 0):
	if exit_condition():
		return _on_transition(next_state)._transition(depth + 1)
	
	return ._transition(depth)
