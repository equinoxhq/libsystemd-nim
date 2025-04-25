import std/posix
import pkg/libsystemd/bindings/prelude

template chk =
  assert(r >= 0, $strerror(-r))

var slot: ptr sd_bus_slot
var bus: ptr sd_bus

var r: int32

r = sd_bus_open_user(bus.addr)
chk

var vtables: seq[sd_bus_vtable]
vtables &= vtableStart()
vtables &= busMethod(
  "SayHello", "", "s",
  proc (m: ptr sd_bus_message, userdata: pointer, ret_error: ptr sd_bus_error): int32 {.cdecl, closure.} =
    return sd_bus_reply_method_return(m, "s".cstring, "Hallo :3".cstring)
)
r = sd_bus_add_object_vtable(
  bus,
  slot.addr,
  "/com/example/Hello",
  "com.example.hello",
  vtables[0].addr, nil
)
