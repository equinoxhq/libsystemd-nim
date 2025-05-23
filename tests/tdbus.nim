import std/posix
import pkg/libsystemd/bindings/prelude

template chk =
  assert(r >= 0, $strerror(-r))

var slot: ptr sd_bus_slot
var bus: ptr sd_bus

var r: int32

r = sd_bus_open_user(bus.addr)
var nam: cstring
discard sd_bus_get_unique_name(bus, nam)
echo "name: " & $nam
chk

var vtables: seq[sd_bus_vtable]
vtables &= vtableStart()
vtables &= busMethod(
  "SayHello", "", "s",
  proc (m: ptr sd_bus_message, userdata: pointer, ret_error: ptr sd_bus_error): cint {.cdecl.} =
    echo sd_bus_reply_method_return(m, "s".cstring, "Hallo :3".cstring)
)
vtables &= vtableEnd()
r = sd_bus_add_object_vtable(
  bus,
  slot.addr,
  "/com/example/Hello",
  "com.example.hello",
  vtables[0].addr, nil
)
echo strerror -r

let req = sd_bus_request_name(bus, "com.example.hello", 0)
echo req

while true:  
  let x = sd_bus_wait(bus, cast[uint64](-1))
  echo "hohohoho"

  while sd_bus_process(bus, nil) > 0:
    continue
