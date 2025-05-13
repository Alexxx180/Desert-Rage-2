extends RefCounted # License MIT. Written by Samuel MARZIN. Edit by Tatarintsev Aleksandr.
# Detailed docs: https://github.com/Marzin-bot/PostgreSQLClient/wiki/Documentation

## Godot PostgreSQL Client - GDscript script/class allowing to connect and run SQL commands with Postgres backend. Able to send and receive data from the backend. Useful for managing multiplayer game, by saving a large amount of data on a dedicated Postgres server. Written in pure GDScript to not depend on GDNative for portability reasons.
class_name PostgreSQLClient

var op: PostgresClientOperation = PostgresClientOperation.new()

signal connection_closed(was_clean_close) ## Fires when backend connection closes.
signal connection_error() # del /!\ # No use
signal authentication_error(error_object) ## Triggered when auth process failed during contact with the target backend. Dictionary that contains various information with the error nature.
signal connection_established() ## Triggered when frontend and backend connection is established. Good time to start making requests to the backend with "execute".
signal data_received(error_object, transaction_status, datas) ## Returns an Array of PostgreSQLQueryResult. May be empty. There are as many PostgreSQLQueryResult elements in the array as there are SQL statements in sql - except in exceptional cases.

func establish_connection() -> void: connection_established.emit()
func close_connection(clean: bool) -> void: connection_closed.emit(clean)
func error_auth(object) -> void: authentication_error.emit(object)
func raise_data(error, transact, data) -> void: data_received.emit(error, transact, data)
func error_connection() -> void: connection_error.emit()

func _init() -> void:
	var c: ConnectionMetadata = op.connection.backend.connection 
	c.note.close.connect(close_connection)
	c.auth_error.connect(error_auth)
	c.established.connect(establish_connection)
	c.data_received.connect(raise_data)
