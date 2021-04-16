library(rvest)
library(dplyr)
library(stringr)
library(data.table)


#---Web crawling

url <- 'https://www.zillow.com/homes/for_sale/house_type/?searchQueryState=%7B%22usersSearchTerm%22%3A%22Richmond%20Hill%2C%20GA%22%2C%22mapBounds%22%3A%7B%22west%22%3A-81.94719253421933%2C%22east%22%3A-80.61784683109433%2C%22south%22%3A31.227189866819106%2C%22north%22%3A32.60728015349132%7D%2C%22isMapVisible%22%3Afalse%2C%22filterState%22%3A%7B%22price%22%3A%7B%22max%22%3A250000%7D%2C%22con%22%3A%7B%22value%22%3Afalse%7D%2C%22apa%22%3A%7B%22value%22%3Afalse%7D%2C%22mf%22%3A%7B%22value%22%3Afalse%7D%2C%22mp%22%3A%7B%22max%22%3A819%7D%2C%22ah%22%3A%7B%22value%22%3Atrue%7D%2C%22sort%22%3A%7B%22value%22%3A%22globalrelevanceex%22%7D%2C%22land%22%3A%7B%22value%22%3Afalse%7D%2C%22tow%22%3A%7B%22value%22%3Afalse%7D%2C%22manu%22%3A%7B%22value%22%3Afalse%7D%2C%22apco%22%3A%7B%22value%22%3Afalse%7D%7D%2C%22isListVisible%22%3Atrue%7D'

page <- read_html(url)

houses <- page %>%
  html_nodes('.PaginationNumberItem-c11n-8-27-0__bnmlxt-0.bIIHfk') %>%
  html_node('a') %>%
  html_attr('href')

specific <- page %>%
  html_nodes('.list-card-info') %>%
  html_node('a') %>%
  html_attr('href')

#get all stories on front page
stories <- page %>%
  html_nodes('.story-title') %>%
  html_text(trim = TRUE)

#get links to top stories
stories <- page %>%
  html_nodes('.story-title') %>%
  html_node('a') %>%
  html_attr('href')

stories <- stories[is.na(stories) == FALSE]
