# data_manager.gd (Autoload)
extends Node

var character_classes: CharacterClassRepository
var character_subclasses: CharacterSubclassRepository
var races: RacesRepository
var archetypes: CharacterArchetypeRepository
var resources: ClassResourceRepository
var age_periods: NamedEntryRepository
var stats: StatsRepository
#var items: ItemRepository
#var abilities: AbilityRepository

func _ready() -> void:
	character_classes = CharacterClassRepository.new()
	character_subclasses = CharacterSubclassRepository.new()
	races = RacesRepository.new()
	archetypes = CharacterArchetypeRepository.new()
	resources = ClassResourceRepository.new()
	stats = StatsRepository.new()
	
	age_periods = NamedEntryRepository.new()
	#items = ItemRepository.new()
	#abilities = AbilityRepository.new()

	character_classes.load_from("res://data/character_classes.json")
	character_subclasses.load_from("res://data/character_subclasses.json")
	races.load_from("res://data/races.json")
	archetypes.load_from("res://data/character_archetypes.json")
	resources.load_from("res://data/class_resources.json")
	stats.load_from("res://data/stats.json")
	
	age_periods.load_from("res://data/named_entries/age_periods.json")
	
	_build_class_subclass_links()
	#items.load_from("res://data/items.json")
	#abilities.load_from("res://data/abilities.json")

func _build_class_subclass_links() -> void:
	for sub in character_subclasses.all():
		var parent = character_classes.get_by_id(sub.class_id)
		if parent == null:
			push_error("Subclass %s references unknown class %s" % [sub.id, sub.class_id])
			continue
		
		parent.subclass_ids.append(sub.id)
