# Proxy server for kerberized Prmetheus endpints
from http.server import BaseHTTPRequestHandler, HTTPServer
import requests
import ssl
import argparse
import logging
from requests_gssapi import HTTPSPNEGOAuth

# args: local_hostname listen_port url tls_key_file, tls_cert_file

parser = argparse.ArgumentParser()
parser.add_argument("--hostname", help="")
parser.add_argument("--port", help="")
parser.add_argument("--url", help="")
parser.add_argument("--tls_key", help="")
parser.add_argument("--tls_cert", help="")

args = parser.parse_args()

logging.basicConfig(format='%(asctime)s,%(msecs)d %(levelname)-8s [%(filename)s:%(lineno)d] %(message)s',
                    datefmt='%Y-%m-%d:%H:%M:%S', level=logging.INFO)


class MetricServer(BaseHTTPRequestHandler):
    def do_GET(self):
        response = requests.get(endpoint, auth=HTTPSPNEGOAuth())
        if response.status_code == 200:
            # remove single quote from metric names, prometheus does not like this.
            clean_metrics = response.text.replace("'", "")
            self.send_response(200)
            self.send_header("Content-type", "text/plain")
            self.end_headers()
            self.wfile.write(bytes(clean_metrics, "utf-8"))
        else:
            logging.info(f"Server ERROR received: { response.text }")
            self.send_response(500)
            self.send_header("Content-type", "text/plain")
            self.end_headers()
            

if __name__ == "__main__":
    global endpoint
    endpoint = args.url
    
    httpd = HTTPServer((args.hostname, int(args.port)), MetricServer)
    
    httpd.socket = ssl.wrap_socket(httpd.socket, keyfile=args.tls_key,
                                   certfile=args.tls_cert, server_side=True)
    
    logging.info("Server Starting.")
    try:
        httpd.serve_forever()
    except KeyboardInterrupt as e:
        logging.error(f"Server error: { e }")
        pass

    httpd.server_close()
    logging.info("Server stopped.")