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

dupe_finder.ipynb - A program to find the duplicate images in a sample of the results from pompeii_image_seeer_local_pc.ipynb using the Google Spreadsheet

sample_duplicates.htm - is a sample from dupe_finder.ipynb  There are some false duplicates in the sample.  Part of the work of the project will control for this using image descriptions.



