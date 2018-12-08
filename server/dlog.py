import paramiko
from django.http import HttpResponse,StreamingHttpResponse
import ssh_client
import os


def download(request):
    if request.method == 'GET':
        Pname = request.GET['pname']
        usual_username = 'qk365'
        usual_passwd = 'dzH8KLewRT49WWuNbESI'
        sql = "select ip,username,passwd,log_addr from server_info where project_name='%s'" % (Pname)
        ip, username, passwd,log_addr = ssh_client.get_parameter(sql)
        path = os.getcwd() + '\\tmp'
        if not os.path.exists(path):
            os.makedirs(path)
        log_name = Pname + '.log'
        accept_path = path + '\\' + log_name
        if not log_addr:
            log_addr = '/qingke/tomcats/%s_tomcat/logs/catalina.out' % Pname
        if username == None:
            username = usual_username
        if passwd == None:
            passwd = usual_passwd
        #print ip, username, passwd, log_addr, accept_path
        ssh_client.download_file(ip, username, passwd, log_addr, accept_path)
        log = open(accept_path,'rb')
        response = StreamingHttpResponse(log)
        response['Content-Type'] = 'application/octet-stream'
        response['Content-Disposition'] = 'attachment;filename=%s' % log_name
    return response