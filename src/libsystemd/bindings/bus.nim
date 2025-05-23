## low-level bindings around systemd-bus
import std/posix
import pkg/libsystemd/bindings/[bus_types, bus_vtable, id128]

const
  SD_BUS_CREDS_PID* = 1 shl 0
  SD_BUS_CREDS_TID* = 1 shl 1
  SD_BUS_CREDS_PPID* = 1 shl 2
  SD_BUS_CREDS_UID* = 1 shl 3
  SD_BUS_CREDS_EUID* = 1 shl 4
  SD_BUS_CREDS_SUID* = 1 shl 5
  SD_BUS_CREDS_FSUID* = 1 shl 6
  SD_BUS_CREDS_GID* = 1 shl 7
  SD_BUS_CREDS_EGID* = 1 shl 8
  SD_BUS_CREDS_SGID* = 1 shl 9
  SD_BUS_CREDS_FSGID* = 1 shl 10
  SD_BUS_CREDS_SUPPLEMENTARY_GIDS* = 1 shl 11
  SD_BUS_CREDS_COMM* = 1 shl 12
  SD_BUS_CREDS_TID_COMM* = 1 shl 13
  SD_BUS_CREDS_EXE* = 1 shl 14
  SD_BUS_CREDS_CMDLINE* = 1 shl 15
  SD_BUS_CREDS_CGROUP* = 1 shl 16
  SD_BUS_CREDS_UNIT* = 1 shl 17
  SD_BUS_CREDS_SLICE* = 1 shl 18
  SD_BUS_CREDS_USER_UNIT* = 1 shl 19
  SD_BUS_CREDS_USER_SLICE* = 1 shl 20
  SD_BUS_CREDS_SESSION* = 1 shl 21
  SD_BUS_CREDS_OWNER_UID* = 1 shl 22
  SD_BUS_CREDS_EFFECTIVE_CAPS* = 1 shl 23
  SD_BUS_CREDS_PERMITTED_CAPS* = 1 shl 24
  SD_BUS_CREDS_INHERITABLE_CAPS* = 1 shl 25
  SD_BUS_CREDS_BOUNDING_CAPS* = 1 shl 26
  SD_BUS_CREDS_SELINUX_CONTEXT* = 1 shl 27
  SD_BUS_CREDS_AUDIT_SESSION_ID* = 1 shl 28
  SD_BUS_CREDS_AUDIT_LOGIN_UID* = 1 shl 29
  SD_BUS_CREDS_TTY* = 1 shl 30
  SD_BUS_CREDS_UNIQUE_NAME* = 1 shl 31
  SD_BUS_CREDS_WELL_KNOWN_NAMES* = 1 shl 32
  SD_BUS_CREDS_DESCRIPTION* = 1 shl 33
  SD_BUS_CREDS_PIDFD* = 1 shl 34
  SD_BUS_CREDS_AUGMENT* = 1 shl 63
    # special flag if on sd-bus will augment creds struct in a potentially race-full way
  SD_BUS_CREDS_ALL* = (1 shl 35) - 1

{.push header: "<systemd/sd-bus.h>", importc.}
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
proc sd_bus_open_user_with_description*(
  ret: ptr ptr sd_bus, description: cstring
): int32

proc sd_bus_open_user_machine*(ret: ptr ptr sd_bus, machine: cstring): int32
proc sd_bus_open_system*(ret: ptr ptr sd_bus): int32
proc sd_bus_open_system_with_description*(
  ret: ptr ptr sd_bus, description: cstring
): int32

proc sd_bus_open_system_remote*(ret: ptr ptr sd_bus, host: cstring): int32
proc sd_bus_open_system_machine*(ret: ptr ptr sd_bus, machine: cstring): int32

proc sd_bus_new*(ret: ptr ptr sd_bus): int32

