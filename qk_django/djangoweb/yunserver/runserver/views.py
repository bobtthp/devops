#coding:utf-8
from django.shortcuts import render, redirect
from django.http import HttpResponse, HttpResponseRedirect, StreamingHttpResponse
from .models import Azurevm, Pentesting, Downlog
from .forms import openForm, downForm, azureForm
import os
import time
import threading


def index(request):
    welcome_string = 'Hello, World'
    return render(request, 'index.html', {'welcom_string': welcome_string})


def show(request):
    c_time = time.strftime('%H', time.localtime(time.time()))
    ftime = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
    show_list = Azurevm.objects.all()
    if request.method == 'POST':
        sql_command = request.POST['user_sql']
        pname = request.POST['pname']
        if sql_command:
            Azurevm.objects.filter(id=int(sql_command)).update(state=2, opened=1)
            os.system('echo   '+pname+' '+ftime+' is start'+'>>log.txt')
            return render(request, 'list.html', locals())
    else:
            return render(request, 'list.html', locals())


def ushow(request):
    show_list = Azurevm.objects.all()
    c_time = time.strftime('%H', time.localtime(time.time()))
    ftime = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
    if request.method == 'POST':
        close_sql = request.POST['close_sql']
        pname = request.POST['pname']
        if close_sql:
            Azurevm.objects.filter(id=int(close_sql)).update(state=3)
            Azurevm.objects.filter(id=int(close_sql)).update(closed=1)
            os.system('echo   ' + pname + ' ' + ftime + ' is closed' + '>>log.txt')
            return HttpResponseRedirect('/')
        else:
            return render(request, 'list.html', locals())


def sshow(request):
    c_time = time.strftime('%H', time.localtime(time.time()))
    ftime = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
    show_s = Azurevm.objects.all()
    if request.method == 'POST':
        close_sql = request.POST['yan_sql']
        if close_sql:
            Azurevm.objects.filter(id=close_sql).update(delayedoff=1)
            return redirect('/')
        else:
            return render(request, 'list.html', locals())


def command(request):
    if request.method == 'POST':
        password = request.POST['passwd']
        if password == 'qkyunwei':
            os.system('powershell C:\AZURE\arm\poweron.ps1')
            #os.system('powershell C:\AZURE\powershell\poweron-sim.ps1')
            return HttpResponseRedirect('/runserver/')

        else:
            return HttpResponseRedirect('/runserver/')
    else:
        return render(request, 'update.html')


def showtest(request):
    testlist = Pentesting.objects.all().order_by('proauth')
    return render(request, 'pentest.html', {'testlist': testlist})


def create(request):
    form = openForm(request.POST or None)
    context = {'form': form, }

    if form.is_valid():
        up = form.save(commit=False)
        upfiles = up
        upfiles.proname = form.cleaned_data.get('proname')
        upfiles.prourl = form.cleaned_data.get('prourl')
        upfiles.proauth = form.cleaned_data.get('proauth')
        upfiles.proqq = form.cleaned_data.get('proqq')
        upfiles.prohost = form.cleaned_data.get('prohost')
        upfiles.save()
        return redirect('/runserver/testshow')
    return render(request, 'create.html', locals())


def vmcreate(request):
    form = azureForm(request.POST or None)
    content = {'form': form,}
    if form.is_valid():
        up = form.save(commit=False)
        upfiles = up
        upfiles.resname = form.cleaned_data.get('college')
        upfiles.name = form.cleaned_data.get('name')
        if(upfiles.resname =='qingkeazuresim'):
            upfiles.vmtype = 1
        if (upfiles.resname == 'qingkeazuretest'):
            upfiles.vmtype = 2
        upfiles.ipaddr = form.cleaned_data.get('ipaddr')
        upfiles.save()
        return redirect('/')

    return render(request, 'vmcreate.html', locals())


def edit(request, pid):
    if pid:
        elist = Pentesting.objects.filter(id=str(pid))
    if request.method == 'POST':
        p = Pentesting.objects.get(id=pid)
        p.proname =request.POST['proname']
        p.prourl = request.POST['prourl']
        p.proauth = request.POST['proauth']
        p.proqq = request.POST['proqq']
        p.prohost = request.POST['prohost']
        p.save()
        return redirect('/runserver/testshow')
    return render(request, 'edit.html', locals())




def createLog(request):
    form = downForm(request.POST or None)
    context = {'form': form, }

    if form.is_valid():
        up = form.save(commit=False)
        upfiles = up
        upfiles.projectname = form.cleaned_data.get('projectname')
        upfiles.serverip = form.cleaned_data.get('serverip')
        upfiles.serverport = form.cleaned_data.get('serverport')
        upfiles.username = form.cleaned_data.get('username')
        upfiles.password = form.cleaned_data.get('password')
        upfiles.location = form.cleaned_data.get('location')
        upfiles.save()
        return redirect('/runserver/listlog')
    return render(request, 'addserver.html', locals())


def listlog(request):
    allserver = Downlog.objects.all()
    return render(request, 'serverlist.html', locals())


def logedit(request, pid):
    if pid:
        elist = Downlog.objects.filter(id=str(pid))
    if request.method == 'POST':
        p = Downlog.objects.get(id=pid)
        p.projectname =request.POST['projectname']
        p.serverip = request.POST['serverip']
        p.serverport = request.POST['serverport']
        p.username = request.POST['username']
        p.password = request.POST['password']
        p.location = request.POST['location']
        p.save()
        return redirect('/runserver/listlog')
    return render(request, 'logedit.html', locals())





















