## high-level wrapper for sd-login.h
import std/[net, posix, times]
import pkg/libsystemd/bindings/login

type
  SomePid* = SomeInteger | Pid
  SomeUid* = SomeInteger | Uid

  SessionState* {.pure.} = enum
    Offline = "offline"
    Lingering = "lingering"
    Online = "online"
    Active = "active"
    Closing = "closing"

proc free*(p: pointer): void {.importc, header: "<stdlib.h>".}

func toSessionState*(str: string): SessionState {.raises: [ValueError].} =
  case str
  of "offline":
    return SessionState.Offline
  of "lingering":
    return SessionState.Lingering
  of "online":
    return SessionState.Online
  of "active":
    return SessionState.Active
  of "closing":
    return SessionState.Closing
  else:
    raise newException(ValueError, "Unknown session state: " & str)

template getStringFromFunc(fn: untyped, arguments: untyped) =
  var cstr: cstring
  let code {.inject.} = fn(arguments, cstr.addr)

  let str {.inject.}: string = $cstr
  free(cstr)

  if str.len < 1 and code < 0:
    raise newException(OSError, $strerror(-code))

proc getSession*[T: SomePid](pid: T): string =
  getStringFromFunc(sd_pid_get_session, Pid(pid))

  str

proc getOwnerUid*[T: SomePid](pid: T): Uid =
  let code = sd_pid_get_owner_uid(Pid(pid), result.addr)

  if code < 0:
    raise newException(OSError, $strerror(-code))

proc getUnit*[T: SomePid](pid: T): string =
  getStringFromFunc(sd_pid_get_unit, Pid(pid))

  str

proc getUserUnit*[T: SomePid](pid: T): string =
  getStringFromFunc(sd_pid_get_user_unit, Pid(pid))

  str

proc getSlice*[T: SomePid](pid: T): string =
  getStringFromFunc(sd_pid_get_slice, Pid(pid))

  str

proc getUserSlice*[T: SomePid](pid: T): string =
  getStringFromFunc(sd_pid_get_user_slice, Pid(pid))

  str

proc getMachineName*[T: SomePid](pid: T): string =
  getStringFromFunc(sd_pid_get_machine_name, Pid(pid))

  str

proc getCgroup*[T: SomePid](pid: T): string =
  getStringFromFunc(sd_pid_get_cgroup, Pid(pid))

  str

proc getPeerSession*(socket: Socket): string =
  getStringFromFunc(sd_peer_get_session, socket.getFd().cint)

  str

proc getPeerOwnerUid*(socket: Socket): Uid =
  let code = sd_peer_get_owner_uid(socket.getFd().cint, result.addr)

  if code < 0:
    raise newException(OSError, $strerror(-code))

proc getPeerUnit*(socket: Socket): string =
  getStringFromFunc(sd_peer_get_unit, socket.getFd().cint)

  str

proc getPeerUserUnit*(socket: Socket): string =
  getStringFromFunc(sd_peer_get_user_unit, socket.getFd().cint)

  str

proc getPeerSlice*(socket: Socket): string =
  getStringFromFunc(sd_peer_get_slice, socket.getFd().cint)

  str

proc getPeerUserSlice*(socket: Socket): string =
  getStringFromFunc(sd_peer_get_user_slice, socket.getFd().cint)

  str

proc getPeerMachineName*(socket: Socket): string =
  getStringFromFunc(sd_peer_get_machine_name, socket.getFd().cint)

  str

proc getPeerCgroup*(socket: Socket): string =
  getStringFromFunc(sd_peer_get_cgroup, socket.getFd().cint)

  str

proc getUserState*[T: SomeUid](uid: T): SessionState =
  getStringFromFunc(sd_uid_get_state, Uid(uid))

  toSessionState(str)

proc getUserDisplay*[T: SomeUid](uid: T): string =
  getStringFromFunc(sd_uid_get_display, Uid(uid))

  str

proc getUserLoginTimeUnix*[T: SomeUid](uid: T): uint64 =
  let code = sd_uid_get_login_time(Uid(uid), result.addr)

  if code < 0:
    raise newException(OSError, $strerror(-code))

proc getUserLoginTime*[T: SomeUid](uid: T): times.Time =
  let unix = getUserLoginTimeUnix(uid)
  assert(
    unix < int64.high.uint64,
    "BUG: Current time is greater than what a 64-bit signed integer can represent.",
  )

  fromUnixFloat(unix.int64 / 1_000_000)

proc isUserOnSeat*[T: SomeUid](uid: T, seat: string, requireActive: bool = true): bool =
  bool(
    sd_uid_is_on_seat(
      Uid(uid), require_active = requireActive.int32, seat = seat.cstring
    )
  )

proc getUserSessions*[T: SomeUid](uid: T, requireActive: bool = true): seq[string] =
  var sessionsRaw: cstringArray
  let numSessions = sd_uid_get_sessions(
    Uid(uid), sessions = sessionsRaw.addr, require_active = requireActive.int32
  )

  if numSessions < 0:
    raise newException(OSError, $strerror(-numSessions))

  var sessions = newSeq[string](numSessions)
  for i in 0 ..< numSessions:
    sessions[i] = $sessionsRaw[i]

  move(sessions)

proc getUserSeats*[T: SomeUid](uid: T, requireActive: bool): seq[string] =
  var seatsRaw: cstringArray
  let numSeats = sd_uid_get_seats(
    Uid(uid), seats = seatsRaw.addr, require_active = requireActive.int32
  )

  if numSeats < 0:
    raise newException(OSError, $strerror(-numSessions))

  var seats = newSeq[string](numSeats)
  for i in 0 ..< numSeats:
    seats[i] = $seatsRaw[i]

  move(seats)

proc isSessionActive*(session: string): bool =
  bool(sd_session_is_active(session))

proc isSessionRemote*(session: string): bool =
  bool(sd_session_is_remote(session))

proc getSessionState*(session: string): SessionState =
  getStringFromFunc(sd_session_get_state, session.cstring)

  toSessionState(str)

proc getSessionUid*(session: string): Uid =
  let code = sd_session_get_uid(session.cstring, result.addr)

  if code < 0:
    raise newException(ValueError, $strerror(-code))