proc sd_bus_set_address*(bus: ptr sd_bus, address: cstring): int32
proc sd_bus_set_fd*(bus: ptr sd_bus, input_fd: cint, output_fd: cint): int32
proc sd_bus_set_exec*(bus: ptr sd_bus, path: cstring, argv: ptr cstring): int32
proc sd_bus_get_address*(bus: ptr sd_bus, address: ptr cstring): int32
proc sd_bus_set_bus_client*(bus: ptr sd_bus, b: int32): int32
proc sd_bus_is_bus_client*(bus: ptr sd_bus): bool
proc sd_bus_set_server*(bus: ptr sd_bus, b: int32, bus_id: sd_id128): int32
proc sd_bus_is_server*(bus: ptr sd_bus, b: int32, bus_id: sd_id128): int32
proc sd_bus_set_anonymous*(bus: ptr sd_bus, b: int32): int32
proc sd_bus_is_anonymous*(bus: ptr sd_bus): int32
proc sd_bus_set_trusted*(bus: ptr sd_bus, b: int32): int32
proc sd_bus_is_trusted*(bus: ptr sd_bus): int32
proc sd_bus_set_monitor*(bus: ptr sd_bus, b: int32): int32
proc sd_bus_is_monitor*(bus: ptr sd_bus): int32
proc sd_bus_set_description*(bus: ptr sd_bus, description: cstring): int32
proc sd_bus_get_description*(bus: ptr sd_bus, description: ptr cstring): int32
proc sd_bus_negotiate_creds*(bus: ptr sd_bus, b: int32, creds_mask: uint64): int32
proc sd_bus_negotiate_timestamp*(bus: ptr sd_bus, b: int32): int32
proc sd_bus_negotiate_fds*(bus: ptr sd_bus, b: int32): int32
proc sd_bus_can_send*(bus: ptr sd_bus, typ: char): int32
proc sd_bus_get_creds_mask*(bus: ptr sd_bus, creds_mask: ptr uint64): int32
proc sd_bus_set_allow_interactive_authorization*(bus: ptr sd_bus, b: int32): int32
proc sd_bus_get_allow_interactive_authorization*(bus: ptr sd_bus): int32
proc sd_bus_set_exit_on_disconnect*(bus: ptr sd_bus, b: int32): int32
proc sd_bus_get_exit_on_disconnect*(bus: ptr sd_bus): int32
proc sd_bus_set_close_on_exit*(bus: ptr sd_bus, b: int32): int32
proc sd_bus_get_close_on_exit*(bus: ptr sd_bus): int32
proc sd_bus_set_watch_bind*(bus: ptr sd_bus, b: int32): int32
proc sd_bus_get_watch_bind*(bus: ptr sd_bus): int32
proc sd_bus_set_connected_signal*(bus: ptr sd_bus, b: int32): int32
proc sd_bus_get_connected_signal*(bus: ptr sd_bus): int32
proc sd_bus_set_sender*(bus: ptr sd_bus, sender: cstring): int32
proc sd_bus_get_sender*(bus: ptr sd_bus, ret: ptr cstring): int32

proc sd_bus_start*(bus: ptr sd_bus): int32

proc sd_bus_try_close*(bus: ptr sd_bus): int32 {.deprecated.}
proc sd_bus_close*(bus: ptr sd_bus): void

proc sd_bus_ref*(bus: ptr sd_bus): ptr sd_bus
proc sd_bus_unref*(bus: ptr sd_bus): ptr sd_bus
proc sd_bus_close_unref*(bus: ptr sd_bus): ptr sd_bus
proc sd_bus_flush_close_unref*(bus: ptr sd_bus): ptr sd_bus

proc sd_bus_default_flush_close*(): void

proc sd_bus_is_open*(bus: ptr sd_bus): int32
proc sd_bus_is_ready*(bus: ptr sd_bus): int32

proc sd_bus_get_bus_id*(bus: ptr sd_bus, id: ptr sd_id128): int32
proc sd_bus_get_scope*(bus: ptr sd_bus, scope: ptr cstring): int32
proc sd_bus_get_tid*(bus: ptr sd_bus, tid: ptr Pid): int32
proc sd_bus_get_owner_creds*(
  bus: ptr sd_bus, creds_mask: uint64, ret: ptr sd_bus_creds
): int32

