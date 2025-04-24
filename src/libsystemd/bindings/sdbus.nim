## low-level bindings around systemd-bus

template opaque(typ: untyped) =
  type typ* {.importc: "struct " & astToStr(typ), header: "<systemd/sd-bus.h>".} = object

const
  SD_BUS_CREDS_PID                = 1 shl 0
  SD_BUS_CREDS_TID                = 1 shl 1
  SD_BUS_CREDS_PPID               = 1 shl 2
  SD_BUS_CREDS_UID                = 1 shl 3
  SD_BUS_CREDS_EUID               = 1 shl 4
  SD_BUS_CREDS_SUID               = 1 shl 5
  SD_BUS_CREDS_FSUID              = 1 shl 6
  SD_BUS_CREDS_GID                = 1 shl 7
  SD_BUS_CREDS_EGID               = 1 shl 8
  SD_BUS_CREDS_SGID               = 1 shl 9
  SD_BUS_CREDS_FSGID              = 1 shl 10
  SD_BUS_CREDS_SUPPLEMENTARY_GIDS = 1 shl 11
  SD_BUS_CREDS_COMM               = 1 shl 12
  SD_BUS_CREDS_TID_COMM           = 1 shl 13
  SD_BUS_CREDS_EXE                = 1 shl 14
  SD_BUS_CREDS_CMDLINE            = 1 shl 15
  SD_BUS_CREDS_CGROUP             = 1 shl 16
  SD_BUS_CREDS_UNIT               = 1 shl 17
  SD_BUS_CREDS_SLICE              = 1 shl 18
  SD_BUS_CREDS_USER_UNIT          = 1 shl 19
  SD_BUS_CREDS_USER_SLICE         = 1 shl 20
  SD_BUS_CREDS_SESSION            = 1 shl 21
  SD_BUS_CREDS_OWNER_UID          = 1 shl 22
  SD_BUS_CREDS_EFFECTIVE_CAPS     = 1 shl 23
  SD_BUS_CREDS_PERMITTED_CAPS     = 1 shl 24
  SD_BUS_CREDS_INHERITABLE_CAPS   = 1 shl 25
  SD_BUS_CREDS_BOUNDING_CAPS      = 1 shl 26
  SD_BUS_CREDS_SELINUX_CONTEXT    = 1 shl 27
  SD_BUS_CREDS_AUDIT_SESSION_ID   = 1 shl 28
  SD_BUS_CREDS_AUDIT_LOGIN_UID    = 1 shl 29
  SD_BUS_CREDS_TTY                = 1 shl 30
  SD_BUS_CREDS_UNIQUE_NAME        = 1 shl 31
  SD_BUS_CREDS_WELL_KNOWN_NAMES   = 1 shl 32
  SD_BUS_CREDS_DESCRIPTION        = 1 shl 33
  SD_BUS_CREDS_PIDFD              = 1 shl 34
  SD_BUS_CREDS_AUGMENT            = 1 shl 63 # special flag if on sd-bus will augment creds struct in a potentially race-full way
  _SD_BUS_CREDS_ALL               = (1 shl 35) -1

{.push header: "<systemd/sd-bus.h>".}
type
  sd_bus_error* {.importc: "struct sd_bus_error".} = object
    name*, message*: cstring
    need_free*: int32

  sd_bus_error_map* {.importc: "struct sd_bus_error_map".} = object
    name*: cstring
    code*: int32

opaque sd_bus
opaque sd_bus_message
opaque sd_bus_slot
opaque sd_bus_creds
opaque sd_bus_track

{.push importc.}
proc sd_bus_interface_name_is_valid*(p: cstring): bool
proc sd_bus_service_name_is_valid*(p: cstring): bool
proc sd_bus_member_name_is_valid*(p: cstring): bool
proc sd_bus_object_path_is_valid*(p: cstring): bool

proc sd_bus_default*(ret: ptr ptr sd_bus): int32
proc sd_bus_default_user*(ret: ptr ptr sd_bus): int32
proc sd_bus_default_system*(ret: ptr ptr sd_bus): int32

proc sd_bus_open*(ret: ptr ptr sd_bus): int32
proc sd_bus_open_with_description*(ret: ptr ptr sd_bus, description: cstring): int32
proc sd_bus_open_user*(ret: ptr ptr sd_bus): int32
proc sd_bus_open_user_with_description*(ret: ptr ptr sd_bus, description: cstring): int32
proc sd_bus_open_user_machine*(ret: ptr ptr sd_bus, machine: cstring): int32
proc sd_bus_open_system*(ret: ptr ptr sd_bus): int32
proc sd_bus_open_system_with_description*(ret: ptr ptr sd_bus, description: cstring): int32
proc sd_bus_open_system_remote*(ret: ptr ptr sd_bus, host: cstring): int32
proc sd_bus_open_system_machine*(ret: ptr ptr sd_bus, machine: cstring): int32

proc sd_bus_new*(ret: ptr ptr sd_bus): int32

proc sd_bus_set_address*(bus: ptr sd_bus, address: cstring): int32
proc sd_bus_set_fd*(bus: ptr sd_bus, input_fd: cint, output_fd: cint): int32
proc sd_bus_set_exec*(bus: ptr sd_bus, path: cstring, argv: ptr cstring): int32
proc sd_bus_get_address*(bus: ptr sd_bus, address: ptr cstring): int32
proc sd_bus_set_bus_client*(bus: ptr sd_bus, b: int32): int32
proc sd_bus_is_bus_client*(bus: ptr sd_bus): bool
proc sd_bus_set_server*(bus: ptr sd_bus, b: int32, bus_id: sd_id128_t)
{.pop.}

{.pop.}
