class Formaterror(Exception):
    logfile = 'C:\\Users\\pc\\Desktop\\test.log'
    def __init__(self,line,file):
        self.line = line
        self.file = file
    def logerror(self):
        log = open(self.logfile,'a')
        print >> log ,'Error at,%s,%s' % (self.file,self.line)

def parser():
    raise Formaterror(40,'a.txt')
try:
        parser()
except Formaterror as exc:
    exc.logerror()


