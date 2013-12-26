# This is it
express = require "express"
app = express.createServer()
io = require("socket.io").listen app
 
app.use express.static(__dirname + '/public')
app.use express.errorHandler { showStacktrace: true, dumpExceptions: true }

clients = 0
price = 1000
price_decrement = 0.01 * price

tick = ->
	price -= price_decrement

	if price <= 0
		clearInterval tick.timerId
		console.log 'auction ended'
		io.sockets.emit 'end', { message: 'auction ended' }
		clearInterval tick.timerId
		return
	io.sockets.emit 'price_update', {price : price}

io.sockets.on 'connection', (socket) ->
	clients++
	socket.on 'start', () ->
		tick.timerId = setInterval tick, 100
	socket.on 'place_bid', (message) ->
		console.log " placed bid ", message

app.listen 3000
