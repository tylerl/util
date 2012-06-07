/*
	netfwd.go: simple TCP proxy
	Listens for TCP connections on a local port. Upon connect opens TCP connection
	to specified remote address and proxies data bi-directionaly without examination.

	Copyright 2012 Tyler Larson
	Based on work by Roger Peppe <rogpeppe@gmail.com> found here: 
		https://groups.google.com/d/msg/golang-nuts/zzW0GL4AP3k/npDR_ekLlGcJ
	Slight improvements by Tyler Larson to close connections when appropriate.
	Original usenet post license unspecified. Updates license granted according to
		http://www.opensource.org/licenses/BSD-3-Clause

*/
package main 
import ( 
	"net" 
	"fmt" 
	"io" 
	"os" 
) 

func main() { 
	if len(os.Args) != 3 { 
		fatal("%s","usage: netfwd local remote") 
	} 
	localAddr := os.Args[1] 
	remoteAddr := os.Args[2] 
	local, err := net.Listen("tcp", localAddr) 
	if local == nil { 
		fatal("cannot listen: %v", err) 
	} 
	for { 
		conn, err := local.Accept() 
		if conn == nil { 
			fatal("accept failed: %v", err) 
		} 
		go forward(conn, remoteAddr) 
	} 
} 

func forward(local net.Conn, remoteAddr string) { 
	remote, err := net.Dial("tcp", remoteAddr) 
	if remote == nil { 
		fmt.Fprintf(os.Stderr, "remote dial failed for %s: %v\n", remoteAddr, err) 
		return 
	} 
	go func() {
		io.Copy(local, remote)
		local.Close()
	}()

	go func() {
		io.Copy(remote, local)
		remote.Close()
	}()
} 

func fatal(s string, a ... interface{}) { 
	fmt.Fprintf(os.Stderr, "netfwd: " + s + "\n", a...) 
	os.Exit(2) 
} 


