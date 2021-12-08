"""
	The base State class. 
	To create a state, override this class and create an instance in the desired node.
	
	To create a state machine, create a variable to represent the current_state, 
		and set it to the entrypoint state.
	Then, call perform_and_transition(delta) on every process frame, and set current_state
		to the return value of the function. This will automatically change the state
		if a transition is detected.
"""
class_name State

# Properties
const LOOP_WARNING_THRESHOLD = 50 # Amount of state loop before warnings are emitted

# Fields
var parent: Entity # Parent object
var name: String # Name of state

var next_states: Array # Next states to transition to
var previous_state: State # The previous transitioned from

var _force_next_state: State # State to force a transition to

var time: float = 0 # State time in seconds

func _init(_parent: Entity, _name: String):
	self.parent = _parent
	self.name = _name
	
# Virtual functions

"""
	The update function of the state. 
	Override with the main logic of the state
"""
func perform(_delta: float):
	pass
	
"""
	Condition to ENTER the state.
	Every frame, every next_state's condition is checked.
"""
func condition(_state: State) -> bool:
	return false

"""
	Called once when state has just transitioned to this state.
"""
func on_entry():
	pass
	
"""
	Called once when the state has just transitioned to another state.
"""
func on_exit():
	pass


# Internal functions

"""
	The 'update/process' function of a state that should be called in every process frame.
	Returns the next state to transition to, or itself if no transitions are detected.
	
	Example: If the states are stored in a variable called 'state', 
		state = state.perform_and_transition(delta) should be in _physics_process()
		of the parent object.
"""
func perform_and_transition(_delta) -> State:
	time += _delta
	perform(_delta)
	return _transition()

	
func _transition(depth = 0) -> State:
	if depth > LOOP_WARNING_THRESHOLD:
		push_warning("Statemachine Warning: Loop detected. Depth: (%d) [%s]" % [depth-1, previous_state.sprite])
		push_warning("Statemachine Warning: Loop detected. Depth: (%d) [%s]" % [depth, name])
		
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
	
