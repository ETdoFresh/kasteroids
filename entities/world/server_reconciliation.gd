extends Node2D

export var smoothing_rate = 0.1

var source_world
var target_world

#func _process(_delta):
#    for source_entity in source_world.entity_list:
#        var target_entity = target_world.get_entity_by_id(source_entity.id)
#        if not target_entity: continue
#
#        if source_entity.has_method("linear_interpolate"):
#            source_entity.linear_interpolate(target_entity, smoothing_rate)
