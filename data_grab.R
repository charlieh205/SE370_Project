library(rvest)
library(dplyr)
#https://levelup.gitconnected.com/web-scraping-with-r-part-2-dynamic-webpages-de620a161671
#dynamic webpages
library(RSelenium)

#---Web crawling
URL <-'https://www.zillow.com/homes/for_sale/house_type/?searchQueryState=%7B%22pagination%22%3A%7B%7D%2C%22usersSearchTerm%22%3A%22Richmond%20Hill%2C%20GA%22%2C%22mapBounds%22%3A%7B%22west%22%3A-81.7041200244537%2C%22east%22%3A-80.90074478031308%2C%22south%22%3A31.739848779394055%2C%22north%22%3A32.20699314959706%7D%2C%22mapZoom%22%3A11%2C%22isMapVisible%22%3Atrue%2C%22filterState%22%3A%7B%22price%22%3A%7B%22max%22%3A250000%7D%2C%22con%22%3A%7B%22value%22%3Afalse%7D%2C%22apa%22%3A%7B%22value%22%3Afalse%7D%2C%22mf%22%3A%7B%22value%22%3Afalse%7D%2C%22ac%22%3A%7B%22value%22%3Atrue%7D%2C%22mp%22%3A%7B%22max%22%3A819%7D%2C%22ah%22%3A%7B%22value%22%3Atrue%7D%2C%22sort%22%3A%7B%22value%22%3A%22globalrelevanceex%22%7D%2C%22land%22%3A%7B%22value%22%3Afalse%7D%2C%22tow%22%3A%7B%22value%22%3Afalse%7D%2C%22manu%22%3A%7B%22value%22%3Afalse%7D%2C%22apco%22%3A%7B%22value%22%3Afalse%7D%7D%2C%22isListVisible%22%3Atrue%7D'
url_front <- 'https://www.zillow.com'
url_end <- '?searchQueryState=%7B%22pagination%22%3A%7B%7D%2C%22usersSearchTerm%22%3A%22Richmond%20Hill%2C%20GA%22%2C%22mapBounds%22%3A%7B%22west%22%3A-81.7041200244537%2C%22east%22%3A-80.90074478031308%2C%22south%22%3A31.739848779394055%2C%22north%22%3A32.20699314959706%7D%2C%22mapZoom%22%3A11%2C%22isMapVisible%22%3Atrue%2C%22filterState%22%3A%7B%22price%22%3A%7B%22max%22%3A250000%7D%2C%22con%22%3A%7B%22value%22%3Afalse%7D%2C%22apa%22%3A%7B%22value%22%3Afalse%7D%2C%22mf%22%3A%7B%22value%22%3Afalse%7D%2C%22ac%22%3A%7B%22value%22%3Atrue%7D%2C%22mp%22%3A%7B%22max%22%3A819%7D%2C%22ah%22%3A%7B%22value%22%3Atrue%7D%2C%22sort%22%3A%7B%22value%22%3A%22globalrelevanceex%22%7D%2C%22land%22%3A%7B%22value%22%3Afalse%7D%2C%22tow%22%3A%7B%22value%22%3Afalse%7D%2C%22manu%22%3A%7B%22value%22%3Afalse%7D%2C%22apco%22%3A%7B%22value%22%3Afalse%7D%7D%2C%22isListVisible%22%3Atrue%7D'
url_end_part1 <- '?searchQueryState=%7B%22pagination%22%3A%7B%22currentPage%22%3A'
url_end_part2 <- '%7D%2C%22usersSearchTerm%22%3A%22Richmond%20Hill%2C%20GA%22%2C%22mapBounds%22%3A%7B%22west%22%3A-81.7041200244537%2C%22east%22%3A-80.90074478031308%2C%22south%22%3A31.739848779394055%2C%22north%22%3A32.20699314959706%7D%2C%22mapZoom%22%3A11%2C%22isMapVisible%22%3Atrue%2C%22filterState%22%3A%7B%22price%22%3A%7B%22max%22%3A250000%7D%2C%22con%22%3A%7B%22value%22%3Afalse%7D%2C%22apa%22%3A%7B%22value%22%3Afalse%7D%2C%22mf%22%3A%7B%22value%22%3Afalse%7D%2C%22ac%22%3A%7B%22value%22%3Atrue%7D%2C%22mp%22%3A%7B%22max%22%3A819%7D%2C%22ah%22%3A%7B%22value%22%3Atrue%7D%2C%22sort%22%3A%7B%22value%22%3A%22globalrelevanceex%22%7D%2C%22land%22%3A%7B%22value%22%3Afalse%7D%2C%22tow%22%3A%7B%22value%22%3Afalse%7D%2C%22manu%22%3A%7B%22value%22%3Afalse%7D%2C%22apco%22%3A%7B%22value%22%3Afalse%7D%7D%2C%22isListVisible%22%3Atrue%7D'

