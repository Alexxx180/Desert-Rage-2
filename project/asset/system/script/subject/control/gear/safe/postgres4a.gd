extends RefCounted
# License MIT. Written by Samuel MARZIN. Edit by Tatarintsev Aleksandr. Detailed documentation: https://github.com/Marzin-bot/PostgreSQLClient/wiki/Documentation

## Godot PostgreSQL Client - GDscript script/class allowing to connect and run SQL commands with Postgres backend. Able to send and receive data from the backend. Useful for managing multiplayer game, by saving a large amount of data on a dedicated Postgres server. Written in pure GDScript to not depend on GDNative for portability reasons.
class_name PostgreSQLClient

## Version number (minor.major) of the PostgreSQL protocol used when connecting to the backend.
const PROTOCOL_VERSION := 3.0

## Default values throughout the script
const DEFAULT_INT: int = -1
const DEFAULT_DICT: Dictionary = {}
const 

enum Status { DISCONNECTED, CONNECTING, CONNECTED, ERROR } ## Connection presentation

# The status of the connection.
var status = Status.DISCONNECTED

enum SecureConnectionMethod { NONE, SSL, GSSAPI } ## Secure: insecure, SSL/TLS, GSSAPI

var secure_connection_method_buffer: SecureConnectionMethod = SecureConnectionMethod.NONE

enum TransactionStatus { ## One or more queries [Q] transaction state.
	NOT_IN_A_TRANSACTION_BLOCK, ## [Q] not in a transaction.
	IN_A_TRANSACTION_BLOCK, ## [Q] in a transaction.
	IN_A_FAILED_TRANSACTION_BLOCK ## [Q] in error transaction.
}

var password_global: String
var user_global: String

var client := StreamPeerTCP.new()
var peers: TransferPeers = TransferPeers.new()

var types: Dictionary = {
	"add": PostgreSQLClientAddType.new()
}

func _init():
	peers.set_stream(client)

const PORT: int = 5432 # Default PostgreSQL port

# To avoid confusion, codes below mustn't be the same as any protocol version number. Values contains significant pair of 16 bits: 1234 the most;
enum {
	CANCEL = 80877102 # The cancel request code. 5678 the least
	SSL = 80877103 # The SSL request code. 5679 the least.
	GSSAPI = 80877104 # The GSSAPI Encryption request code. 5680 the least
}

## Fires when backend connection closes. If closed correctly "was_clean_close" is true otherwise false.
signal connection_closed(was_clean_close)
signal connection_error() # del /!\ # No use

signal authentication_error(error_object)## Triggered when authentication process failed during contact with the target backend. Dictionary that contains various information with the error nature.

signal connection_established()## Triggered when frontend and backend connection is established. Good time to start making requests to the backend with "execute".

signal data_received(error_object, transaction_status, datas)## Returns an Array of PostgreSQLQueryResult. May be empty. There are as many PostgreSQLQueryResult elements in the array as there are SQL statements in sql - except in exceptional cases.

################ No use at
var process_backend_id: int ## The process ID of this backend.
var process_backend_secret_key: int ## The secret key of this backend.
################ the moment

var global_url = ""
var startup_message: PackedByteArray
var next_etape := false
