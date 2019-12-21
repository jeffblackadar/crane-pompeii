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


files <-
  list.files(
    path = "C:\\a_orgs\\carleton\\hist3814\\R\\pompeii\\website\\pompeiiinpictures.com",
    pattern = "*.htm*",
    full.names = TRUE,
    recursive = TRUE
  )
for (f in files) {
  query <-
    paste0(
      'INSERT INTO tbl_webpages (folder, file_name) VALUES(RTRIM("',
      gsub(
        'C:/a_orgs/carleton/hist3814/R/pompeii/website/pompeiiinpictures.com/',
        '',
        dirname(f)
      ),
      '"),"',
      basename(f),
      '")'
    )
  print(query)
  rsInsert = dbSendQuery(mydb, query)
  dbClearResult(rsInsert)
  print(basename(f))
  # [1] "a.ext"
  #print(gsub("C:/a_orgs/carleton/hist3814/R/pompeii/website/pompeiiinpictures.com/","",dirname(f)))
}
