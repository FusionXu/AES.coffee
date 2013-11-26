Encrypt_AES_ECB = (plaintext) ->
	plaintext = enFill(plaintext)
	
	ret = ''
	for i in [0...plaintext.length] by 16
		ret += Encrypt_AES(plaintext.slice(i,i+16), key)
	
	return ret
	
Decrypt_AES_ECB = (ciphertext) ->
	ret = ''
	for i in [0...ciphertext.length] by 16
		ret += Decrypt_AES(ciphertext.slice(i,i+16), key)
			
	ret = deFill(ret)
	return ret
	
Encrypt_AES_CBC = (plaintext) ->
	plaintext = enFill(plaintext)
	
	VI = "7777777777777777"
	pre = VI
	ret = ""
	block = ""
	for i in [0...plaintext.length] by 16
		block = plaintext.slice(i,i+16)
		pre = Encrypt_AES(Xor(pre, block), key)
		ret += pre
	
	return ret
	
Decrypt_AES_CBC = (ciphertext) ->
	VI = "7777777777777777"
	pre = VI
	ret = ""
	block = ""
	for i in [0...ciphertext.length] by 16
		block = ciphertext.slice(i, i + 16)
		ret += Xor(pre, Decrypt_AES(block, key))
		pre = block
	
	ret = deFill(ret)
	return ret
	
Encrypt_AES_CTR = (plaintext) ->
	plaintext = enFill(plaintext)
	
	VI = "7777777777777777"
	CT = VI
	ret = ""
	block = ""
	for i in [0...plaintext.length] by 16
		block = plaintext.slice(i, i + 16)
		ret += Xor(Encrypt_AES(CT, key), block)
		CT = String(parseInt(CT, 10) + 1)
	
	return ret

Decrypt_AES_CTR = (ciphertext) ->
	VI = "7777777777777777"
	CT = VI
	ret = ""
	block = ""
	for i in [0...ciphertext.length] by 16
		block = ciphertext.slice(i, i + 16)
		ret += Xor(Encrypt_AES(CT, key), block)
		CT = String(parseInt(CT, 10) + 1)
	
	ret = deFill(ret)
	return ret
	
enFill = (text) ->
	fill = 16 - (text.length % 16)
	if fill == 16 
		text += '0' for [0...16]
	else
		text += fill.toString(16) for [0...fill]
	return text
	
deFill = (text) ->
	end = text[text.length - 1]
	if end == '0'
		return text.slice(0, text.length - 16)
	else
		return text.slice(0, text.length - parseInt(end, 16))
		
ToHex = (string) ->
	block = new Array(16)
	block[i] = parseInt(string[i].charCodeAt().toString(10), 10) for i in [0...string.length]
	return block
	
ToStr = (block) ->
	string = new String("")
	string += String.fromCharCode(parseInt(block[i], 10)) for i in [0...block.length]
	return string

Xor = (a, b) ->
	a = ToHex(a)
	b = ToHex(b)
	c = new Array(16)
	c[i] = a[i] ^ b[i] for i in [0...16]
	c = ToStr(c)
	return c