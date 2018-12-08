#coding:utf-8
import os
from email import encoders
from email.header import Header
from email.mime.text import MIMEText
from email.utils import parseaddr, formataddr
import smtplib

from_addr = 'gaozequn@qk365.com'
password = 'Gzq123321'
#to_addr = 'gaozequn@qk365.com'
smtp_server = 'smtp.exmail.qq.com'


def _format_addr(s):
    name, addr = parseaddr(s)
    return formataddr((Header(name, 'utf-8').encode(),addr.encode('utf-8') if isinstance(addr, unicode) else addr))
def toGBK(str):
    str.encode('gbk')
def dealinfo(subject,text,to_addr,to_name):
    msg = MIMEText(text, 'plain', 'utf-8')
    msg['From'] = _format_addr('bob <%s>' % from_addr)
    msg['To'] = _format_addr('%s <%s>' % (to_name,to_addr))
    msg['Subject'] = Header(subject).encode()
    return msg
def sendmail(subject,text,to_addr,to_name):
    msg = dealinfo(subject,text,to_addr,to_name)
    server = smtplib.SMTP(smtp_server, 25)
    server.set_debuglevel(1)
    server.login(from_addr, password)
    server.sendmail(from_addr, [to_addr], msg.as_string())
    server.quit()
    server.close()

sendmail('这是一次测试邮件','测试信息哦','gaozequn@qk365.com','测试')