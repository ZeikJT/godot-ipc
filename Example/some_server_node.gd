extends Node

const IPC_Server := preload("res://addons/inter_project_communication/server.gd")
const IPC_Shared := preload("res://addons/inter_project_communication/shared.gd")
const IPC_User := preload("res://Example/user.gd")


func _ready() -> void:
	add_child(IPC_Server.new(IPC_User.HOST, IPC_User.SOME_APP_PORT, {
		IPC_Shared.KEY_COMMANDS: {
			IPC_User.SOME_APP_COMMAND_DO_THING: {
				IPC_Shared.KEY_ARGC: 0,
				IPC_Shared.KEY_RUN: (
					func(source:String, track:String) -> Array[String]:
						# var some_id := some_other_instance.do_thing()
						var some_id := 123
						return [IPC_Shared.RESPONSE_200, str(some_id)]
						)
			},
			IPC_User.SOME_APP_COMMAND_UNDO_THING: {
				IPC_Shared.KEY_ARGC: 1,
				IPC_Shared.KEY_RUN: (
					func(some_id:String) -> Array[String]:
						# some_other_instance.undo_thing(some_id)
						return [IPC_Shared.RESPONSE_200, "Thing undone: %s" % [some_id]]
						)
			},
		}
	}))
