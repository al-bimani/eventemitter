type 
  Args* = ref object of RootObj # ...args
  Handler* = proc (args: Args) {.closure.} # callback function type
  Event* = tuple[name:string, handlers:seq[Handler]] # key value pair
  EventEmitter* = ref object
    events: seq[Event] # will use sequence as fixed size array

proc createEventEmitter*(): EventEmitter = 
  result.new
  result.events = @[]

method on*(this: EventEmitter, name: string, handler: Handler): void {.base.} = 
  var event: Event = (name: name, handlers: @[])
  var id: int = -1
  for i in 0..high(this.events):
    let evt = this.events[i]
    if evt.name == name:
      id = i
      event = evt
  event.handlers.add(handler)
  if id == -1: this.events.add(event)
  else: this.events[id] = event

method once*(this:EventEmitter, name:string, handler:Handler): void {.base.} =
  var id: Natural = 0
  for i in 0..high(this.events):
    let evt = this.events[i]
    if evt.name == name:
      id = evt.handlers.len()
  this.on(name) do(a: Args):
    handler(a)
    for i in 0..high(this.events):
      var evt = this.events[i]
      if evt.name == name:
        evt.handlers.del(id)

method emit*(this:EventEmitter, name:string, args:Args): void {.base.} =
  for i in 0..high(this.events):
    let evt = this.events[i]
    if evt.name == name:
      for x in 0..high(evt.handlers): 
        evt.handlers[x](args)

when isMainModule:
  block:
    type ReadyArgs = ref object of Args
      text: string
    var evts = createEventEmitter()
    evts.on("ready") do(a: Args):
      var args = ReadyArgs(a)
      echo args.text, ": from [1st] handler"
    evts.once("ready") do(a: Args):
      var args = ReadyArgs(a)
      echo args.text, ": from [2nd] handler"
    evts.emit("ready", ReadyArgs(text:"Hello, World"))
    evts.emit("ready", ReadyArgs(text:"Hello, World"))
