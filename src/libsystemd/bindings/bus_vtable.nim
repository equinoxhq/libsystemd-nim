import pkg/libsystemd/bindings/bus_types

template vt(ident: untyped, c: char) =
  const ident*: uint8 = cast[uint8](c)

vt SD_BUS_VTABLE_START, '<'
vt SD_BUS_VTABLE_END, '>'
vt SD_BUS_VTABLE_METHOD, 'M'
vt SD_BUS_VTABLE_SIGNAL, 'S'
vt SD_BUS_VTABLE_PROPERTY, 'P'
vt SD_BUS_VTABLE_WRITABLE_PROPERTY, 'W'

const
  SD_BUS_VTABLE_DEPRECATED* = uint8(1 shl 0)
  SD_BUS_VTABLE_HIDDEN* = uint8(1 shl 1)
  SD_BUS_VTABLE_UNPRIVILEGED* = uint8(1 shl 2)
  SD_BUS_VTABLE_METHOD_NO_REPLY* = uint8(1 shl 3)
  SD_BUS_VTABLE_PROPERTY_CONST* = uint8(1 shl 4)
  SD_BUS_VTABLE_PROPERTY_EMITS_CHANGE* = uint8(1 shl 5)
  SD_BUS_VTABLE_PROPERTY_EMITS_INVALIDATION* = uint8(1 shl 6)
  SD_BUS_VTABLE_PROPERTY_EXPLICIT* = uint8(1 shl 7)
  SD_BUS_VTABLE_PROPERTY_SENSITIVE* = uint8(1 shl 8)
  SD_BUS_VTABLE_PROPERTY_ABSOLUTE_OFFSET* = uint8(1 shl 9)
  SD_BUS_VTABLE_PROPERTY_CAPABILITY_MASK* = uint8(0xFFFF shl 40)
  SD_BUS_VTABLE_PARAM_NAMES* = 1 shl 0

{.push header: "<systemd/sd-bus-vtable.h>".}

var sd_bus_object_vtable_format* {.importc.}: uint32

type sd_bus_vtable* {.importc: "struct sd_bus_vtable", pure.} = object

{.pop.}

{.emit: "#include <systemd/sd-bus-vtable.h>".}

proc vtableStart*(flags: uint = 0): sd_bus_vtable =
  var res: sd_bus_vtable
  {.emit: """
`res` = (sd_bus_vtable) SD_BUS_VTABLE_START(`flags`);
    """.}

  move(res)

proc vtableEnd*(): sd_bus_vtable =
  var res: sd_bus_vtable
  {.emit: """
`res` = (sd_bus_vtable) SD_BUS_VTABLE_END;
    """.}

  move(res)

proc busMethod*(
  member: string, signature: string, res: string, handler: sd_bus_message_handler_t,
  flags: uint64 = 0
): sd_bus_vtable =
  let
    memberN = member.cstring
    sigN = signature.cstring
    resN = res.cstring

  var output: sd_bus_vtable
  {.emit: """
`output` = (sd_bus_vtable) SD_BUS_METHOD(`memberN`, `sigN`, `resN`, `handler`, `flags`);
    """.}

  move(output)
