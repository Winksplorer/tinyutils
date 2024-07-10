# tinyutils

Just random linux utilities written in nostdlib NASM assembly. Mostly made for me to get gud at assembly.

> These have absolutely no error checking at all, so do **NOT** actually use this in production.

You can compile all of them by just running "make".

You can compile just one by specifying it's name like "tinyshutdown", for example: "make tinyshutdown"

# limitations
- no error checking
- tinyshutdown only shuts down or reboots, provide `-r` or actually any arguments and it will reboot.
- tinyyes can only say "y" or "n", not anything else like the GNU impl can. by default, it will say "y", but if you provide `-n` or actually any arguments then it will say "n".