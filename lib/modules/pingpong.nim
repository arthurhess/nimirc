import strutils
import std/net
import std/re

proc call*(socket: Socket, message: string) =
  if (not message.match(re"^PING ")): return

  socket.send("PONG " & message.split(" ")[1] & "\r\n")
