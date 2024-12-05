extends Resource
class_name  Enemy_Resource

@export var enemy_name: String #What is the name of the enemy.
@export var enemy_speed: float #How fast does the enemy move.
@export var enemy_damage: float #How much damage does it deal.
@export var enemy_threat_level: int #How dangerous from 1 - 10. (0 - Helpful, 10 - Avengers level threat)
@export var enemy_is_hostle: bool #Is it frendly or hostile.
@export var enemy_is_attacking: bool #Is it attacking or just passing by.
@export var enemy_insta_kill: bool #Can the enemy kill with one hit.
