from django.http import HttpResponse
from django.shortcuts import render
def upanme(request):
    if request.method == 'GET':
        pname = request.GET['pname']
    return render(request,'update.html',{'pname':pname})
def commit(request):
    return HttpResponse('ok')