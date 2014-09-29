import subprocess
import time
import flask
import socket
import sys

app = flask.Flask(__name__)
PASSWORD="12345678901234567890123456789012"
PORT=8000


def _passthru(*args):
    process = subprocess.Popen(args, stdout=subprocess.PIPE)
    output, unused_err = process.communicate()
    process.poll()
    return output


def _cmd(label,*args):
    def fn():
        return "[%s]\n%s\n" % (label,_passthru(*args)) 
    return fn


def agent():
    components = [
        lambda: "[meta-1]\nmoment:%s\nversion:0.91\nsafe_mode:\n" % (int(time.time())),
        _cmd("top-1","uptime"),
        _cmd('sysinfo-1',"uname","-a"),
        _cmd("ram-1","cat","/proc/meminfo"),
        _cmd("traffic-1","cat","/proc/net/dev"),
        _cmd("dfdiskspace-1","df", "-P"),
    ]
    rtn = ""
    for component in components:
        rtn += str(component())
    return rtn


@app.errorhandler(404)
def h404(error):
    return "Not Found", 404


@app.route("/",methods=["GET","POST"])
def page():
    if flask.request.form.get('password','') == PASSWORD:
        response = flask.make_response(agent())
        response.headers['content-type']='text/plain'
        response.headers['X-Wormly-Version']='0.91'
        return response
    return "OK"


if __name__=="__main__":
    # test bind to see if we're already running -- if so then exit
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    try: s.bind(("0.0.0.0",PORT))
    except socket.error: sys.exit(0)
    s.close()
    # Remove the block above to forget about this check

    app.run(host="0.0.0.0",port=PORT)
