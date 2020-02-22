# CRANE Pompeii in Pictures subproject.

This is draft and in rough form. 

## Project Objective

The website pompeiiinpictures has a large number of images of Pompeii. This project will classify the images in order to find duplicates and also create a set of training images for a machine model of what walls in pompeii look like.

### Approach

All of the html files are downloaded to a local computer for processing using wget.

Use 0_get_webpages_from_local_and_store_in_database.R to read all of the .html files from the website and their file names into the database webpage_images.tbl_webpages.

Use 1_get_image_data_from_webpages_and_store_in_database.R to open all of the .html files parse them, get all of the img tags. For each img tag, insert the src, alt, height and width into the database webpage_images.tbl_webpage_images.

pompeii_image_seeer_local_pc.ipynb - process each image, get descriptions from Azure cognitive services, get the image hash and store both.

dupe_finder.ipynb - A program to find the duplicate images in a sample of the results from pompeii_image_seeer_local_pc.ipynb using the Google Spreadsheet

sample_duplicates.htm - is a sample from dupe_finder.ipynb  There are some false duplicates in the sample.  Part of the work of the project will control for this using image descriptions.

box application - a configured application on box.com to authenticate and connect to the box.com API.

box_images_processing.ipynb - Authenticates with Box.com to get a list of all of the image files and store them in the database into webpage_images.tbl_box_images.

update img_path_match.ipynb - Run this to update the img_path_match column for tbl_webpage_images and tbl_box_images.

---
Problems 17 Feb 2020

Images were downloaded and being appended with .jpg.  This does not work for .gif, .png, .tif
Cure - re-run this





### Project Assumptions

The primary task of matching images is to match lower resolution images on pompeiiinpictures to higher resolution images stored in box.com. 

More than half of the 100K images on box.com won't be matched to images on the website.

All of the images on pompeiiinpictures are referenced using the html tag *img*.

### Project Risks

##### Higher resolution images on box.com are not to be published

Impact: high - negative reputation for the project.

###### Control:

high resolution images will be downloaded to a local PC only and only temporarily.

Change of occurence: low.

##### Loss of data

Impact: high. If source images are lost it would be a catastrophe. If generated data for the images are lost it would mean reprocessing which is timeconsuming and expensive. 

###### Controls:

Access box.com using a read-only account

Access the website using only public http.

Do not use FTP to access the website and box.com.  FTP is not secure.

Backup MySQL database.

Use GitHub to store code.

Change of occurence: low.


##### Processing will take too long

Impact: high. The project would not be complete.

###### Control:

Run samples of duplicate images to provide some information at the project proceeds.

Design code to run on more than 1 workstation at a time. (done.)

##### Describing images in Azure will cost too much

Impact: Medium. Describing the images is optional.

###### Controls:

Costs will be monitored through Azure Portal.

There is a free tier of 5000 hits to the API per month.

The API is hit 3 times per image.  This could be lowered to 1 hit for the most useful information (the tags)

Move to an open-source technology.

##### The performance of the website or box.com will be impacted by the image analysis

Impact: high - negative reputation for the project.

###### Controls:

Wget - use of a 20 second wait.

Imageseer - download the images so that they don't have to be downloaded again if they need to be reprocessed.

Don't run too many processes at the same time from different computers

Download all of the images, and then process


### Project Resources

Project code is stored in https://github.com/jeffblackadar/crane-pompeii This repository is private for now.


Box.com
I likely need to log into box.com to get other images I will have to do that automated https://github.com/box/box-python-sdk

Azure https://docs.microsoft.com/en-us/azure/machine-learning/service/how-to-create-register-datasets

python mariadb https://mariadb.com/resources/blog/how-to-connect-python-programs-to-mariadb/
