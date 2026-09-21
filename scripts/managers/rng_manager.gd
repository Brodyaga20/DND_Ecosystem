extends Node

func true_random_number(from: int, to: int):
	var number = (randi() + int(Time.get_unix_time_from_system())) % (to - from) + from
	return number
