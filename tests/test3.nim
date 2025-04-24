import std/[posix, os, times]
import pkg/libsystemd

echo getOwnerUid(getpid())
echo getUserState(1000)
echo getUserDisplay(1000)
echo getUserLoginTimeUnix(1000)
echo getUserLoginTime(1000)

for session in getUserSessions(1000):
  echo session
  echo getSessionUid(session)
