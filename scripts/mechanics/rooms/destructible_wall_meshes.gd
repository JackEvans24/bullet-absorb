class_name DestructibleWallMeshes
extends Node3D

@onready var normal_mesh: MeshInstance3D = $DestructibleWall
@onready var crumbling_mesh: MeshInstance3D = $CrumblingWall
@onready var destroyed_mesh: MeshInstance3D = $DestroyedWall

enum DestructionState {Normal, Crumbling, Destroyed, Unchanged}

var current_state := DestructionState.Normal
var can_destroy := false

func try_destroy() -> DestructionState:
    if current_state == DestructionState.Normal:
        current_state = DestructionState.Crumbling
        set_meshes()
        return current_state

    if not can_destroy:
        return DestructionState.Unchanged

    if current_state == DestructionState.Destroyed:
        return DestructionState.Unchanged

    current_state = DestructionState.Destroyed
    set_meshes()
    return current_state

func set_meshes():
    normal_mesh.visible = current_state == DestructionState.Normal
    crumbling_mesh.visible = current_state == DestructionState.Crumbling
    destroyed_mesh.visible = current_state == DestructionState.Destroyed
