# Pompeii images

## Gather content from Pompeii in pictures
https://pompeiiinpictures.com/pompeiiinpictures/index.htm

Plan:
Get html files from website in a respectful manner.
Parse HTML for image tags and alt tage content, store that as data.
Pass images through an Azure image recognition 

## Don't use Scrapy on Windows with Python 3

### use Scrapy to download html
I selected Scrapy since it can be used as a spider. 

#### Scapy tutorials
https://www.datacamp.com/community/tutorials/making-web-crawlers-scrapy-python
https://www.analyticsvidhya.com/blog/2017/07/web-scraping-in-python-using-scrapy/

I installed scapy using
```
pip install scrapy
```
---> Scappy does not work on Windows with Python 3 and I refuse to use Python 2
http://doc.scrapy.org/en/1.1/intro/install.html
So this is a dead end.

Maybe I should just wget it from my other computer and then crank through the html files and parse them (which I can do already.) I only want to get these files once, but I will likely parse them many times.

### Use Wget
Open Bash on Windows PC
go to 
/mnt/c/a_orgs/carleton/hist3814/R/pompeii/html
wget --mirror --accept html,htm --wait 20 --limit-rate=20k --random-wait http://ottawahort.org

FINISHED --2019-12-20 23:09:55--
Total wall clock time: 2d 7h 1m 44s
Downloaded: 4420 files, 282M in 3h 57m 43s (20.3 KB/s)
pi@User-PC:/mnt/c/a_orgs/carleton/hist3814/R/pompeii/website$ wget --mirror --accept html,htm --wait 20 --limit-rate=20k --random-wait https://pompeiiinpictures.com/

## image search
https://www.pyimagesearch.com/2017/11/27/image-hashing-opencv-python/
