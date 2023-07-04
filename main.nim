import std/net

import lib/eventbus
import lib/modules/autojoin
import lib/modules/ctcpversion
import lib/modules/pingpong

let socket = newSocket()
socket.connect("irc.brasirc.com.br", Port(6667))

socket.send("NICK Arthur`nim\r\n")
socket.send("USER arthur 0 * :Arthur on Nim\r\n")

let bus = EventBus()

bus.subscribe("message", proc (msg: string) = autojoin.call(socket, msg))
bus.subscribe("message", proc (msg: string) = ctcpversion.call(socket, msg))
bus.subscribe("message", proc (msg: string) = pingpong.call(socket, msg))

var line = ""

while true:
  socket.readLine(line)
  echo line

  bus.emit("message", line)
