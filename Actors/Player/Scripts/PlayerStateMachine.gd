extends StateMachine

func set_moving_state(target_path):
	set_state("Moving")
	states[current_state].add_path(target_path)

