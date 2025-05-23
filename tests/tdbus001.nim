import pkg/[pretty, libsystemd]

var sdbus = newBus()
  .connectToUserBus()
  .requestName("com.example.hello")

let names = sdbus.listAcquiredNames()
print names

let act = sdbus.listActivatableNames()
print act

while true:
  try:
    sdbus.processMessages()
  except BusError: break

sdbus.release("com.example.hello")
