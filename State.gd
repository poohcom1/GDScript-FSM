class_name State

const LOOP_WARNING_THRESHOLD = 50
	
var parent: Entity
var sprite: String
var next_states: Array

var _force_next_state: State

var previous_state: State

var time: float = 0

func _init(_parent: Entity, _sprite: String):
	self.parent = _parent
	self.sprite = _sprite
	
func perform_and_transition(_delta) -> State:
	time += _delta
	perform(_delta)
	return _transition()
	
func perform(_delta: float):
	pass
	
func condition(_state: State) -> bool:
	return false
	
func _transition(depth = 0) -> State:
	if depth > LOOP_WARNING_THRESHOLD:
		push_warning("Statemachine Warning: Loop detected. Depth: (%d) [%s]" % [depth-1, previous_state.sprite])
		push_warning("Statemachine Warning: Loop detected. Depth: (%d) [%s]" % [depth, sprite])
		
		return self
	
	if _force_next_state != null:
		var next = _force_next_state
		_force_next_state = null
		return _on_transition(next)
	
	for state in next_states:
		if state.condition(self):
			_on_transition(state)
			return state._transition(depth + 1)
			
	return self
	
func _on_transition(next_state: State):
	next_state.previous_state = self
	on_exit()
	next_state.on_entry()
	next_state.time = 0
	return next_state

	
func force_transition(state: State):
	_force_next_state = state
	
func on_entry():
	self.parent.animatedSprite.animation = self.sprite
	self.parent.animatedSprite.play()
	
func on_exit():
	pass

