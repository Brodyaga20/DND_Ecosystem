class_name PersonalInfo
extends RefCounted

var backstory: String = ""
var traits: String = ""
var secret: String = ""
var life_goal: String = ""

func to_dict() -> Dictionary:
	return {
		"backstory": backstory,
		"traits": traits,
		"secret": secret,
		"life_goal": life_goal,
	}

static func from_dict(raw: Dictionary) -> PersonalInfo:
	var p := PersonalInfo.new()
	p.backstory = raw.get("backstory", "")
	p.secret = raw.get("secret", "")
	p.life_goal = raw.get("life_goal", "")
	p.traits = raw.get("traits", "")
	return p
