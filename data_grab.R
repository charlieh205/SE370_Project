library(rvest)
library(dplyr)
library(stringr)
library(data.table)


#---Web crawling

url <-'https://www.zillow.com/homes/for_sale/house_type/?searchQueryState=%7B%22pagination%22%3A%7B%7D%2C%22usersSearchTerm%22%3A%22Richmond%20Hill%2C%20GA%22%2C%22mapBounds%22%3A%7B%22west%22%3A-81.7041200244537%2C%22east%22%3A-80.90074478031308%2C%22south%22%3A31.756489988553817%2C%22north%22%3A32.19043342553413%7D%2C%22mapZoom%22%3A11%2C%22isMapVisible%22%3Atrue%2C%22filterState%22%3A%7B%22price%22%3A%7B%22max%22%3A250000%7D%2C%22con%22%3A%7B%22value%22%3Afalse%7D%2C%22apa%22%3A%7B%22value%22%3Afalse%7D%2C%22mf%22%3A%7B%22value%22%3Afalse%7D%2C%22mp%22%3A%7B%22max%22%3A819%7D%2C%22ah%22%3A%7B%22value%22%3Atrue%7D%2C%22sort%22%3A%7B%22value%22%3A%22globalrelevanceex%22%7D%2C%22land%22%3A%7B%22value%22%3Afalse%7D%2C%22tow%22%3A%7B%22value%22%3Afalse%7D%2C%22manu%22%3A%7B%22value%22%3Afalse%7D%2C%22apco%22%3A%7B%22value%22%3Afalse%7D%2C%22ac%22%3A%7B%22value%22%3Atrue%7D%7D%2C%22isListVisible%22%3Atrue%7D'
url_front <- 'https://www.zillow.com'
url_end_for_first_page <- '?searchQueryState=%7B%22pagination%22%3A%7B%7D%2C%22usersSearchTerm%22%3A%22Richmond%20Hill%2C%20GA%22%2C%22mapBounds%22%3A%7B%22west%22%3A-81.7041200244537%2C%22east%22%3A-80.90074478031308%2C%22south%22%3A31.756489988553817%2C%22north%22%3A32.19043342553413%7D%2C%22mapZoom%22%3A11%2C%22isMapVisible%22%3Atrue%2C%22filterState%22%3A%7B%22price%22%3A%7B%22max%22%3A250000%7D%2C%22con%22%3A%7B%22value%22%3Afalse%7D%2C%22apa%22%3A%7B%22value%22%3Afalse%7D%2C%22mf%22%3A%7B%22value%22%3Afalse%7D%2C%22mp%22%3A%7B%22max%22%3A819%7D%2C%22ah%22%3A%7B%22value%22%3Atrue%7D%2C%22sort%22%3A%7B%22value%22%3A%22globalrelevanceex%22%7D%2C%22land%22%3A%7B%22value%22%3Afalse%7D%2C%22tow%22%3A%7B%22value%22%3Afalse%7D%2C%22manu%22%3A%7B%22value%22%3Afalse%7D%2C%22apco%22%3A%7B%22value%22%3Afalse%7D%2C%22ac%22%3A%7B%22value%22%3Atrue%7D%7D%2C%22isListVisible%22%3Atrue%7D'
url_end_part1 <- '?searchQueryState=%7B%22pagination%22%3A%7B%22currentPage%22%3A'
url_end_part2 <- '%7D%2C%22usersSearchTerm%22%3A%22Richmond%20Hill%2C%20GA%22%2C%22mapBounds%22%3A%7B%22west%22%3A-81.7041200244537%2C%22east%22%3A-80.90074478031308%2C%22south%22%3A31.756489988553817%2C%22north%22%3A32.19043342553413%7D%2C%22mapZoom%22%3A11%2C%22isMapVisible%22%3Atrue%2C%22filterState%22%3A%7B%22price%22%3A%7B%22max%22%3A250000%7D%2C%22con%22%3A%7B%22value%22%3Afalse%7D%2C%22apa%22%3A%7B%22value%22%3Afalse%7D%2C%22mf%22%3A%7B%22value%22%3Afalse%7D%2C%22ac%22%3A%7B%22value%22%3Atrue%7D%2C%22mp%22%3A%7B%22max%22%3A819%7D%2C%22ah%22%3A%7B%22value%22%3Atrue%7D%2C%22sort%22%3A%7B%22value%22%3A%22globalrelevanceex%22%7D%2C%22land%22%3A%7B%22value%22%3Afalse%7D%2C%22tow%22%3A%7B%22value%22%3Afalse%7D%2C%22manu%22%3A%7B%22value%22%3Afalse%7D%2C%22apco%22%3A%7B%22value%22%3Afalse%7D%7D%2C%22isListVisible%22%3Atrue%7D'
website <- read_html(url)

result_pages <- website %>%
  html_nodes('.PaginationNumberItem-c11n-8-27-0__bnmlxt-0.bIIHfk') %>%
  html_node('a') %>%
  html_attr('href')

full_url <- list()
i <- 1
for (j in result_pages){
  if(i == 1){
    link <- read_html(paste0(url_front,j,url_end))
  }
  else{
    link <- read_html(paste0(url_front,j,url_end_part1,i,url_end_part2))
  }
  full_url <- append(full_url,list(link))
  i <- i + 1
}


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

df <- c()
df <- cbind(df,all_houses)

price <- c()
for(i in all_houses){
  my_price <-  read_html(i) %>%
    html_nodes('.Text-c11n-8-18-0__aiai24-0 hdp__qf5kuj-3 dyzDHY')
  append(price,my_price)
}

i <- all_houses[1]
read_html(i) %>%
  html_node(xpath = '//*[@id="ds-container"]/div[4]/div[2]/div/div[1]/div/div/span/span/span') %>%
  html_text()
