library(RMariaDB)
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

local_path = "C:\\a_orgs\\carleton\\hist3814\\R\\pompeii\\website\\pompeiiinpictures.com"

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
        gsub('\\','/',local_path),
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
query <- "select id,folder,file_name from tbl_webpages where processed=FALSE"
rs = dbSendQuery(mydb, query)
print("Starting")
dbRows <- dbFetch(rs)
print(nrow(dbRows))
if (nrow(dbRows) == 0) {
  print (paste0("Zero rows for ", query))
} else {
  #for(dbRow in 1:2nrow(dbRows)){
  for(dbRow in 1:2){
    print (dbRows$file_name[dbRow])
    print(paste0(local_path,dbRows$folder[dbRow],dbRows$file_name[dbRow]))
    web_page <- read_html(paste0(local_path,dbRows$folder[dbRow],dbRows$file_name[dbRow]), encoding = "ISO-8859-1")
    google %>% html_nodes("div")
  }
}
