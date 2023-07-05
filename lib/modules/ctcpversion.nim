import std/net
import std/re
import strutils

import ../info

proc call*(socket: Socket, message: string) =
  var matches: array[3, string]

  if (not message.match(re"^:([^\s]+) (\w+) (.*)$", matches)): return

  let msgFrom = matches[0]
  let command = matches[1]
  let message = matches[2]

  if (command == "PRIVMSG" and message.split(" ")[1] == ":\1VERSION\1"):
    let nick = msgFrom.split("!")[0]

    socket.send("NOTICE " & nick & " :\1VERSION Arthur on Nim (" & version & ")\1\r\n")
