# Pompeii images

## Gather content from Pompeii in pictures
https://pompeiiinpictures.com/pompeiiinpictures/index.htm

Plan:
Get html files from website in a respectful manner.
Parse HTML for image tags and alt tage content, store that as data.
Pass images through an Azure image recognition 

### use Scrapy to download html
I selected Scrapy since it can be used as a spider. 

#### Scapy tutorials
https://www.datacamp.com/community/tutorials/making-web-crawlers-scrapy-python
https://www.analyticsvidhya.com/blog/2017/07/web-scraping-in-python-using-scrapy/

I installed scapy using
```
pip install scrapy
```
