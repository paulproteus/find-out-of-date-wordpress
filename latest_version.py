import lxml.html
import urllib2

def main():
    fd = urllib2.urlopen('http://wordpress.org/download/')
    parsed = lxml.html.parse(fd).getroot()
    download_link = parsed.xpath("//a[@href='/latest.zip']")[0]
    latest_version = download_link.text_content().split()[-1]
    return latest_version

if __name__ == '__main__':
    print main()

