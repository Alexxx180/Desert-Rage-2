extends RefCounted

class_name PeerStreamsStatus

enum { START = 0, CRYPTO = 1, CONNECTING = 2, FINISH = 3 }

var state: int = START

func is_start() -> bool: return state == START

func is_crypto() -> bool: return state == CRYPTO

func is_connecting() -> bool: return state == CONNECTING

func is_intermediate() -> bool: return state in [CRYPTO, CONNECTING]

func is_finished() -> bool: return state == FINISH

func set_start() -> void: state = START

func set_crypto() -> void: state = CRYPTO

func set_connecting() -> void: state = CONNECTING
