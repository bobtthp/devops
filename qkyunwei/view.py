from django.shortcuts import render
from django.http import HttpResponse,HttpResponseRedirect
import MySQLdb
def get_data(sql):
    conn = MySQLdb.connect(host='192.168.122.3', port=3306, user='root', passwd='bob.123', db='servicelist',charset='utf8')
    cursor = conn.cursor()
    #sql = 'select ip,pro_name from serverinfo'
    cursor.execute(sql)
    results = cursor.fetchall()
    cursor.close()
    conn.close()
    return results
def put_data(request):
    sql = 'select ip,pname from serverinfo'
    get_info = get_data(sql)
    return render(request,'servicelist.html',{'put_data':get_info})
def restart_pro(request):
    request.POST.get('name')


