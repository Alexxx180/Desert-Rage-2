extends RefCounted

class_name EncryptionSASL

signal stop()

var _stop: bool = false
var peers: TransferPeers
var credit: EncryptionCredentials
var op: BufferOperations
# Authentication SASL
var client_first_message: String 
var salted_password: PackedByteArray
var auth_message: String

var salt: EncryptionSalt = EncryptionSalt.new()
var version: PostgreProtocolVersion = PostgreProtocolVersion.new()
