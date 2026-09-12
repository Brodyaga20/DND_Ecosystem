extends Node

var class_id = ""
var subclass_id = ""
var character_name = ""
var race_id = ""
var stats = {
	"strength": 0,
	"dexterity": 0,
	"intelligence": 0,
	"luck": 0
}
var history = ""
var traits = ""


func reset():
	class_id = ""
	subclass_id = ""
	character_name = ""
	stats = {"strength":0, "dexterity":0, "intelligence":0, "luck":0}
	history = ""
	traits = ""
