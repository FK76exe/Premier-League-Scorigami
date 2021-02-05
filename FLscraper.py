from urllib.request import urlopen as uReq
from bs4 import BeautifulSoup as soup
import bs4
import re

f = open("EPLresults.csv","a")

for year in range(1992,1995):
    for week in range(1,43):
        url = "https://www.worldfootball.net/schedule/eng-premier-league-{}-{}-spieltag/{}/".format(year,year+1,week)
        uClient = uReq(url) #opens connection and downloads page
        page_html = uClient.read() #reads file
        uClient.close() #closes connection
        page_soup = soup(page_html,"html.parser") #parses the html code
        cols = page_soup.findAll("table",{"class":"standard_tabelle"})[0]
        cols = cols.findAll("tr")
        lst = []
        for c in cols:
            sepNewline = c.text.split('\n')
            for s in sepNewline:
                if s == '':
                    sepNewline.remove(s)
            lst.append(sepNewline)

        for x in lst:
            joined = " ".join(x)
            homeS,awayS = re.findall("\s*([0-9]*:[0-9]*)\s\(",joined)[0].split(":")
            # homeT = re.findall(":[0-9]{2}\s(.*)\s*-",joined) if time exists
            homeT = re.findall("(\w{1,}\s\w{1,})\s*-",joined) 
            awayT = re.findall("-\s*([A-z\s&]*)",joined)
            try:
                f.write("{}/{},{},{},{},{},{}\n".format(year,year+1,week,homeT[0],awayT[0],homeS,awayS))
            except:
                pass
        print(year,year+1,week)