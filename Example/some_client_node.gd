extends Node

const IPC_Shared := preload("res://addons/inter_project_communication/shared.gd")
const SomeAppClient := preload("res://Example/some_app_client.gd")


func _ready() -> void:
	var response := SomeAppClient.do_thing(self)
	if response.status == IPC_Shared.RESPONSE_STATUS.SUCCESS:
		SomeAppClient.undo_thing(self, response.text)