proc sd_bus_send*(bus: ptr sd_bus, m: ptr sd_bus_message, cookie: ptr uint64): int32
proc sd_bus_send_to*(
  bus: ptr sd_bus, m: ptr sd_bus_message, destination: cstring, cookie: uint64
): int32

proc sd_bus_call*(
  bus: ptr sd_bus,
  m: ptr sd_bus_message,
  usec: uint64,
  ret_error: ptr sd_bus_error,
  reply: ptr ptr sd_bus_message,
): int32

# proc sd_bus_call_async*(bus: ptr sd_bus, slot: ptr ptr sd_bus_slot, m: ptr sd_bus_message, callback: sd_bus_message_handler_t, userdata: pointer, usec: uint64): int32

proc sd_bus_get_fd*(bus: ptr sd_bus): cint
proc sd_bus_get_events*(bus: ptr sd_bus): int32
proc sd_bus_get_timeout*(bus: ptr sd_bus, timeout_usec: ptr uint64): int32
proc sd_bus_process*(bus: ptr sd_bus, r: ptr ptr sd_bus_message): int32
proc sd_bus_process_priority*(
  bus: ptr sd_bus, max_priority: int64, r: ptr ptr sd_bus_message
): int32 {.deprecated.}

proc sd_bus_wait*(bus: ptr sd_bus, timeout_usec: uint64): int32
proc sd_bus_flush*(bus: ptr sd_bus): int32
proc sd_bus_enqueue_for_read*(bus: ptr sd_bus, m: ptr sd_bus_message): int32

proc sd_bus_get_current_slot*(bus: ptr sd_bus_slot): ptr sd_bus_slot
proc sd_bus_get_current_message*(bus: ptr sd_bus): ptr sd_bus_message
proc sd_bus_get_current_userdata*(bus: ptr sd_bus): pointer

# proc sd_bus_attach_event*(bus: ptr sd_bus, event: ptr sd_event, priority: int32): int32
proc sd_bus_detach_event*(bus: ptr sd_bus): int32
# proc sd_bus_get_event*(bus: ptr sd_bus): ptr sd_event

proc sd_bus_get_n_queued_read*(bus: ptr sd_bus, ret: ptr uint64): int32
proc sd_bus_get_n_queued_write*(bus: ptr sd_bus, ret: ptr uint64): int32

proc sd_bus_add_object_vtable*(bus: ptr sd_bus, slot: ptr ptr sd_bus_slot, path, iface: cstring, vtable: ptr sd_bus_vtable, userdata: pointer): int32

proc sd_bus_set_method_call_timeout*(bus: ptr sd_bus, usec: uint64): int32
proc sd_bus_get_method_call_timeout*(bus: ptr sd_bus, ret: ptr uint64): int32

proc sd_bus_pending_method_calls*(bus: ptr sd_bus): int32

proc sd_bus_slot_ref*(slot: ptr sd_bus_slot): ptr sd_bus_slot
proc sd_bus_slot_unref*(slot: ptr sd_bus_slot): ptr sd_bus_slot

proc sd_bus_slot_get_bus*(slot: ptr sd_bus_slot): ptr sd_bus
proc sd_bus_slot_set_description*(slot: ptr sd_bus_slot, description: cstring): int32
proc sd_bus_slot_get_description*(
  slot: ptr sd_bus_slot, description: ptr cstring
): int32

proc sd_bus_slot_get_floating*(slot: ptr sd_bus_slot): int32
proc sd_bus_slot_set_floating*(slot: ptr sd_bus_slot, b: int32): int32

proc sd_bus_slot_get_current_message*(slot: ptr sd_bus_slot): ptr sd_bus_message
proc sd_bus_slot_get_current_userdata*(slot: ptr sd_bus_slot): pointer

proc sd_bus_message_new*(
  bus: ptr sd_bus, message: ptr ptr sd_bus_message, typ: uint8
): int32

proc sd_bus_message_new_signal*(
  bus: ptr sd_bus, m: ptr ptr sd_bus_message, path, iface, member: cstring
): int32

proc sd_bus_message_new_signal_to*(
  bus: ptr sd_bus, m: ptr ptr sd_bus_message, destination, path, iface, member: cstring
): int32

