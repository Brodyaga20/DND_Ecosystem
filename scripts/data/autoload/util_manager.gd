extends Node

func swap(arr: Array, index_x: int, index_y: int) -> Array:
	var arr_new = arr.duplicate()
	var temp = arr[index_x]
	arr_new[index_x] = arr[index_y]
	arr_new[index_y] = temp
	return arr_new
