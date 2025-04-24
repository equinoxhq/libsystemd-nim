import std/posix

type sd_login_monitor* {.
  importc: "struct sd_login_monitor", header: "<systemd/sd-login.h>"
.} = object

{.push header: "<systemd/sd-login.h>", importc.}
proc sd_pid_get_session*(pid: Pid, session: ptr cstring): int32
proc sd_pid_get_owner_uid*(pid: Pid, uid: ptr Uid): int32
proc sd_pid_get_unit*(pid: Pid, unit: ptr cstring): int32
proc sd_pid_get_user_unit*(pid: Pid, unit: ptr cstring): int32
proc sd_pid_get_slice*(pid: Pid, slice: ptr cstring): int32
proc sd_pid_get_user_slice*(pid: Pid, slice: ptr cstring): int32
proc sd_pid_get_machine_name*(pid: Pid, machine: ptr cstring): int32
proc sd_pid_get_cgroup*(pid: Pid, cgroup: ptr cstring): int32
proc sd_pidfd_get_session*(pidfd: cint, session: ptr cstring): int32
proc sd_pidfd_get_owned_uid*(pidfd: cint, uid: ptr Uid): int32
proc sd_pidfd_get_unit*(pidfd: cint, unit: ptr cstring): int32
proc sd_pidfd_get_user_unit*(pidfd: cint, unit: ptr cstring): int32
proc sd_pidfd_get_slice*(pidfd: cint, slice: ptr cstring): int32
proc sd_pidfd_get_user_slice*(pidfd: cint, slice: ptr cstring): int32
proc sd_pidfd_get_machine_name*(pidfd: cint, machine: ptr cstring): int32
proc sd_pidfd_get_cgroup*(pidfd: cint, cgroup: ptr cstring): int32
proc sd_peer_get_session*(fd: cint, session: ptr cstring): int32
proc sd_peer_get_owner_uid*(fd: cint, uid: ptr Uid): int32
proc sd_peer_get_unit*(fd: cint, unit: ptr cstring): int32
proc sd_peer_get_user_unit*(fd: cint, unit: ptr cstring): int32
proc sd_peer_get_slice*(fd: cint, slice: ptr cstring): int32
proc sd_peer_get_user_slice*(fd: cint, slice: ptr cstring): int32
proc sd_peer_get_machine_name*(fd: cint, machine: ptr cstring): int32
proc sd_peer_get_cgroup*(fd: cint, cgroup: ptr cstring): int32
proc sd_uid_get_state*(uid: Uid, state: ptr cstring): int32
proc sd_uid_get_display*(uid: Uid, session: ptr cstring): int32
proc sd_uid_get_login_time*(uid: Uid, usec: ptr uint64): int32
proc sd_uid_is_on_seat*(uid: Uid, require_active: int32, seat: cstring): int32
proc sd_uid_get_sessions*(
  uid: Uid, require_active: int32, sessions: ptr cstringArray
): int32

proc sd_uid_get_seats*(uid: Uid, require_active: int32, seats: ptr cstringArray): int32

proc sd_session_is_active*(session: cstring): int32
proc sd_session_is_remote*(session: cstring): int32
proc sd_session_get_state*(session: cstring, state: ptr cstring): int32
proc sd_session_get_uid*(session: cstring, uid: ptr Uid): int32
proc sd_session_get_username*(session: cstring, username: ptr cstring): int32
proc sd_session_get_seat*(session: cstring, seat: ptr cstring): int32
proc sd_session_get_start_time*(session: cstring, usec: ptr uint64): int32
proc sd_session_get_service*(session: cstring, service: ptr cstring): int32
proc sd_session_get_type*(session: cstring, `type`: ptr cstring): int32
proc sd_session_get_class*(session: cstring, clazz: ptr cstring): int32
proc sd_session_get_desktop*(session: cstring, desktop: ptr cstring): int32
proc sd_Session_get_display*(session: cstring, display: ptr cstring): int32
proc sd_session_get_leader*(session: cstring, leader: ptr Pid): int32
proc sd_session_get_remote_host*(session: cstring, remote_host: ptr cstring): int32
proc sd_session_get_remote_user*(session: cstring, remote_user: ptr cstring): int32
proc sd_session_get_tty*(session: cstring, display: ptr cstring): int32
proc sd_session_get_vt*(session: cstring, vtnr: ptr uint32): int32
proc sd_seat_get_active*(seat: cstring, session: ptr cstring, uid: ptr Uid): int32
proc sd_seat_get_sessions*(
  seat: cstring,
  ret_sessions: ptr ptr UncheckedArray[cstring],
  ret_uids: ptr UncheckedArray[cstring],
  ret_n_uids: ptr uint32,
): int32

proc sd_seat_can_multi_session*(seat: cstring): int32 {.deprecated.}
proc sd_seat_can_tty*(seat: cstring): int32
proc sd_seat_can_graphical*(seat: cstring): int32
proc sd_machine_get_class*(machine: cstring, clazz: ptr cstring): int32
proc sd_machine_get_ifindices*(
  machine: cstring, ret_ifindices: ptr UncheckedArray[cstring]
): int32

proc sd_get_seats*(seats: ptr UncheckedArray[cstring]): int32
proc sd_get_sessions*(sessions: ptr UncheckedArray[cstring]): int32
proc sd_get_uids*(users: ptr UncheckedArray[Uid]): int32
proc sd_get_machine_names*(machines: ptr UncheckedArray[cstring]): int32
proc sd_login_monitor_new*(category: cstring, ret: ptr ptr sd_login_monitor): int32
proc sd_login_monitor_unref*(
  category: cstring, ret: ptr sd_login_monitor
): ptr sd_login_monitor

proc sd_login_monitor_flush*(monitor: ptr sd_login_monitor): int32
proc sd_login_monitor_get_fd*(m: ptr sd_login_monitor): cint
proc sd_login_monitor_get_events*(m: ptr sd_login_monitor): int32
proc sd_login_monitor_get_timeout*(
  m: ptr sd_login_monitor, timeout_usec: ptr uint64
): int32

{.pop.}
