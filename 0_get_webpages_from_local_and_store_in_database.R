# This looks through all of the web pages and stores them in the database
#
# Don't run this unless you want to do that.
#
# Before running this truncate webpage_images.tbl_webpages;

library(RMariaDB)
#install.packages("rvest")
library(rvest)
# Connect to database
rmariadb.settingsfile <-
  "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\webpage_images.cnf"
rmariadb.db <- "webpage_images"

mydb <-
  dbConnect(RMariaDB::MariaDB(),
            default.file = rmariadb.settingsfile,
            group = rmariadb.db)
#Check we connected
dbListTables(mydb)
# should see: [1] "tbl_webpages"

local_path = "C:/a_orgs/carleton/hist3814/R/pompeii/website/pompeiiinpictures.com"

files <-
  list.files(
    path = local_path,
    pattern = "*.htm*",
    full.names = TRUE,
    recursive = TRUE
  )
for (f in files) {
  query <-
    paste0(
      'INSERT INTO tbl_webpages (folder, file_name, processed) VALUES(RTRIM("',
      gsub(
        local_path,
        '',
        dirname(f)
      ),
      '"),"',
      basename(f),
      '",0)'
    )
  print(query)
  rsInsert = dbSendQuery(mydb, query)
  dbClearResult(rsInsert)
  print(basename(f))
  #print(gsub("C:/a_orgs/carleton/hist3814/R/pompeii/website/pompeiiinpictures.com/","",dirname(f)))
}

