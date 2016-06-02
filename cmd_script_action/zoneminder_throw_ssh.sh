# where 3 is the monitor you want to interact
# -a active alarm
ssh root@zoneminder 'zmu -m 3 -a' &
# -c cancel it
ssh root@zoneminder 'zmu -m 5 -c' &
