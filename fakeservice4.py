#Example app - TCP Echo Server
#Make a TCP server in a process that handles multiple clients
#Echos back the data the client sent

#Imports
import logging
import multiprocessing
import socket
import select
from time import *

logging.basicConfig(format='%(levelname)s - %(asctime)s: %(message)s',datefmt='%H:%M:%S', level=logging.NOTSET)

#Server
def chatserver(ip, port):
	server = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
	logging.info(f'Binding to {ip}:{port}')
	server.bind((ip,port))
	server.setblocking(False)
	server.listen(100)
	logging.info(f'Listening on {ip}:{port}')

	readers = [server]

	while True:
		readable, writable, errored = select.select(readers,[],[],0.5)

		for s in readable:
			try:
				if s == server:
					client, address = s.accept()
					client.setblocking(False)
					readers.append(client)
				else:
					data = s.recv(1024)
					if data:
						s.send(data)
					else:
						s.close()
						readers.remove(s)

			except Exception as ex:
				logging.warning(ex.args)
			finally:
				pass

#Main
def main():
	svr = multiprocessing.Process(target=chatserver,args=["0.0.0.0",2069],daemon=True,name='Server')
	svr.start()
	
	while True:
		sleep(10)
	
"""    
	while True:
		svr.start()
		
        command = input('Enter a command (start, stop)')
        if command == 'start':
            logging.info('Starting the server')
            svr.start()
        if command == 'stop':
            logging.info('Stopping the server')
            svr.terminate()
            svr.join()
            svr.close()
            logging.info('Server stopped')

            break
    logging.info('Application finished')
"""
if __name__ == "__main__":
	main()