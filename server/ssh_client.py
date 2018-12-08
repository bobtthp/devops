import paramiko
import MySQLdb
import os
from xml.dom.minidom import parse

def ssh_cmd(ip,username,passwd,cmds):
    try:
        client = paramiko.SSHClient()
        client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        client.connect(ip,22,username=username,password=passwd,timeout=30)
        stdin,stdout,stdrr = client.exec_command(cmds)
        result = stdout.readlines()
        return result
    except Exception:
        return 'failed'
    finally:
        client.close()

def get_parameter(sql):
    conn = MySQLdb.connect(host='11.11.11.2', port=3306, user='bob', passwd='Gzq!@#123', db='servicelist',charset='utf8')
    cursor = conn.cursor()
    cursor.execute(sql)
    results = cursor.fetchall()
    cursor.close()
    conn.close()
    return results[0]

def upload_file(ip,Username,Passwd,local_path,remote_path):
    cmds = "[ -f '%s' ] &&  echo ok" % (remote_path)
    status = ssh_cmd(ip, Username, Passwd, cmds)
    #print status
    if status == 'ok':
        pass
    else:
        try:
            transport = paramiko.Transport((ip,22))
            transport.connect(username=Username,password=Passwd)
            sftp = paramiko.SFTPClient.from_transport(transport)
            sftp.put(local_path,remote_path)
        finally:
            sftp.close()

def download_file(ip,Username,Passwd,remote_path,local_path):
    try:
        transport = paramiko.Transport((ip, 22))
        transport.connect(username=Username, password=Passwd)
        sftp = paramiko.SFTPClient.from_transport(transport)
        sftp.get(remote_path, local_path)
    finally:
        sftp.close()
