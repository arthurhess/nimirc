import std/net
import std/re
import strutils

let channels = ["#Aurora"]

proc call*(socket: Socket, message: string) =
  var matches: array[3, string]

  if (not message.match(re"^:([^\s]+) (\w+) (.*)$", matches)): return

  if (matches[1] == "376"):
    socket.send("JOIN " & channels.join(",") & "\r\n")
