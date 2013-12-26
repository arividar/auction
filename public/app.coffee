intervalId = undefined
initial_price = undefined
price_decrement = undefined
bid_start = undefined
bid_end = undefined

getTime = -> (new Date).getTime()

tick = ->
    price = parseInt $("#counter").text()
    price = price - price_decrement

    if price <= 0
        clearInterval tick.timerId
    
    $("#counter").text price

$ ->
    socket = io.connect 'http://localhost'

    socket.on 'price_update', (data) ->
        bid_start = getTime()
        console.log 'auction started'
        
        $("#counter").text data.price

    socket.on 'end', (data) ->
        bid_end = getTime()
        console.log "auction ended, auction took: #{bid_start - bid_end} ms"

    $("#bid").click ->
        price = parseInt $("#counter").text()
        socket.emit 'place_bid', { price: price }

    $("#start_auction").click ->
        price = parseInt $("#counter").text()
        socket.emit 'start'
