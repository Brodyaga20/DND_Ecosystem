extends Node

func _ready():
	pass

func true_random_number(from: int, to: int):
	var number := (randi() + int(Time.get_unix_time_from_system() * 1000)) % (to - from) + from
	return number

func distribution_x_to_y(x: int, y: int):
	var arr := RngManager.n_from_xy_no_repeat(y - 1, 1, x + y - 1)
	arr.sort()
	arr.push_front(0)
	arr.push_back(x + y)
	var arr_new := []
	for i in range(1, arr.size()):
		arr_new.append(arr[i] - arr[i - 1] - 1)
	return arr_new

func n_from_xy_no_repeat(n:int, x: int, y: int) -> Array:
	var arr := []
	arr = range(x, y + 1)
	for i in range(0, n):
		var j = true_random_number(i, y)
		arr = UtilManager.swap(arr, i, j)
	arr = arr.slice(0, n)
	return arr