#use Rselenium to extract data from dynamic webpage
rD <- rsDriver(browser="chrome", port = 4213L, chromever = "latest")
remDr <- rD[["client"]]

remDr$navigate(URL)

#type in commute locations of hunter army airfield and fort stewart into browser

website <- read_html(remDr$getPageSource()[[1]])

#get the url for each pages of results
result_pages <- website %>%
  html_nodes('.PaginationNumberItem-c11n-8-27-0__bnmlxt-0.bIIHfk') %>%
  html_node('a') %>%
  html_attr('href')

#turn those urls into full urls
full_url <- list()
i <- 1
for (j in result_pages){
  if(i == 1){
    remDr$navigate(paste0(url_front,j,url_end))
    link <- read_html(remDr$getPageSource()[[1]])
  }
  else{
    remDr$navigate(paste0(url_front,j,url_end_part1,i,url_end_part2))
    link <- read_html(remDr$getPageSource()[[1]])
  }
  full_url <- append(full_url,list(link))
  i <- i + 1
}

#get house url off of each page
all_houses <- c()
i <- 1
for(j in full_url){
  specific <-  j %>%
    html_nodes('.list-card-info') %>%
    html_node('a') %>%
    html_attr('href')
  for(k in specific){
    all_houses[i] <- k
    i <- i + 1
  }
}

#getting data from each house
house <- data.frame()


for(i in all_houses){
  remDr$navigate(i)
  #https://stackoverflow.com/questions/43402237/r-waiting-for-page-to-load-in-rselenium-with-phantomjs
  #act more random so zillow does not question if I am human
  randsleep <- sample(seq(1, 3, by = 0.01), 1)
  Sys.sleep(randsleep)
  i <- read_html(remDr$getPageSource()[[1]]) 
  
  my_address <- i %>%
    html_node(xpath = '//*[@id="ds-chip-property-address"]') %>%
    html_text(trim = TRUE)
  
  my_price <-  i %>%
    html_node(xpath = '//*[@id="ds-data-view"]/div[1]/div[1]/div[1]/div/div/span/span/span') %>%
    html_text()
  #price <- append(price,my_price)
  
  my_bed <-  i %>%
    html_node(xpath = '//*[@id="ds-data-view"]/div[1]/div[1]/div[1]/div/div/div/span/span[1]/span[1]') %>%
    html_text()
  #bed <- append(bed,my_bed)
  
  my_bath <- i %>%
    html_node(xpath = '//*[@id="ds-data-view"]/div[1]/div[1]/div[1]/div/div/div/span/button/span/span[1]')%>%
    html_text()
  #bath <- append(bath,my_bath)
  
  my_ft <-  i %>%
    html_node(xpath = '//*[@id="ds-data-view"]/div[1]/div[1]/div[1]/div/div/div/span/span[4]/span[1]') %>%
    html_text()
  #ft <- append(ft,my_ft)
  
  my_hunter_time <- i %>%
    html_node(xpath = '//*[@id="ds-data-view"]/ul/li[3]/div/div[2]/div[1]/div[1]/div[2]/div[2]/div/div[1]/div[2]/div/div/span[2]/strong') %>%
    html_text()
  #hunter_time <- append(hunter_time,my_hunter_time)
  
  my_stewart_time <- i %>%
    html_node(xpath = '//*[@id="ds-data-view"]/ul/li[3]/div/div[2]/div[1]/div[1]/div[2]/div[2]/div/div[2]/div[2]/div/div/span/strong') %>%
    html_text()
  #stewart_time <- append(stewart_time,my_stewart_time)
  
  my_year <- i %>%
    html_node(xpath = '//*[@id="ds-data-view"]/ul/li[5]/div/div/div[1]/ul/li[2]/span[2]') %>%
    html_text()
  #year <- append(year,my_year)
  
  my_HOA <- i %>%
    html_node(xpath = '//*[@id="ds-data-view"]/ul/li[5]/div/div/div[2]/div[6]/div/div[1]/ul/li/span') %>%
    html_text()
  #HOA <- append(HOA,my_HOA)
  
  my_acres <- i %>%
    html_node(xpath = '//*[@id="ds-data-view"]/ul/li[5]/div/div/div[1]/ul/li[6]/span[2]') %>%
    html_text()
  #acres <- append(acres,my_acres)
  my_house <- cbind(as.character(my_address),as.character(my_price),as.numeric(as.character(my_bed)),as.numeric(as.character(my_bath)),as.character(my_ft),as.character(my_hunter_time),as.character(my_stewart_time),as.numeric(as.character(my_year)),as.character(my_HOA),as.character(my_acres))
  house <- rbind(house,my_house)
}

