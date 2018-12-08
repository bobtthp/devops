import ssh_client
import json
from django.http import HttpResponse
from django.shortcuts import render
from django.shortcuts import HttpResponseRedirect
server = {
    'bob' : {
        'ip' :'11.11.11.2',
        'username' : 'root',
        'password' : 'gzq123'
    }
}
def api(request):
    if request.method == 'GET':
        cmds = 'python /opt/kvm.py data_api'
        arg = server['bob']
        info = ssh_client.ssh_cmd(arg['ip'], arg['username'], arg['password'], cmds)[0]
        info = eval(info)['list']
        #return HttpResponse(json.dumps(info),content_type="application/json")
    return render(request, 'kvm.html', {'info':info,'ip':arg['ip']})
def start(request):
    if request.method == 'POST':
        domain_name = request.POST.get('domain_name')
        cmds = 'python /opt/kvm.py start_api %s' % domain_name
        arg = server['bob']
        ssh_client.ssh_cmd(arg['ip'], arg['username'], arg['password'], cmds)
        return HttpResponseRedirect("/servicelist/kvm")
    else:
        return HttpResponseRedirect("/servicelist/kvm")
def stop(request):
    if request.method == 'POST':
        domain_name = request.POST.get('domain_name')
        cmds = 'python /opt/kvm.py stop_api %s' % domain_name
        arg = server['bob']
        ssh_client.ssh_cmd(arg['ip'], arg['username'], arg['password'], cmds)
        return HttpResponseRedirect("/servicelist/kvm")
    else:
        return HttpResponseRedirect("/servicelist/kvm")
def restart(request):
    if request.method == 'POST':
        domain_name = request.POST.get('domain_name')
        cmds = 'python /opt/kvm.py restart_api %s' % domain_name
        arg = server['bob']
        ssh_client.ssh_cmd(arg['ip'], arg['username'], arg['password'], cmds)
        return HttpResponseRedirect("/servicelist/kvm")
    else:
        return HttpResponseRedirect("/servicelist/kvm")


