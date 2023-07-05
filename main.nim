import std/os
import std/parseopt
import std/parseutils

import lib/client

var nimircVersion = "0.1.0"

proc usage() =
  echo "Usage: nimirc [options]"
  echo ""
  echo "Options:"
  echo "  -s, --server   Server to connect to"
  echo "  -p, --port     Port to connect to (default: 6667)"
  echo "  -n, --nick     Nickname to use"
  echo "  -u, --user     Username to use (default: nimirc)"
  echo "  -r, --realname Realname to use (default: Nimirc)"
  echo "  -h, --help     Show this help message and exit"
  echo "  -v, --version  Show version number and exit"

var server : string
var port = 6667
var nick : string
var user = "nimirc"
var realname = "Nimirc"

var opts = initOptParser(quoteShellCommand(commandLineParams()))

for kind, key, val in opts.getopt():
  case kind
  of cmdEnd: break
  of cmdArgument: continue
  of cmdLongOption, cmdShortOption:
    case key
    of "server", "s":
      server = val
    of "port", "p":
      discard parseInt(val, port)
    of "nick", "n":
      nick = val
    of "user", "u":
      user = val
    of "realname", "r":
      realname = val
    of "help", "h":
      usage()
      quit(0)
    of "version", "v":
      echo nimircVersion
      quit(0)

var errors: seq[string] = @[]

if server == "": errors.add("Server not specified")
if nick == "": errors.add("Nickname not specified")

if len(errors) > 0
  for err in errors:
    echo err
  quit(1)

var nimirc = newClient(
  server=server,
  port=port,
  nick=nick,
  user=user,
  realname=realname
)

nimirc.start()
