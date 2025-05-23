## High-level wrapper over sd-bus
import ./bindings/[bus, bus_vtable, bus_types]

type
  Bus* = object
    handle*: ptr sd_bus

proc `=destroy`*(bus: Bus) =
  if bus.handle == nil:
    return

  sd_bus_unref(bus.handle)

proc `=copy`*(dest: var Bus, src: Bus) =
  dest.handle = sd_bus_ref(src.handle)

proc `=sink`*(dest: var Bus, src: Bus) =
  dest.handle = src.handle
