import logging
import logging.handlers
import psycopg2

from wsgiref.simple_server import make_server, WSGIServer
from SocketServer import ThreadingMixIn

# Create logger
logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)

# Handler 
LOG_FILE = '/tmp/sample-app/sample-app.log'
handler = logging.handlers.RotatingFileHandler(LOG_FILE, maxBytes=1048576, backupCount=5)
handler.setLevel(logging.INFO)

# Formatter
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')

# Add Formatter to Handler
handler.setFormatter(formatter)

# add Handler to Logger
logger.addHandler(handler)

welcome = '''
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>Welcome</title>
  <style>
  </style>
</head>
<body id="sample">
  {0} </br>
</body>
</html>
'''

def application(environ, start_response):
    path    = environ['PATH_INFO']
    method  = environ['REQUEST_METHOD']
    conn  = psycopg2.connect(environ['DATABASE_URL'])
    cur = conn.cursor()
    cur.execute("SELECT datname FROM pg_database;")
    result = cur.fetchall()
    stringout = ""
    for row in result:
        print("   ", row[0])
        stringout = stringout + ";" + row[0]
    if method == 'POST':
        try:
            if path == '/':
                request_body_size = int(environ['CONTENT_LENGTH'])
                request_body = environ['wsgi.input'].read(request_body_size)
                logger.info("Received message: %s" % request_body)
            elif path == '/scheduled':
                logger.info("Received task %s scheduled at %s", environ['HTTP_X_AWS_SQSD_TASKNAME'], environ['HTTP_X_AWS_SQSD_SCHEDULED_AT'])
        except (TypeError, ValueError):
            logger.warning('Error retrieving request body for async work.')
        response = ''
    else:
        response = welcome.format(stringout)
    status = '200 OK'
    headers = [('Content-type', 'text/html')]

    start_response(status, headers)
    cur.close()
    conn.close()
    return [response]

class ThreadingWSGIServer(ThreadingMixIn, WSGIServer): 
    pass

if __name__ == '__main__':
    httpd = make_server('', 8000, application, ThreadingWSGIServer)
    print "Serving on the port 8000..."
    httpd.serve_forever()
