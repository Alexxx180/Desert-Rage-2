extends RefCounted # License MIT. Written by Samuel MARZIN. Edit by Tatarintsev Aleksandr.
# Detailed docs: https://github.com/Marzin-bot/PostgreSQLClient/wiki/Documentation

## Godot PostgreSQL Client - GDscript script/class allowing to connect and run SQL commands with Postgres backend. Able to send and receive data from the backend. Useful for managing multiplayer game, by saving a large amount of data on a dedicated Postgres server. Written in pure GDScript to not depend on GDNative for portability reasons.
class_name PostgreSQLClient

var op: PostgresClientOperation = PostgresClientOperation.new()

# signal connection_error() # del /!\ # No use

func connect_signals(meta) -> void:
	var c: ConnectionMetadata = op.connection.backend.connection 
	c.note.close.connect(meta.connection_closed) ## Fires when backend connection closes.
	c.auth_error.connect(meta.auth_error) ## Triggered when auth process failed during contact with the target backend. Dictionary that contains various information with the error nature.
	c.established.connect(meta.connection_established) ## Triggered when frontend and backend connection is established. Good time to start making requests to the backend with "execute".
	c.data_received.connect(meta.data_received) ## Returns an Array of PostgreSQLQueryResult. May be empty. There are as many PostgreSQLQueryResult elements in the array as there are SQL statements in sql - except in exceptional cases.
