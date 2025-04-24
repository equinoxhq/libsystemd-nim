import std/posix
import libsystemd/bindings/prelude

var id: sd_id128
echo sd_id128_randomize(id.addr)

var buff: array[SD_ID128_STRING_MAX, char]
echo sd_id128_to_string(id, buff.addr)
