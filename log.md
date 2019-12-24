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

## Parse web pages for images and information
We will get all of the image names and alt text (and whatever else)
I will add a table for images later.  First is just get all the web pages 

```
CREATE DATABASE webpage_images;
USE webpage_images;

CREATE TABLE `tbl_webpages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `folder` varchar(99) DEFAULT NULL COMMENT 'The folder and path from the main directory of the website.',
  `file_name` varchar(50) DEFAULT NULL COMMENT 'The file name of the htm webpage.',
  `title` varchar(99) DEFAULT NULL COMMENT 'The title of the webpage',
  
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='Contains the list of webpages for the website.';



CREATE USER 'webpage_images_user'@'localhost' IDENTIFIED BY '---a-password---';
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE, SHOW VIEW ON webpage_images.* TO 'webpage_images_user'@'localhost';


ALTER USER 'webpage_images_user'@'localhost' IDENTIFIED WITH mysql_native_password BY '---a-password---';
```
MySQL cnf

```
[webpage_images]
user=webpage_images_user
password=---a-password---
host=127.0.0.1
port=3306
database=webpage_images
```

## image search
https://www.pyimagesearch.com/2017/11/27/image-hashing-opencv-python/

## Results:
3	14	13:34:47	SELECT * FROM webpage_images.tbl_webpages
 LIMIT 0, 5000	4418 row(s) returned	0.016 sec / 0.000 sec
 
I am wondering why wget had 4420 files and my process imports 4418

```
CREATE TABLE `tbl_webpage_images` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_webpage` int(11) DEFAULT NULL COMMENT 'The id of the row for the webpage in tbl_webpages.',
  `folder` varchar(99) DEFAULT NULL COMMENT 'The folder and path from the main directory of the website for the web page the image appears on.',
  `img_src` varchar(99) DEFAULT NULL COMMENT 'The src (folder and file name) of the image as it appears on the web page.',
  `img_alt` varchar(1000) DEFAULT NULL COMMENT 'The alt text of the image.',
  `img_height` decimal(10,0) DEFAULT NULL COMMENT 'The height of the image as noted on the web page.',
  `img_width` decimal(10,0) DEFAULT NULL COMMENT 'The width of the image as noted on the web page.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Contains the list of images that appear on webpages for the website.';
```

### Box.com
I likely need to log into box.com to get other images
I will have to do that automated
https://github.com/box/box-python-sdk

Azure
https://docs.microsoft.com/en-us/azure/machine-learning/service/how-to-create-register-datasets


python mariadb
https://mariadb.com/resources/blog/how-to-connect-python-programs-to-mariadb/
