class BitArray:
	var data: PackedByteArray
	var active_bits: int
	
	func _init(_num_bits: int = 8):
		resize_bits(_num_bits)
	
	func _to_string():
		var string: String
		for i in range(active_bits): string += str(int(get_bit(i)))
		
		return string
	
	func resize_bits(new_size: int, reset_bits: bool = true):
		data.resize(ceili(float(new_size) / 8))
		active_bits = new_size
		
		if reset_bits: fill_bits(false)
	
	func fill_bits(new_value: bool):
		for i in range(active_bits): set_bit(i, new_value)
	
	func append(other: BitArray):
		var offset = active_bits
		resize_bits(active_bits + other.active_bits, false)
		
		for i in range(other.active_bits): set_bit(i + offset, other.get_bit(i))
	
	func get_bit(index: int):
		if index < 0 or index > len(data) * 8 - 1:
			push_error('ERROR: Tried to call `get_bit` with invalid index.')
			return false
		elif len(data) == 0: 
			push_error('ERROR: There are no bits to set.')
			return false
		
		return bool(data[index / 8] & 1 << (index % 8))
	
	func set_bit(index: int, value: bool):
		if index < 0 or index > len(data) * 8 - 1:
			push_error('ERROR: Tried to call `set_bit` with invalid index.')
			return
		elif len(data) == 0: 
			push_error('ERROR: There are no bits to set.')
			return
		
		var mask = 1 << (index % 8) # It's nice that GDScript supports this
		if value: data[index / 8] |= mask
		else: data[index / 8] &= ~mask
	
	func duplicate():
		var new_array = BitArray.new(active_bits)
		new_array.data = data.duplicate()
		return new_array
