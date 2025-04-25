{.passC: gorge("pkg-config --cflags libsystemd").}
{.passL: gorge("pkg-config --libs libsystemd").}

import pkg/libsystemd/bindings/[id128, login, bus, bus_vtable, bus_types]

export id128, login, bus, bus_vtable, bus_types