house <- read.csv("C:/Users/Karlee Scott/OneDrive - West Point/AY 21-2/SE370 Computer Aided Design/house.csv") 
house <- house[,-1]
colnames(house) <- c("address","price","bed","bathroom","footage","hunter_time","stewart_time","year","HOA","acres")
house1 <- house

#filter HOA to form usable data for value function

#https://stackoverflow.com/questions/10128617/test-if-characters-are-in-a-string
#check if substring is contained in string
for (r in 1:nrow(house1)){
  if(grepl("HOA", house1[r,"HOA"], fixed=TRUE)==TRUE){
    if(grepl("No", house1[r,"HOA"], fixed=TRUE)==TRUE){
      house1[r,"HOA_price"] <- 0
    }
    else if(grepl("monthly", house1[r,"HOA"], fixed=TRUE)==TRUE){
      noComma <- gsub(',','',house1[r,"HOA"])
#https://statisticsglobe.com/extract-numbers-from-character-string-vector-in-r
#extract number from a string
      house1[r,"HOA_price"] <- as.numeric(regmatches(noComma, gregexpr("[[:digit:]]+", noComma)))*12
    }
    else if(grepl("quarterly", house1[r,"HOA"], fixed=TRUE)==TRUE){
      noComma <- gsub(',','',house1[r,"HOA"])
      #https://statisticsglobe.com/extract-numbers-from-character-string-vector-in-r
      #extract number from a string
      house1[r,"HOA_price"] <- as.numeric(regmatches(noComma, gregexpr("[[:digit:]]+", noComma)))*4
    }
    else{
      noComma <- gsub(',','',house1[r,"HOA"])
      #https://statisticsglobe.com/extract-numbers-from-character-string-vector-in-r
      #extract number from a string
      house1[r,"HOA_price"] <- as.numeric(regmatches(noComma, gregexpr("[[:digit:]]+", noComma)))
    }
      
  }
  else{
    house1[r,"HOA_price"] <- NA
  }
}

#filter acres to form usable data for value function
for (r in 1:nrow(house1)){
  if(grepl("Acres", house1[r,"acres"], fixed=TRUE)==TRUE){
      noPeriod <- gsub('[.]','',house1[r,"acres"])
      house1[r,"num_acres"] <- as.numeric(regmatches(noPeriod, gregexpr("[[:digit:]]+", noPeriod)))/100
  }
  else{
    house1[r,"num_acres"] <- NA
  }
}

