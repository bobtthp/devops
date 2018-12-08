from xml.dom.minidom import parse
import sys
if __name__ == "__main__":
        project_name = sys.argv[1]
        file_path = '/qingke/tomcats/%s_tomcat/conf/server.xml' % (project_name)
        config_file = parse(file_path)
        for attr in config_file.getElementsByTagName('Connector'):
		if attr.getAttribute('protocol') == 'HTTP/1.1':
			port = attr.getAttribute('port')
        for attr in config_file.getElementsByTagName('Context'):
                path = attr.getAttribute('path')
                docBase = attr.getAttribute('docBase')
        print (port,path,docBase)
