extends RefCounted
# License MIT. Written by Samuel MARZIN. Edit by Tatarintsev Aleksandr. Detailed documentation: https://github.com/Marzin-bot/PostgreSQLClient/wiki/Documentation

## Godot PostgreSQL Client - GDscript script/class allowing to connect and run SQL commands with Postgres backend. Able to send and receive data from the backend. Useful for managing multiplayer game, by saving a large amount of data on a dedicated Postgres server. Written in pure GDScript to not depend on GDNative for portability reasons.
class_name PostgreSQLClient

## Version number (minor.major) of the PostgreSQL protocol used when connecting to the backend.
const PROTOCOL_VERSION := 3.0
const PORT: int = 5432 # Default PostgreSQL port

enum Status { DISCONNECTED, CONNECTING, CONNECTED, ERROR } ## Connection presentation

var status = Status.DISCONNECTED # The status of the connection.

var secure_connection_method_buffer: SecureConnectionMethod = SecureConnectionMethod.NONE

enum TransactionStatus { ## One or more queries [Q] transaction state.
	NOT_IN_A_TRANSACTION_BLOCK, ## [Q] not in a transaction.
	IN_A_TRANSACTION_BLOCK, ## [Q] in a transaction.
	IN_A_FAILED_TRANSACTION_BLOCK ## [Q] in error transaction.
}

var client := StreamPeerTCP.new()
var peers: TransferPeers = TransferPeers.new()

func _init(): peers.set_stream(client)

## Fires when backend connection closes. If closed correctly "was_clean_close" is true otherwise false.
signal connection_closed(was_clean_close)
signal connection_error() # del /!\ # No use

signal authentication_error(error_object)## Triggered when authentication process failed during contact with the target backend. Dictionary that contains various information with the error nature.

signal connection_established()## Triggered when frontend and backend connection is established. Good time to start making requests to the backend with "execute".

signal data_received(error_object, transaction_status, datas)## Returns an Array of PostgreSQLQueryResult. May be empty. There are as many PostgreSQLQueryResult elements in the array as there are SQL statements in sql - except in exceptional cases.

