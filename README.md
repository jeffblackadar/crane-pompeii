# crane-pompeii
Work on Pompeii images

## Files in the project
log.md is a running list of notes on progress of the project.

project_plan.md is the plan of this stage of the project.

references.md is a list of references

### Programs
The project has 2 sets of programs:

#### R programs to gather data from the website
0_get_webpages_from_local_and_store_in_database.R - looks through all of the web pages and stores the page information in the database into webpage_images.tbl_webpages.

1_get_image_data_from_webpages_and_store_in_database.R - looks through all of the web pages, gets all of the img tags and inserts information into the database webpage_images.tbl_webpage_images.

#### Python programs to gather data about each image
pompeii_image_seeer_local_pc.ipynb - process each image, get descriptions from Azure cognitive services, get the image hash and store both.

Progress - all ~69,000 images from the website are processed and the image hash is stored in a database

dupe_finder.ipynb - A program to find the duplicate images in a sample of the results from pompeii_image_seeer_local_pc.ipynb using the Google Spreadsheet

Progress - this runs and finds duplicates.  it will have to be redeveloped for a larger database

sample_duplicates.htm - is a sample from dupe_finder.ipynb  There are some false duplicates in the sample.  Part of the work of the project will control for this using image descriptions.

box_images_processing.ipynb - Authenticates with Box.com to get a list of all of the image files and store them in the database into webpage_images.tbl_box_images.

Progress - this program authenticates with box.com. The names and paths of all files on box.com have been stored in a database (~290,000)
The program also downloads thumbnails of images from box.com that are not already on the website and does an image hash. 3,000 processed.  Once all ~221,000 (290,000-69,000) are processed I can run the full image match.


update img_path_match.ipynb - Run this to update the img_path_match column for tbl_webpage_images and tbl_box_images.
Progress - this was run and all images have standardized paths to see if there is a match with what is on box.com and the website.