proc sd_bus_message_new_method_call*(
  bus: ptr sd_bus, m: ptr ptr sd_bus_message, dest, path, iface, member: cstring
): int32

proc sd_bus_message_new_method_return*(
  call: ptr sd_bus_message, m: ptr ptr sd_bus_message
): int32

proc sd_bus_reply_method_return*(
  call: ptr sd_bus_message,
  types: cstring
): int32 {.varargs.}

proc sd_bus_message_new_method_error*(
  call: ptr sd_bus_message, m: ptr ptr sd_bus_message, e: ptr sd_bus_error
): int32

proc sd_bus_message_new_method_errno*(
  call: ptr sd_bus_message, m: ptr ptr sd_bus_message, error: int32, e: ptr sd_bus_error
): int32

proc sd_bus_message_ref*(m: ptr sd_bus_message): ptr sd_bus_message
proc sd_bus_message_unref*(m: ptr sd_bus_message): ptr sd_bus_message

proc sd_bus_message_seal*(
  m: ptr sd_bus_message, cookie: uint64, timeout_usec: uint64
): int32

proc sd_bus_message_get_type*(m: ptr sd_bus_message, typ: ptr uint8): int32
proc sd_bus_message_get_cookie*(m: ptr sd_bus_message, cookie: ptr uint64): int32
proc sd_bus_message_get_reply_cookie*(m: ptr sd_bus_message, cookie: ptr uint64): int32
proc sd_bus_message_get_priority*(
  m: ptr sd_bus_message, priority: ptr int64
): int32 {.deprecated.}

proc sd_bus_message_get_expect_reply*(m: ptr sd_bus_message): int32
proc sd_bus_message_get_auto_start*(m: ptr sd_bus_message): int32
proc sd_bus_message_get_allow_interactive_authorization*(m: ptr sd_bus_message): int32

proc sd_bus_message_get_signature*(m: ptr sd_bus_message, complete: int32): cstring
proc sd_bus_message_get_path*(m: ptr sd_bus_message): cstring
proc sd_bus_message_get_interface*(m: ptr sd_bus_message): cstring
proc sd_bus_message_get_member*(m: ptr sd_bus_message): cstring
proc sd_bus_message_get_destination*(m: ptr sd_bus_message): cstring
proc sd_bus_message_get_sender*(m: ptr sd_bus_message): cstring
proc sd_bus_message_get_error*(m: ptr sd_bus_message): ptr sd_bus_error
proc sd_bus_message_get_errno*(m: ptr sd_bus_message): int32

proc sd_bus_message_get_monotonic_usec*(m: ptr sd_bus_message, usec: ptr uint64): int32
proc sd_bus_message_get_realtime_usec*(m: ptr sd_bus_message, usec: ptr uint64): int32
proc sd_bus_message_get_seqnum*(m: ptr sd_bus_message, seqnum: ptr uint64): int32

proc sd_bus_message_get_bus*(m: ptr sd_bus_message): ptr sd_bus
proc sd_bus_message_get_creds*(m: ptr sd_bus_message): ptr sd_bus_creds

proc sd_bus_message_is_signal*(m: ptr sd_bus_message, iface, member: cstring): int32
proc sd_bus_message_is_method_call*(
  m: ptr sd_bus_message, iface, member: cstring
): int32

proc sd_bus_message_is_method_error*(m: ptr sd_bus_message, name: cstring): int32
proc sd_bus_message_is_empty*(m: ptr sd_bus_message): int32
proc sd_bus_message_has_signature*(m: ptr sd_bus_message, signature: cstring): int32

proc sd_bus_message_set_expect_reply*(m: ptr sd_bus_message, b: int32): int32
proc sd_bus_message_set_auto_start*(m: ptr sd_bus_message, b: int32): int32
proc sd_bus_message_set_allow_interactive_authorization*(
  m: ptr sd_bus_message, b: int32
): int32

proc sd_bus_message_set_destination*(m: ptr sd_bus_message, destination: cstring): int32
proc sd_bus_message_set_sender*(m: ptr sd_bus_message, sender: cstring): int32
proc sd_bus_message_set_priority*(
  m: ptr sd_bus_message, priority: int64
): int32 {.deprecated.}