#filter hunter and stewart time to form usable data for value function
for (r in 1:nrow(house1)){
  if(grepl("mins", house1[r,"hunter_time"], fixed=TRUE)==TRUE){
    if(grepl("hour", house1[r,"hunter_time"], fixed=TRUE)==TRUE){
      hr_min <- unlist(regmatches(house1[r,"hunter_time"], gregexpr("[[:digit:]]+", house1[r,"hunter_time"])))
      house1[r,"hunter_mins"] <- as.numeric(hr_min[1])*60+as.numeric(hr_min[2])
    }
    else{
      house1[r,"hunter_mins"] <- as.numeric(gsub(' mins','',house1[r,"hunter_time"]))
    }
  }
  else{
    house1[r,"hunter_mins"] <- NA
  }
  if(grepl("mins", house1[r,"stewart_time"], fixed=TRUE)==TRUE){
    if(grepl("hour", house1[r,"stewart_time"], fixed=TRUE)==TRUE){
      hr_min <- unlist(regmatches(house1[r,"stewart_time"], gregexpr("[[:digit:]]+", house1[r,"stewart_time"])))
      house1[r,"stewart_mins"] <- as.numeric(hr_min[1])*60+as.numeric(hr_min[2])
    }
    else{
      house1[r,"stewart_mins"] <- as.numeric(gsub(' mins','',house1[r,"stewart_time"]))
    }
  }
  else{
    house1[r,"stewart_mins"] <- NA
  }
}

#filter footage to form usable data for value function
house1 <- house1 %>%
  mutate(sq_footage = as.numeric(gsub(',','',footage)))

#filter footage price to form usable data for value function
house1 <- house1 %>%
  mutate(list_price = gsub(',','',price),
         list_price = as.numeric(gsub("[$]",'',list_price)))

house1[,"address"] <- as.character(house1[,"address"])
house1 <- house1 %>%
  select(address,list_price,bed,bathroom,sq_footage,hunter_mins,stewart_mins,num_acres,HOA_price)

#build value functions
#define function types
#https://rdrr.io/github/USGS-R/smwrBase/src/R/sCurve.R
#scurve function
sCurve <- function(x, location=0, scale=1, shape=1) {
  z <- scale*(x - location)
  retval <- z/(1 + abs(z)^shape)^(1/shape)
  #make values between 0 and 1 instead of -1 and 1
  retval <- (retval/2)+.5
  return(retval)
}

linear <- function(x, b = 0, m = 1){
  y <- m*x+b
  return(y)
}

house1 <- house1 %>%
  mutate(bed_value = sCurve(x = bed,location = 3),
         bathroom_value = sCurve(x = bathroom,location = 2),
         footage_value = sCurve(x = sq_footage,location = 1500, scale = 1/100),
         hunter_time_value = linear(hunter_mins,1,-1/max(hunter_mins,na.rm=TRUE)),
         stewart_time_value = linear(stewart_mins,1,-1/max(stewart_mins,na.rm=TRUE)),
         acres_value = sCurve(x = num_acres,location = .5, scale = 1/.1),
         HOA_value = sCurve(x = HOA_price,location=300,scale=-1/50))

#total value by house
for(r in 1:nrow(house1)){
  house1[r,"value"] <- 0
  weight <- 0
  if(is.na(house1[r,"bed_value"])==FALSE){
    house1[r,"value"] <- house1[r,"value"] + house1[r,"bed_value"]*3
    weight <- weight + 3
  }
  if(is.na(house1[r,"bathroom_value"])==FALSE){
    house1[r,"value"] <- house1[r,"value"] + house1[r,"bathroom_value"]*2
    weight <- weight + 2
  }
  if(is.na(house1[r,"footage_value"])==FALSE){
    house1[r,"value"] <- house1[r,"value"] + house1[r,"footage_value"]*2
    weight <- weight + 2
  }
  if(is.na(house1[r,"hunter_time_value"])==FALSE){
    house1[r,"value"] <- house1[r,"value"] + house1[r,"hunter_time_value"]*4
    weight <- weight + 4
  }
  if(is.na(house1[r,"stewart_time_value"])==FALSE){
    house1[r,"value"] <- house1[r,"value"] + house1[r,"stewart_time_value"]*3
    weight <- weight + 3
  }
  if(is.na(house1[r,"acres_value"])==FALSE){
    house1[r,"value"] <- house1[r,"value"] + house1[r,"acres_value"]*1
    weight <- weight + 1
  }
  if(is.na(house1[r,"HOA_value"])==FALSE){
    house1[r,"value"] <- house1[r,"value"] + house1[r,"HOA_value"]*3
    weight <- weight + 3
  }
  house1[r,"value"] <-  house1[r,"value"]/weight
}

