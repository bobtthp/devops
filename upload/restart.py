#!/usr/bin/python 
# -*- coding:utf-8 -*-
import os 
import sys
import time
sign = '-'
#重启方法
def restart_tomcat(webname):
	name = webname
	tomcat_name = name + '_tomcat'
	os.environ['tomcat_name'] = str(tomcat_name)  #python变量传入shell
	if webname in l:
		p = os.popen("ps -ef |grep $tomcat_name | grep -v grep |awk '{print $2}' ")
		pid = p.read().rstrip('\n')  #删掉回车
		if pid == '':
			time.sleep(3)
			os.system('/qingke/tomcats/${tomcat_name}/bin/startup.sh')
		else:
			time.sleep(3)
			os.environ['pid'] = str(pid)
			os.system('kill -9  $pid')
			os.system('/qingke/tomcats/${tomcat_name}/bin/startup.sh')
			
	else:
		print(sign * 60)
		print('---该项目不存在，请检查项目名称---')
		print(sign * 60)
		
if __name__ == "__main__":
	list = os.popen('ls /qingke/webapps')
	l = list.read()
	l = l.replace('\n',',')
	project_name = sys.argv[1] 
	restart_tomcat(project_name)