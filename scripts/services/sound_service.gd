class_name SoundService
extends Node

const BANK_PATH_TEMPLATE := "res://sounds/banks/%s.bank"

const SFX_BUS_PATH = "bus:/SFX"
const UI_BUS_PATH = "bus:/UI"

var sfx_bus: FmodBus
var ui_bus: FmodBus

var sfx_volume: float:
    get: return 0.0 if not sfx_bus else sfx_bus.volume

func _ready():
    process_mode = Node.PROCESS_MODE_ALWAYS

    load_bank("Master.strings")
    load_bank("Master")
    load_bank("SFX")
    load_bank("UI")

    sfx_bus = FmodServer.get_bus(SFX_BUS_PATH)
    ui_bus = FmodServer.get_bus(UI_BUS_PATH)

func load_bank(bank_name: String):
    FmodServer.load_bank(BANK_PATH_TEMPLATE % bank_name, FmodServer.FMOD_STUDIO_LOAD_BANK_NORMAL)

func set_sounds_paused(paused: bool):
    sfx_bus.paused = paused

func set_sfx_volume(new_sfx_volume: float):
    new_sfx_volume = clamp(new_sfx_volume, 0.0, 1.0)
    sfx_bus.volume = new_sfx_volume
    ui_bus.volume = new_sfx_volume