rD <- rsDriver(browser="firefox", port = 2314L, geckover = "latest")
remDr <- rD[["client"]]
URL <-"https://www.latlong.net/"
remDr$navigate(URL)
#log into my account
for(r in 1:nrow(house1)){
  print(r)
  randsleep <- sample(seq(1, 2, by = 0.01), 1)
  Sys.sleep(randsleep)
  
  address_field <- remDr$findElement(using = 'xpath', value = '//*[@id="place"]')
  address_field$sendKeysToElement(list(as.character(house1[r,"address"])))
  
  find <- remDr$findElement(using = 'xpath', value = '//*[@id="btnfind"]')
  #https://stackoverflow.com/questions/51887807/click-button-via-rselenium
  #how to click a button
  find$clickElement()
  
  latitude <- remDr$findElement(using = 'xpath', value = '//*[@id="lat"]')
  #https://stackoverflow.com/questions/46021890/rselenium-get-text-from-result-form
  #how to get the value from an element
  latitude <- latitude$getElementAttribute("value")
  
  longitude <- remDr$findElement(using = 'xpath', value = '//*[@id="lng"]')
  longitude <- longitude$getElementAttribute("value")
  
  address_field <- remDr$findElement(using = 'xpath', value = '//*[@id="place"]')
  #https://stackoverflow.com/questions/51072341/rselenium-clear-input-field/51074636
  #how to clear input
  address_field$clearElement()
  
  house1[r,"latitude"] <- as.numeric(latitude[[1]])
  house1[r,"longitude"] <- as.numeric(longitude[[1]])
}

badaddress <- c()
row <- c()
for(r in 1:nrow(house1)){
  if(house1[r,"latitude"]==0){
    row <- append(row,r,after=length(row))
    badaddress <- append(badaddress,as.character(house1[r,"address"]),after = length(badaddress))
  }
}

#almost all are buildable plans with no price or specific location thus we will remove them
house1 <- house1[-row,]

#classify price and value by high, medium, and low
price_bins <- quantile(house1[,"list_price"], c(.33, .66, 1), na.rm = TRUE) 
value_bins <- quantile(house1[,"value"], c(.33, .66, 1), na.rm = TRUE)  
for(r in 1:nrow(house1)){
  if(is.na(house1[r,"list_price"])==FALSE){
    if(house1[r,"list_price"]<=as.numeric(price_bins[1])){
      house1[r,"price_category"]<- "low"
    }
    else if(house1[r,"list_price"]>as.numeric(price_bins[1]) && house1[r,"list_price"]<=as.numeric(price_bins[2])){
      house1[r,"price_category"]<- "med"
    }
    else{
      house1[r,"price_category"]<- "high"
    }
  }
  
  if(house1[r,"value"]<=as.numeric(value_bins[1])){
    house1[r,"value_category"]<- "low"
    }
  else if(house1[r,"value"]>as.numeric(value_bins[1]) && house1[r,"value"]<=as.numeric(value_bins[2])){
    house1[r,"value_category"]<- "med"
  }
  else{
    house1[r,"value_category"]<- "high"
  }
}

#value per dollar
house1 <- house1 %>%
  mutate(value_per_dollar = (100*value)/list_price)

write.csv(house1,"C:/Users/Karlee Scott/OneDrive - West Point/AY 21-2/SE370 Computer Aided Design/B1_HouseHunters_folder/value_house.csv")

