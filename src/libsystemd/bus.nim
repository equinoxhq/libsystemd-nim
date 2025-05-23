## High-level wrapper over sd-bus.
## It optionally supports a builder pattern.
import std/posix
import pkg/libsystemd/bindings/[libc, bus, bus_vtable, bus_types]

type
  BusError* = object of OSError
  NameAlreadyAcquired* = object of BusError
  NameReleaseError* = object of BusError

  Bus* = object
    handle*: ptr sd_bus
    slot*: ptr sd_bus_slot

func throwBusError*(code: int32) {.raises: [BusError], inline.} =
  raise newException(BusError, $strerror(code))

proc `=destroy`*(bus: Bus) =
  if bus.handle == nil:
    return

  discard sd_bus_unref(bus.handle)
  discard sd_bus_slot_unref(bus.slot)

proc `=copy`*(dest: var Bus, src: Bus) =
  dest.handle = sd_bus_ref(src.handle)
  dest.slot = sd_bus_slot_ref(src.slot)

proc `=sink`*(dest: var Bus, src: Bus) =
  dest.handle = src.handle
  dest.slot = src.slot

func newBus*(): Bus {.inline, raises: [].} =
  Bus()

proc listAcquiredNames*(bus: Bus): seq[string] =
  var names: ptr UncheckedArray[cstring]
  let listRes = sd_bus_list_names(bus.handle, acquired = names.addr, activatable = nil)

  if listRes < 0:
    throwBusError(-listRes)

  var vec: seq[string]
  var i: uint32

  while true:
    let nam = names[i]
    if nam == nil:
      break # We've reached the end of the list.
    
    vec.add($nam)
    inc i

  libc.free(names) # We're responsible for freeing the array as libsystemd handed us over its ownership.
  move(vec)

proc listActivatableNames*(bus: Bus): seq[string] =
  var names: ptr UncheckedArray[cstring]
  let listRes = sd_bus_list_names(bus.handle, acquired = nil, activatable = names.addr)

  if listRes < 0:
    throwBusError(-listRes)

  var vec: seq[string]
  var i: uint32

  while true:
    let nam = names[i]
    if nam == nil:
      break # We've reached the end of the list.
    
    vec.add($nam)
    inc i

  libc.free(names) # We're responsible for freeing the array as libsystemd handed us over its ownership.
  move(vec)

proc processMessages*(bus: var Bus) {.raises: [BusError].} =
  let waitRes = sd_bus_wait(bus.handle, cast[uint64](-1))
  if waitRes < 0:
    throwBusError(-waitRes)

  let procRes = sd_bus_process(bus.handle, nil)
  if procRes < 0:
    throwBusError(-procRes)

{.push discardable.}
proc connectToUserBus*(bus: Bus): Bus {.raises: [BusError].} =
  let openRes = sd_bus_open_user(bus.handle.addr)

  if openRes < 0:
    throwBusError(-openRes)

  bus

proc connectToSystemBus*(bus: Bus): Bus {.raises: [BusError].} =
  let openRes = sd_bus_open_system(bus.handle.addr)

  if openRes < 0:
    throwBusError(-openRes)

  bus

proc release*(bus: Bus, name: string) {.raises: [BusError, NameReleaseError].} =
  let releaseRes = sd_bus_release_name(bus.handle, name.cstring)

  if releaseRes < 0:
    case releaseRes
    of -EADDRINUSE:
      raise newException(NameReleaseError, "Attempt to release name not owned by this process: " & name)
    of -ESRCH:
      raise newException(NameReleaseError, "Attempt to release name not registered on the bus: " & name)
    else:
      throwBusError(-releaseRes)

proc connect*(bus: Bus): Bus {.raises: [BusError].} =
  let openRes = sd_bus_default_system(bus.handle.addr)

  if openRes < 0:
    throwBusError(-openRes)

  bus

proc requestName*(bus: Bus, name: string): Bus {.raises: [NameAlreadyAcquired, BusError].} =
  let reqRes = sd_bus_request_name(bus.handle, name.cstring, 0)
  case reqRes
  of 0: raise newException(NameAlreadyAcquired, "The name `" & name & "` is already acquired by another process.")
  of 1: discard
  else:
    throwBusError(-reqRes)
  
  bus

{.pop.}
