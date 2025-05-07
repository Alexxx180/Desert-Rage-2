extends RefCounted

class_name BackendMessage

var backend: Dictionary = {
	"no_host": "Invalid Postgres host.",
	"no_url": "Invalid Postgres URL.",
	"no_connection": "No connection to backend.",
	"no_support": "No support: ",
	"no_implentation": "Not implemented: ",
	"no_auth_support": "Backend requires to use an auth method what isn't supported. Unknown auth code.",
	"no_data": "Backend didn't send any data / a problem encountered while the backend sent a response to the request.",
	"sasl_auth_error": "SASL auth: error occurred. Front-back end connection interrupted. SCRAM dialog doesn't end as expected. Server couldn't prove that it was in possession of ServerKey. The backend doesn't seem reliable. Auth attempt failed.",
	"unrecognized": "The type of message sent by the backend is not recognized: "
}
