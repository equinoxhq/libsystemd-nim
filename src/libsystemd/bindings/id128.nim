## low-level bindings over sd_id128

{.push header: "<systemd/sd-id128.h>".}
type sd_id128* {.importc: "union sd_id128", union.} = object
  bytes*: array[16, uint8]
  qwords*: array[2, uint64]

{.push importc.}
const
  SD_ID128_STRING_MAX*: uint32 = 33
  SD_ID128_UUID_STRING_MAX*: uint32 = 37

proc sd_id128_to_string*(id: sd_id128, s: ptr array[SD_ID128_STRING_MAX, char]): cstring
proc sd_id128_to_uuid_string*(
  id: sd_id128, s: ptr array[SD_ID128_UUID_STRING_MAX, char]
): cstring

proc sd_id128_from_string*(s: cstring, ret: ptr sd_id128): int32
proc sd_id128_randomize*(ret: ptr sd_id128): int32
proc sd_id128_get_machine*(ret: ptr sd_id128): int32
proc sd_id128_get_boot*(ret: ptr sd_id128): int32
proc sd_id128_get_invocation*(ret: ptr sd_id128): int32

proc sd_id128_get_app_specific*(
  base: sd_id128, app_id: sd_id128, ret: ptr sd_id128
): int32

proc sd_id128_get_machine_app_specific*(app_id: sd_id128, ret: ptr sd_id128): int32
proc sd_id128_get_boot_app_specific*(app_id: sd_id128, ret: ptr sd_id128): int32
proc sd_id128_get_invocation_app_specific*(app_id: sd_id128, ret: ptr sd_id128): int32
{.pop.}
{.pop.}
