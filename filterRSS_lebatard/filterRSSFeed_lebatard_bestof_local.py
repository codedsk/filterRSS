import PyRSS2Gen as RSS2
import feedparser
import re

# dan lebatard, Best of and Local shows
infeed = 'http://espn.go.com/espnradio/podcast/feeds/itunes/podCast?id=9941853'
outfeed = 'rss.xml'
pattern = 'Best|Local'

d = feedparser.parse(infeed)

rss = RSS2.RSS2(
    title=d.feed['title'],
    link=d.feed['links'][0]['href'],
    description=d.feed['summary'],
    items = [
        RSS2.RSSItem(
            title = post['title'],
            link = post['link'],
            description = post['summary'],
            pubDate = post['published'],
            enclosure = RSS2.Enclosure(post['links'][1]['href'],post['links'][1]['length'],post['links'][1]['type']),
        )  for post in d.entries if re.search(pattern,post.title)
    ]
)

rss.write_xml(open(outfeed,"w"))


