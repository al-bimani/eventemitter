# Simple EventEmitter library for nim.


## Examples:

basic usage
```nim
import eventemitter
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
```

## types

```nim
type Args* = ref object of RootObj  
type Handler* = proc (args: Args) {.closure.}  
type Event* = tuple[name:string, handlers:seq[Handler]]  
type EventEmitter* = ref object  
    events: seq[Event]  
```
