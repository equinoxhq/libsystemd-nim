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

{.push pure.}
type
  sd_bus_vtable_inner_start* = object
    element_size*: uint64
    features*: uint64
    vtable_format_reference*: ptr uint32

  sd_bus_vtable_inner_end* = object
    reserved*: uint64

  sd_bus_vtable_inner_method* = object
    member*: cstring
    signature*: cstring
    `result`*: cstring
    handler*: sd_bus_message_handler_t
    offset*: uint64
    names*: ptr UncheckedArray[cstring]

  sd_bus_vtable_inner_signal* = object
    member*, signature*, names*: cstring

  sd_bus_vtable_inner_property* = object
    member*: cstring
    signature*: cstring
    get*: sd_bus_property_get_t
    set*: sd_bus_property_set_t
    offset*: uint64

  sd_bus_vtable_inner* {.union.} = object
    start*: sd_bus_vtable_inner_start
    `end`*: sd_bus_vtable_inner_end
    `method`*: sd_bus_vtable_inner_method

  sd_bus_vtable* {.importc: "struct sd_bus_vtable".} = object
    `type`* {.bitsize: 8.}: uint8
    flags* {.bitsize: 56.}: uint64
    x*: sd_bus_vtable_inner
{.pop.}

{.pop.}

# Pure helper functions to construct a VTable.
# They're mostly just ports of the C macros in
# libsystemd.
proc vtableStart*(flags: uint64 = 0): sd_bus_vtable =
  sd_bus_vtable(
    `type`: SD_BUS_VTABLE_START,
    flags: flags,
    x: sd_bus_vtable_inner(
      start: sd_bus_vtable_inner_start(
        element_size: sizeof(sd_bus_vtable).uint64,
        features: SD_BUS_VTABLE_PARAM_NAMES,
        vtable_format_reference: sd_bus_object_vtable_format.addr,
      )
    ),
  )

proc methodWithNamesOffset*(
    member: string,
    signature: string,
    res: string,
    inNames, outNames: seq[string],
    handler: sd_bus_message_handler_t,
    offset: uint64,
    flags: uint64,
): sd_bus_vtable =
  var names = cast[ptr UncheckedArray[cstring]](inNames.len + outNames.len)
  let inNamesLen = inNames.len
  for i, nam in inNames:
    names[i] = cstring(nam)

  for i, nam in outNames:
    names[i + inNamesLen] = cstring(nam)

  sd_bus_vtable(
    `type`: SD_BUS_VTABLE_METHOD,
    flags: flags,
    x: sd_bus_vtable_inner(
        `method`: sd_bus_vtable_inner_method(
        member: member,
        signature: signature,
        `result`: res.cstring,
        handler: handler,
        offset: offset,
        names: names,
      ),
    )
  )

proc methodWithOffset*(
    member: string,
    signature: string,
    res: string,
    handler: sd_bus_message_handler_t,
    offset: uint64,
    flags: uint64 = 0,
): sd_bus_vtable =
  methodWithNamesOffset(
    member, signature, res, inNames = @[], outNames = @[], handler, offset, flags
  )

proc methodWithNames*(
    member: string,
    signature: string,
    inNames: seq[string],
    res: string,
    outNames: seq[string],
    handler: sd_bus_message_handler_t,
    flags: uint64,
): sd_bus_vtable =
  methodWithNamesOffset(member, signature, inNames = inNames, res = res, outNames = outNames, handler, 0, flags)

proc busMethod*(
  member: string, signature: string, res: string, handler: sd_bus_message_handler_t,
  flags: uint64 = 0
): sd_bus_vtable =
  methodWithNamesOffset(
    member, signature, inNames = @[], res = res, outNames = @[], handler, 0, flags
  )
