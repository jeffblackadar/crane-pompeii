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

## Local processing of images
The program that processes the images runs on Google Colab - but I can only run it for a short period of time. Google Colab does not permit long running processes.  So I made a version to run on my PC and store the results into the database rather than the google Spreadsheet. This is called pompeii_image_seeer_local_pc.ipynb

I ran pompeii_image_seeer_local_pc.ipynb to completion - 64k of 69,000 impages processed.  I have to move in the 5000 images I processed on Google Colab stored on the spreadsheet

box_images_processing.ipynb ran, connected to box.com with authentication, get a list of images and stored them into the database webpage_images.tbl_box_images.

### Probable duplicates between webpage_images.tbl_box_images and webpage_images.tbl_webpage_images
I think all of the images on box in the folder pinp5 are already processed.  I want to match them based on path
webpage_images.tbl_box_images:
/pinp5/Altars/Altars/Altar 10110_files/image001.jpg

webpage_images.tbl_webpage_images:
/pompeiiinpictures/Altars + Altar%2050301_files/image007.jpg

It's close, but I need to replace %20 with space and remove the repeated folder name in tbl_box_images.  So I will do that.
Once done, I won't process the matched images

This is done with update img_path_match.ipynb

### Match up the box images with the web pages already processed.
update webpage_images.tbl_box_images bi
inner join webpage_images.tbl_webpage_images wi on
    bi.img_path_match = wi.img_path_match
set bi.id_tbl_webpage_images = wi.id
WHERE bi.id < 10 and wi.id < 10;


### Processing other images on box
I plan to connect to box, download a thumbnail of a max 320 pixels and image hash that.  I think it will be faster, save bandwidth and have the same result since the image hash reduces images to 8X9 pixels.  According to the API documentation and a test download that is doable.

### SQL to get matched images

```
use webpage_images;

insert into webpage_images.tbl_image_hash (image_hash, wi_id, bi_id)
select distinct image_hash, wi_id, bi_id
from (
    select image_hash, id as wi_id , 0 as bi_id from tbl_webpage_images
    union all
    select image_hash, 0 as wi_id, id as bi_id from tbl_box_images
) a 
where image_hash
order by image_hash;

```
The above SQL makes a table of all of the image_hashes.  I would like a table with only those that occur more than once. So below I try to delete
```


CREATE TEMPORARY TABLE single_image_hashes3(
    id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    image_hash DEC(20,0) DEFAULT NULL
);

insert into single_image_hashes3 (image_hash) SELECT image_hash FROM webpage_images.tbl_image_hash group by image_hash having count(image_hash)=1;

select image_hash from single_image_hashes3;
SET SQL_SAFE_UPDATES = 0;
DELETE FROM tbl_image_hash WHERE image_hash IN (select image_hash from single_image_hashes2 where image_hash>0);

```
The use of the 320 pixel wide large thumbnail to do the image hash for the box images did not work.
It resulted in image hashs that are different for the same images at full size. 
So I am re-running the image hash for box, it's slow.
I am going to see if I run this on other machines.
 
# Set up MySQL on Carleton Server
per:
https://support.rackspace.com/how-to/install-mysql-server-on-the-ubuntu-operating-system/
sudo apt-get update
sudo apt-get install mysql-server

## Launch MySQL
sudo systemctl start mysql

sudo mysql_secure_installation utility
Set a root password
Removed anonymous access


sudo /usr/bin/mysql -u root -p

CREATE DATABASE `webpage_images` /*!40100 DEFAULT CHARACTER SET utf8 */; 

 

USE webpage_images; 


CREATE USER 'webpage_images_user'@'localhost' IDENTIFIED BY '====='; 
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE, SHOW VIEW ON webpage_images.* TO 'webpage_images_user'@'localhost'; 

Downloading all files to Carleton
Transferrring processing there
 

