from django.shortcuts import render
from server.models import Service
import ssh_client
from django.http import HttpResponse
from django.http import JsonResponse
def index(request):
    if request.method == 'GET':
        return render(request,'index.html')
    else:
        return render(request, 'index.html')
def listinfo(request):
    get_info = Service.objects.all()
    if request.method == 'POST':
        upload_path = 'C:\Users\pc\Desktop\qkyunwei\upload\\restart.py'
        accept_path = '/tmp/restart.py'
        usual_username = 'qk365'
        usual_passwd = 'dzH8KLewRT49WWuNbESI'
        pname = request.POST['pname']
        service_id = request.POST['service_id']
        cmds = 'python /tmp/restart.py %s' % (pname)
        sql = "select ip,username,passwd from server_info where id='%s'" % (service_id)
        ip,username,password = ssh_client.get_parameter(sql)
        if username == None:
            username = usual_username
        if password == None:
            password = usual_passwd
        ssh_client.upload_file(ip,username,password,upload_path,accept_path)
        ssh_client.ssh_cmd(ip,username,password,cmds)
        return render(request,'list.html',locals())
    else:
        return render(request,'list.html',locals())


def pinfo(request):
    if request.method == 'GET':
        id = request.GET.get('id')
        usual_username = 'qk365'
        usual_passwd = 'dzH8KLewRT49WWuNbESI'
        upload_path = 'C:\Users\pc\Desktop\qkyunwei\upload\\getinfo.py'
        accept_path = '/tmp/getinfo.py'
        sql = "select ip,username,project_name,passwd from server_info where id='%s'" % (id)
        ip,username,project_name,password = ssh_client.get_parameter(sql)
        if username == None:
            username = usual_username
        if password == None:
            password = usual_passwd
        cmds = 'python /tmp/getinfo.py %s' % (project_name)
        ssh_client.upload_file(ip, username, password, upload_path, accept_path)
        info = ssh_client.ssh_cmd(ip, username, password, cmds)[0]
        info = eval(info)
        print  info[0],info[1],info[2]
        dict = {
            "project_name" : project_name,
            "port" : info[0],
            "path" : info[1],
            "docBase" : info[2],
            "url" : 'http://' + ip + ':' + info[0] + info[1]
        }

    return JsonResponse(dict)