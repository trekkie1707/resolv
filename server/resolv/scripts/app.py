from flask import Flask
from flask import request
import subprocess, os

app = Flask(__name__)

oldIP = ""


@app.route("/")
def restartWithNewIP():
    global oldIP
    newIP = request.args.get("ip", "-1")
    if newIP != oldIP and newIP != "-1":
        oldIP = newIP
        subprocess.run(
            [
                "cp",
                "/docker-entrypoint.d/20-envsubst-on-templates.sh",
                "/docker-entrypoint.d/mod-envsubst-on-templates.sh",
            ]
        )
        subprocess.run(
            [
                "sed",
                "-i",
                "s/>\\&3/>\\&1/g",
                "/docker-entrypoint.d/mod-envsubst-on-templates.sh",
            ]
        )
        my_env = os.environ.copy()
        my_env["SERVER_IP"] = newIP
        subprocess.run(
            ["/docker-entrypoint.d/mod-envsubst-on-templates.sh"], env=my_env
        )
        subprocess.run(["nginx", "-s", "reload"])

    return newIP
