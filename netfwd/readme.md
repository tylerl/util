# netfwd.go: simple TCP proxy

Listens for TCP connections on a local port. Upon connect opens TCP connection
to specified remote address and proxies data bi-directionaly without examination.

Example: the following listens for connections on 127.0.0.1 port 8000 and proxies
those connections to 1.2.3.4 port 80.

    netfwd 127.0.0.1:8000 1.2.3.4:80


*Pre-built binaries for i386 and x86_64 can be found in the bin/ directory for people
who do not have a `go` compiler handy.
