import pkg/libsystemd/bus

var bus = newBus()
  .connectToUserBus()
  .requestName("com.example.hello", "/com/example/Hello")
  .registerMethod(
    "SayHello",
    proc(m: ptr sd_bus_message, userdata: pointer, ret_error: ptr sd_bus_error): cint {.cdecl.} =
      return sd_bus_reply_method_return(m, "s".cstring, "Hallo :3".cstring)
  )

while bus.running:
  bus.processMessages()
