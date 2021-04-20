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
address <- c()
price <- c()
bed <- c()
bath <- c()
ft <- c()
hunter_time <- c()
stewart_time <- c()
year <- c()
HOA <- c()
acres <- c()
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
  my_house <- c(my_address,my_price,my_bed,my_bath,my_ft,my_hunter_time,my_stewart_time,my_year,my_HOA,my_acres)
  house <- rbind(house,my_house)
}


  