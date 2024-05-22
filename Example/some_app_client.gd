const IPC_Client := preload("res://addons/inter_project_communication/client.gd")
const IPC_Shared := preload("res://addons/inter_project_communication/shared.gd")
const IPC_User := preload("res://Example/user.gd")

static func do_thing(thing:Node) -> IPC_Shared.Response:
	return await IPC_Client.make_request(thing, IPC_User.HOST, IPC_User.SOME_APP_PORT, IPC_User.SOME_APP_COMMAND_DO_THING)

static func undo_thing(thing:Node, some_id:String) -> IPC_Shared.Response:
	return await IPC_Client.make_request(thing, IPC_User.HOST, IPC_User.SOME_APP_PORT, IPC_User.SOME_APP_COMMAND_DO_THING, [some_id])
