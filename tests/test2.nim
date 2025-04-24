import pkg/libsystemd

var id: ID128
id.randomize()

echo $id
echo $getBootID()
echo $getMachineID()
