
## Catching errors in workflow
## STOPIFNOT should be STOP-function-IFNOT
rm(list=ls())
library(dplyr)
library(readxl)


file <- "test_excel_file.xlsx"

pipe_print <- function(x, sheet){
    print(paste0("Number of rows in ", sheet, " ", nrow(x)))
    return(x)
}


#Catching errors
DF <-
    tryCatch(
        read_excel(file, sheet="Main sheet", col_types = "text")%>%
            rename(Pack_size=`Pack size`, Concessionary_price=`Current CP`) %>%
            select(Drug, Pack_size, Status, Concessionary_price) %>%
            pipe_print("Main sheet") ,
        error=function(e){
            data.frame()
        }
    )

stopifnot(nrow(DF)>0)
print("SHOULD NOT GET HERE IF USING MAIN SHEET 2")
print(paste0("[INFO]: Number of rows in dataframe ", nrow(DF)))
print("Doing lots of other stuff ..... ")

#########################################################################################
# The importance of functions

import_fn <- function(file, sheet_name){
    print(paste0("[INFO]: Working on file ", file))

    # Get CP from file
    DF <-
        tryCatch(
            read_excel(file, sheet=sheet_name, col_types = "text") %>%
                rename(Pack_size=`Pack size`, Concessionary_price=`Current CP`) %>%
                select(Drug, Pack_size, Status, Concessionary_price) %>%
                pipe_print(sheet_name) ,
            error=function(e){
                data.frame()
            }
        )
    stopifnot(nrow(DF)>0)
    print(paste0("[INFO]: Number of rows in dataframe ", nrow(DF)))
    print("Doing some more processing")

    return(DF)
}

#load data
rm(DF)
DF <- import_fn(file, sheet_name="Main sheet")
if(exists("DF")){
    print("Pushing to database")
} else {
    print("[ERROR]: cannot load data")
}


rm(DF)
DF <- import_fn(file, sheet_name="another_sheet")
if(exists("DF")){
    print("Pushing to database")
} else {
    print("[ERROR]: cannot load data")
}


