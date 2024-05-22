enum RESPONSE_STATUS {
	REQUEST_FAILED = 0,
	SUCCESS = 200,
	NO_CHANGE = 202,
	BAD_REQUEST = 400,
	ERROR = 500,
}

const RESPONSE_0   := "%s REQUEST_FAILED" % RESPONSE_STATUS.REQUEST_FAILED
const RESPONSE_200 := "%s OK" % RESPONSE_STATUS.SUCCESS
const RESPONSE_202 := "%s Accepted" % RESPONSE_STATUS.NO_CHANGE
const RESPONSE_400 := "%s Bad Request" % RESPONSE_STATUS.BAD_REQUEST
const RESPONSE_500 := "%s Internal Server Error" % RESPONSE_STATUS.ERROR

const KEY_COMMANDS := "commands"
const KEY_ARGC := "argc"
const KEY_RUN := "run"

class Response:
	var status:RESPONSE_STATUS
	var text:String

	func _init(status:RESPONSE_STATUS, text:String):
		self.status = status
		self.text = text
