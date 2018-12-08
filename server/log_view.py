# coding:utf-8
from django.shortcuts import render
from dwebsocket.decorators import accept_websocket
import websocket
import paramiko
import threading
import ssh_client
import time
import threading
from dwebsocket import websocket
@accept_websocket
def testlog(request):
    if not request.is_websocket():  
            return render(request, 'log.html')
    else:
         for message in request.websocket:
            if message is not None:
                service_id = message
                ip,port,username,project_name,passwd,log_addr = get_parameter(service_id)
                ssh = get_ssh(ip,port,username,passwd)
                chan = get_chan(ssh,project_name,log_addr)    #get ssh session
                while True:
                        while chan.recv_ready():
                            if request.websocket.has_messages():
                                chan.close()
                                ssh.close()
                                request.websocket.close()
                                print 'close websocket'
                                break
                            else:
                                log_msg = chan.recv(10000).strip()
                                request.websocket.send(log_msg)
                        if chan.exit_status_ready():
                            break


def get_ssh(ip,port,username,passwd):
    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh.connect(ip, port, username, passwd, timeout=30)
    return ssh
def get_chan(ssh,project_name,log_addr):
    print 'Project_name is %s, Log_addr is %s!!!' % (project_name,log_addr)
    ssh_t = ssh.get_transport()
    chan = ssh_t.open_session()
    chan.setblocking(0)  
    if log_addr == None:
        log_command = 'tail -f -n 1  /qingke/tomcats/%s_tomcat/logs/catalina.out' % (project_name) #one line once
    else:
        log_command = 'tail -f -n 1 %s' % (log_addr)
    chan.exec_command(command=log_command)
    return chan
def get_parameter(service_id):
    usual_username = 'qk365'
    usual_passwd = 'dzH8KLewRT49WWuNbESI'
    sql = "select ip,port,username,project_name,passwd,log_addr from server_info where id='%s'" % (service_id)
    ip,port,username,project_name,password,log_addr = ssh_client.get_parameter(sql)
    if username == None:
        username = usual_username
    if password == None:
        password = usual_passwd
    return ip,port,username,project_name,password,log_addr
