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

#

# get handle on ID
query <-
  "select id,folder,file_name from tbl_webpages where processed=FALSE"
rs = dbSendQuery(mydb, query)
print("Starting")
dbRows <- dbFetch(rs)
print(nrow(dbRows))
if (nrow(dbRows) == 0) {
  print (paste0("Zero rows for ", query))
} else {
  for(dbRow in 1:nrow(dbRows)){
  #for (dbRow in 1:2) {
    print (dbRows$file_name[dbRow])
    local_webpage <-
      paste0(local_path, dbRows$folder[dbRow], "/", dbRows$file_name[dbRow])
    print(local_webpage)
    web_page <- read_html(local_webpage, encoding = "ISO-8859-1")
    images <- web_page %>% html_nodes("img")
    img_height <- images %>% html_attr("height")
    img_width <- images %>% html_attr("width")
    img_src <- images %>% html_attr("src")
    img_alt <- images %>% html_attr("alt")
    
    print(images[1])
    print(head(images[1]))
    for (img_number in 1:length(images)) {
      query <-
        paste0(
          'INSERT INTO tbl_webpage_images (id_webpage, folder, img_src , img_alt , img_height, img_width) VALUES("',
          dbRows$id[dbRow],
          '","',
          dbRows$folder[dbRow],
          '","',
          img_src[img_number],
          '","',
          img_alt[img_number],
          '",',
          img_height[img_number],
          ',',
          img_width[img_number],
          ')'
        )
      print(query)
      rsInsert = dbSendQuery(mydb, query)
      dbClearResult(rsInsert)
    }
  }
}
