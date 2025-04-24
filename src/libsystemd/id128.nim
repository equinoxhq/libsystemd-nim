## High-level wrapper over libsystemd's id128 implementation
import std/posix
import pkg/libsystemd/bindings/id128

type ID128* = object
  handle: sd_id128

func `$`*(id: ID128): string =
  var buff: array[SD_ID128_STRING_MAX, char]
  $sd_id128_to_string(id.handle, buff.addr)

proc randomize*(id: var ID128) =
  let code = sd_id128_randomize(id.handle.addr)

  if code < 0:
    raise newException(ValueError, "Failed to randomize ID: " & $strerror(-code))

proc getMachineID*(): ID128 =
  var id: ID128
  let code = sd_id128_get_machine(id.handle.addr)

  if code < 0:
    raise newException(ValueError, "Failed to get machine ID: " & $strerror(-code))

  move(id)

proc getBootID*(): ID128 =
  var id: ID128
  let code = sd_id128_get_boot(id.handle.addr)

  if code < 0:
    raise newException(ValueError, "Failed to get boot ID: " & $strerror(-code))

  move(id)

proc getInvocationID*(): ID128 =
  var id: ID128
  let code = sd_id128_get_invocation(id.handle.addr)

  if code < 0:
    raise newException(ValueError, "Failed to get machine ID: " & $strerror(-code))

  move(id)

proc getAppSpecific*(id: var ID128, base, appId: ID128) =
  let code = sd_id128_get_app_specific(base.handle, appId.handle, id.handle.addr)

  if code < 0:
    raise newException(
      ValueError, "Failed to generate app-specific ID: " & $strerror(-code)
    )

proc getMachineAppSpecific*(id: var ID128, appId: ID128) =
  let code = sd_id128_get_machine_app_specific(appId.handle, id.handle.addr)

  if code < 0:
    raise newException(
      ValueError, "Failed to generate machine-app-specific ID: " & $strerror(-code)
    )

proc getBootAppSpecific*(id: var ID128, appId: ID128) =
  let code = sd_id128_get_boot_app_specific(appId.handle, id.handle.addr)

  if code < 0:
    raise newException(
      ValueError, "Failed to generate boot-app-specific ID: " & $strerror(-code)
    )

proc getInvocationAppSpecific*(id: var ID128, appId: ID128) =
  let code = sd_id128_get_invocation_app_specific(appId.handle, id.handle.addr)

  if code < 0:
    raise newException(
      ValueError, "Failed to generate invocation-app-specific ID: " & $strerror(-code)
    )

proc newID128*(s: string): ID128 =
  var id: ID128
  let code = sd_id128_from_string(s.cstring, id.handle.addr)

  if code < 0:
    raise newException(
      ValueError, "Failed to derive ID128 from string: " & $strerror(-code)
    )

  move(id)

proc newID128*(
    v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15: uint8 | byte
): ID128 =
  ID128(
    handle: sd_id128(
      bytes: [
        (byte) v0,
        (byte) v1,
        (byte) v2,
        (byte) v3,
        (byte) v4,
        (byte) v5,
        (byte) v6,
        (byte) v7,
        (byte) v8,
        (byte) v9,
        (byte) v10,
        (byte) v11,
        (byte) v12,
        (byte) v13,
        (byte) v14,
        (byte) v15,
      ]
    )
  )

proc newID128*[T: uint8 | byte](values: seq[T]): ID128 =
  when not defined(release):
    if values.len > 16:
      raise newException(
        ValueError,
        "This function only expects a grand total of 16 bytes at best. Got " &
          $values.len & " instead.",
      )

  var id: ID128

  for i, value in values:
    id.handle.bytes[i] = value

  move(id)
