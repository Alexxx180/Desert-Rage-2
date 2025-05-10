extends RefCounted

class_name BackendMessage

var client: String = "[PostgreSQLClient:%d]"

var backend: Dictionary = {
	"no_host": "Invalid Postgres host.",
	"no_url": "Invalid Postgres URL.",
	"no_connection": "No connection to backend.",
	"no_support": "No support: ",
	"no_implentation": "Not implemented: ",
	"no_auth_support": "Backend requires to use an auth method what isn't supported. Unknown auth code.",
	"no_data": "Backend didn't send any data / a problem encountered during request response.",
	"sasl_auth_error": "SASL auth: error occurred. Front-back end connection interrupted. SCRAM dialog doesn't end as expected. Server couldn't prove that it was in possession of ServerKey. The backend doesn't seem reliable. Auth attempt failed.",
	"unrecognized": "The type of message sent by the backend is not recognized: ",
	"already_secure": "Connection already secured with TLS/SSL.",
	"ssl_fail": "The connection attempt failed. The backend doesn't want to establish a secure SSL/TLS connection.",
	"ssl_unrecognized": "The backend sent an unknown response to the request to establish a secure connection. Unrecognized response: ",
	"already_disconnected": "The frontend was already disconnected from the backend when calling 'close'.",
	"invalid_value": "The backend sent an invalid object. Column value is not recognized: ",
	"invalid_ip": "IP address present isn't valid: ",
	"regex_failed": "RegEx compilation of object failed. Error: ",
	"no_sasl": "No SASL mechanism offered by the backend is supported by the frontend for SASL authentication."
}
