import tables

type EventBus* = ref object
  eventsMap: Table[string, seq[proc(payload: string)]]

proc subscribe*(emitter: EventBus, event: string, callback: proc(payload: string)) =
  if not emitter.eventsMap.hasKey(event):
    emitter.eventsMap[event] = @[]
  emitter.eventsMap[event].add(callback)

proc emit*(emitter: EventBus, event, payload: string) =
  if not emitter.eventsMap.hasKey(event): return
  for callback in emitter.eventsMap[event]:
    callback(payload)
