import std/net
import eventbus
import modules/autojoin
import modules/ctcpversion
import modules/pingpong

type
  Client* = object
    socket: Socket
    server: string
    port: Port
    nick: string
    user: string
    realname: string

proc newClient* (server, nick, user, realname: string, port: int): Client =
  result = Client()

  result.socket = newSocket()
  result.server = server
  result.port = Port(port)
  result.nick = nick
  result.user = user
  result.realname = realname

proc start* (c: Client) =
  c.socket.connect(c.server, c.port)

  c.socket.send("NICK " & c.nick & "\r\n")
  c.socket.send("USER " & c.user & " 0 * :" & c.realname & "\r\n")

  let bus = EventBus()

  bus.subscribe("message", proc (msg: string) = autojoin.call(c.socket, msg))
  bus.subscribe("message", proc (msg: string) = ctcpversion.call(c.socket, msg))
  bus.subscribe("message", proc (msg: string) = pingpong.call(c.socket, msg))

  var line = ""

  while true:
    c.socket.readLine(line)
    echo line

    bus.emit("message", line)
