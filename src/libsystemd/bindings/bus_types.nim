## bus opaque types

template opaque(typ: untyped) =
  type typ* {.importc: "struct " & astToStr(typ), header: "<systemd/sd-bus.h>".} = object

type
  sd_bus_error* {.importc: "struct sd_bus_error", header: "<systemd/sd-bus.h>".} = object
    name*, message*: cstring
    need_free*: int32

  sd_bus_error_map* {.importc: "struct sd_bus_error_map", header: "<systemd/sd-bus.h>".} = object
    name*: cstring
    code*: int32

opaque sd_bus
opaque sd_bus_message
opaque sd_bus_slot
opaque sd_bus_creds
opaque sd_bus_track

{.push cdecl.}

type
  sd_bus_message_handler_t* = proc(m: ptr sd_bus_message, userdata: pointer, ret_error: ptr sd_bus_error): int32
  sd_bus_property_get_t* = proc(bus: ptr sd_bus, path, iface, property: cstring, reply: ptr sd_bus_message, userdata: pointer, ret_error: ptr sd_bus_error): int32
  sd_bus_property_set_t* = proc(bus: ptr sd_bus, path, iface, property: cstring, value: ptr sd_bus_message, userdata: pointer, ret_error: ptr sd_bus_error): int32

{.pop.}
