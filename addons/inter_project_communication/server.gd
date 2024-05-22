extends Node

const IPC_Shared := preload("res://addons/inter_project_communication/shared.gd")

const do_print := false # For debugging

var tcp_server := TCPServer.new()
var host:String
var port:int
var config:Dictionary
var peers:Array[StreamPeerTCP] = []
var peers_to_remove:Array[StreamPeerTCP] = []


func _init(host:String, port:int, config:Dictionary):
	assert(config.has(IPC_Shared.KEY_COMMANDS))
	for command_data in config[IPC_Shared.KEY_COMMANDS].values():
		assert(command_data.has(IPC_Shared.KEY_ARGC) and command_data[IPC_Shared.KEY_ARGC] is int)
		assert(command_data.has(IPC_Shared.KEY_RUN) and command_data[IPC_Shared.KEY_RUN] is Callable)
	self.host = host
	self.port = port
	self.config = config


func _ready():
	tcp_server.listen(port, host)


func validate_input(command_data:PackedStringArray) -> Array[String]:
	var command := command_data[0]
	var args := command_data.slice(1)
	if not config[IPC_Shared.KEY_COMMANDS].has(command):
		return [IPC_Shared.RESPONSE_400, "Command not found: %s" % command]
	if config[IPC_Shared.KEY_COMMANDS][command][IPC_Shared.KEY_ARGC] != args.size():
		return [IPC_Shared.RESPONSE_400, "Command %s expects %s args, but got %s: %s" % [command, config[IPC_Shared.KEY_COMMANDS][command][IPC_Shared.KEY_ARGC], args.size(), " ".join(args)]]
	return config[IPC_Shared.KEY_COMMANDS][command][IPC_Shared.KEY_RUN].callv(args)


func _process(delta):
	while tcp_server.is_connection_available():
		if do_print: print("Take Request")
		peers.append(tcp_server.take_connection())
	for peer in peers:
		if do_print: print("Process Peer")
		peer.poll()
		if peer.get_status() == StreamPeerTCP.STATUS_CONNECTED and peer.get_available_bytes() > 0:
			if do_print: print("Got Request ", peer.get_available_bytes())
			var command_string := peer.get_string(peer.get_available_bytes())
			if do_print: print("server command_string ", command_string)
			var command_data:PackedStringArray = command_string.substr(command_string.rfind("\r\n\r\n") + 4).strip_edges().split(" ")
			if do_print: print("command_data ", command_data)
			var results := validate_input(command_data)
			var status:String = results[0]
			var message:String = results[1]
			if do_print: print("status ", status, " message ", message)
			var message_buffer := message.to_utf8_buffer()
			peer.put_data(("HTTP/1.1 %s\r\nContent-Type: text/plain; charset=utf-8\r\nContent-Length: %s\r\n\r\n" % [status, message_buffer.size()]).to_utf8_buffer())
			peer.put_data(message_buffer)
			peer.disconnect_from_host()
			peers_to_remove.append(peer)
	for peer in peers_to_remove:
		peers.remove_at(peers.find(peer))
	peers_to_remove.clear()
