const IPC_Shared := preload("res://addons/inter_project_communication/shared.gd")

const do_print := false # For debugging
var node:Node
var host:String
var port:int

# Can be used statically, no need to instantiate.
static func make_request(node:Node, host:String, port:int, command:String, args:Array[String] = []) -> IPC_Shared.Response:
	var http_request := HTTPRequest.new()
	var command_string := "%s%s" % [command, (" %s" % " ".join(args)) if args.size() > 0 else ""]
	http_request.set_name("request for %s" % command_string)
	node.add_child(http_request)

	# If an app is down this basically waits forever, why?
	var err := http_request.request("http://%s:%s" % [host, port], [], HTTPClient.METHOD_POST, command_string)

	if err != OK:
		print("Request failed: ", err)
		http_request.queue_free()
		return IPC_Shared.Response.new(IPC_Shared.RESPONSE_STATUS.REQUEST_FAILED, IPC_Shared.RESPONSE_0)

	var response_info:Array = await(http_request.request_completed)
	var was_success:bool = response_info[1] >= 200 and response_info[1] < 300
	if not was_success:
		if do_print: print("Response was not a 2XX: ", response_info)
		if do_print: print(response_info[3].get_string_from_utf8())

	http_request.queue_free()
	return IPC_Shared.Response.new(response_info[1], response_info[3].get_string_from_utf8())


# If you do want to instantiate then we might as well make it easier to use.
func _init(node:Node, host:String, port:int):
	self.node = node
	self.host = host
	self.port = port

func request(command:String, args:Array[String] = []) -> IPC_Shared.Response:
	return await make_request(node, host, port, command, args)
