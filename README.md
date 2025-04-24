# libsystemd
This is a work-in-progress library that provides raw bindings and safe* Nim wrappers around libsystemd, a library that can be used to interact with various components of the systemd project. This project aims to help Nim programs integrate better with a standard Linux desktop.

This library has no dependencies other than the Nim standard library.

# progress
## bindings
- [X] sd-id128.h
- [X] sd-login.h
- [ ] sd-bus.h

## wrappers
- [X] ID128
- [X] Login Functions
- [ ] Systemd Bus