proc sd_bus_message_append_basic*(m: ptr sd_bus_message, typ: uint8, p: pointer): int32
proc sd_bus_message_append_array*(
  m: ptr sd_bus_message, typ: uint8, p: pointer, size: uint64
): int32

proc sd_bus_message_append_array_space*(
  m: ptr sd_bus_message, typ: uint8, size: uint64, p: ptr pointer
): int32

proc sd_bus_message_append_array_iovec*(
  m: ptr sd_bus_message, typ: uint8, iov: ptr UncheckedArray[IOVec], n: uint32
): int32

proc sd_bus_message_append_array_memfd*(
  m: ptr sd_bus_message, typ: uint8, memfd: cint, offset: uint64, size: uint64
): int32

proc sd_bus_message_append_string_space*(
  m: ptr sd_bus_message, size: uint64, s: ptr cstring
): int32

proc sd_bus_message_append_string_iovec*(
  m: ptr sd_bus_message, iov: ptr UncheckedArray[IOVec], n: uint32
): int32

proc sd_bus_message_append_string_memfd*(
  m: ptr sd_bus_message, memfd: cint, offset, size: uint64
): int32

proc sd_bus_message_append_strv*(m: ptr sd_bus_message, l: ptr cstring): int32
proc sd_bus_message_open_container*(
  m: ptr sd_bus_message, typ: uint8, contents: ptr UncheckedArray[cstring]
): int32

proc sd_bus_message_close_container*(m: ptr sd_bus_message): int32
proc sd_bus_message_copy*(
  m: ptr sd_bus_message, source: ptr sd_bus_message, all: int32
): int32

proc sd_bus_message_read_basic*(m: ptr sd_bus_message, typ: uint8, p: pointer): int32
proc sd_bus_message_read_array*(
  m: ptr sd_bus_message, typ: uint8, p: var pointer, size: ptr uint64
): int32

proc sd_bus_message_read_strv*(m: ptr sd_bus_message, l: ptr ptr cstring): int32
proc sd_bus_message_read_strv_extend*(m: ptr sd_bus_message, l: ptr ptr cstring): int32
proc sd_bus_message_skip*(
  m: ptr sd_bus_message, types: ptr UncheckedArray[cstring]
): int32

proc sd_bus_message_enter_container*(
  m: ptr sd_bus_message, typ: uint8, contents: ptr UncheckedArray[cstring]
): int32

proc sd_bus_message_exit_container*(m: ptr sd_bus_message): int32
proc sd_bus_message_peek_type*(
  m: ptr sd_bus_message, typ: ptr uint8, contents: ptr UncheckedArray[cstring]
): int32

proc sd_bus_message_verify_type*(
  m: ptr sd_bus_message, typ: uint8, contents: ptr UncheckedArray[char]
): int32

proc sd_bus_message_at_end*(m: ptr sd_bus_message, complete: int32): int32
proc sd_bus_message_rewind*(m: ptr sd_bus_message, complete: int32): int32
proc sd_bus_message_sensitive*(m: ptr sd_bus_message): int32

proc sd_bus_message_dump*(m: ptr sd_bus_message, f: File, flags: uint64): int32

proc sd_bus_get_unique_name*(
  bus: ptr sd_bus, unique: cstring
): int32

proc sd_bus_request_name*(bus: ptr sd_bus, name: cstring, flags: uint64): int32
proc sd_bus_release_name*(bus: ptr sd_bus, name: cstring): int32
proc sd_bus_list_names*(
  bus: ptr sd_bus,
  acquired: ptr ptr UncheckedArray[cstring],
  activatable: ptr ptr UncheckedArray[cstring],
): int32

proc sd_bus_get_name_creds*(
  bus: ptr sd_bus, name: cstring, mask: uint64, creds: ptr ptr sd_bus_creds
): int32

proc sd_bus_get_name_machine_id*(
  bus: ptr sd_bus, name: cstring, machine: sd_id128
): int32

proc sd_bus_message_send*(m: ptr sd_bus_message): int32

{.pop.}
