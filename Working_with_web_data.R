#### Working with Web Data


####### CHAPTER 1 - Reading writing files and using keys

##### Exercise 1

# Here are the URLs! As you can see they're just normal strings
csv_url <- "http://s3.amazonaws.com/assets.datacamp.com/production/course_1561/datasets/chickwts.csv"
tsv_url <- "http://s3.amazonaws.com/assets.datacamp.com/production/course_3026/datasets/tsv_data.tsv"

# Read a file in from the CSV URL and assign it to csv_data
csv_data <- read.csv(csv_url)

# Read a file in from the TSV URL and assign it to tsv_data
tsv_data <- read.delim(tsv_url)

# Examine the objects with head()
head(csv_data)
head(tsv_data)


######## Exercise 2

# Download the file with download.file()
download.file(url = csv_url, destfile = 'feed_data.csv')

# Read it in with read.csv()
csv_data <- read.csv('feed_data.csv')


###### Exercise 3

# Add a new column: square_weight
csv_data$square_weight <- csv_data$weight ** 2

# Save it to disk with saveRDS()
saveRDS(csv_data,file='modified_feed_data.RDS')

# Read it back in with readRDS()
modified_feed_data <- readRDS('modified_feed_data.RDS')

# Examine modified_feed_data
str(modified_feed_data)



####### Exercise 4


# Load pageviews
library(pageviews)

# Get the pageviews for "Hadley Wickham"
hadley_pageviews <- article_pageviews(project = "en.wikipedia",article='Hadley Wickham')

# Examine the resulting object
str(hadley_pageviews)



##### Exercise 5 


# Load birdnik
library(birdnik)

# Get the word frequency for "vector", using api_key to access it
vector_frequency <- word_frequency(api_key,"vector")




########### CHAPTER 2 - Using httr to interact directly with APIs, GET,POST & CONTENT 
# functions, Using Paste & Query to automate data querying , Using user_agent to give 
# user details , usnig System.sleep to pause between successive queries to avoid 
# getting banned


##### Exercise 6 


# Load the httr package
library(httr)

# Make a GET request to http://httpbin.org/get
get_result <- GET('http://httpbin.org/get')

# Print it to inspect it
print(get_result)


##### Exercise 7


# Load the httr package
library(httr)

# Make a POST request to http://httpbin.org/post with the body "this is a test"
post_result <- POST(body='this is a test',url='http://httpbin.org/post')

# Print it to inspect it
print(post_result)



###### Exercise 8 

# Make a GET request to url and save the results
pageview_response <- GET(url)

# Call content() to retrieve the data the server sent back
pageview_data <- content(pageview_response)

# Examine the results with str()
str(pageview_data)


############ Exercise 9

fake_url <- "http://google.com/fakepagethatdoesnotexist"

# Make the GET request
request_result <- GET(fake_url)

# Check request_result
if(http_error(request_result)){
  warning('The request failed')
} else {
  content(request_result)
}


######### Exercise 10 


# Construct a directory-based API URL to `http://swapi.co/api`,
# looking for person `1` in `people`
directory_url <- paste("http://swapi.co/api","people","1", sep = '/')

# Make a GET call with it
result <- GET(directory_url)


###### Exercise 11


# Create list with nationality and country elements
query_params <- list(nationality = "americans", 
                     country = "antigua")

# Make parameter-based call to httpbin, with query_params
parameter_response <- GET('https://httpbin.org/get', query = query_params)

# Print parameter_response
print(parameter_response)


######## Exercise 12 

# Do not change the url
url <- "https://wikimedia.org/api/rest_v1/metrics/pageviews/per-article/en.wikipedia/all-access/all-agents/Aaron_Halfaker/daily/2015100100/2015103100"

# Add the email address and the test sentence inside user_agent()
server_response <- GET(url, user_agent('my@email.address this is a test'))


###### Exercise 13

# Construct a vector of 2 URLs
urls <- c('http://fakeurl.com/api/1.0/','http://fakeurl.com/api/2.0/')

for(url in urls){
  # Send a GET request to url
  result <- GET(url)
  # Delay for 5 seconds between requests
  Sys.sleep(5)
}



###### Exercise 14


get_pageviews <- function(article_title){
  
  url <- paste0("https://wikimedia.org/api/rest_v1/metrics/pageviews/per-article/en.wikipedia/all-access/all-agents", 
                article_title, 
                "daily/2015100100/2015103100", sep = "/") 
  
  response <- GET(url, user_agent('my@email.com this is a test')) 
  
  if(http_error(response)){ 
    
    stop('the request failed') 
    
  } else { 
    
    result <- content(response) 
    
    return(result) 
    
  }
}


############################ CHAPTER 3 - Reading and Manipulating JSON and XML Data
### Converting Data to a structured format. Extracting information using XPATH 


##### Exercise 15 


# Get revision history for "Hadley Wickham"
resp_json <- rev_history('Hadley Wickham')

# Check http_type() of resp_json
http_type(resp_json)

# Examine returned text with content()
content(resp_json,as='text')

# Parse response with content()
class(content(resp_json,as='parsed'))

# Parse returned text with fromJSON()
library(jsonlite)
fromJSON(content(resp_json,as='text'))


###### Exercise 16

# Load rlist
library(rlist)

# Examine output of this code
str(content(resp_json), max.level = 4)

# Store revision list
revs <- content(resp_json)$query$pages$`41916270`$revisions

# Extract the user element
user_time <- list.select(revs,user,timestamp)

# Print user_time
print(user_time)

# Stack to turn into a data frame
list.stack(user_time)


####### Exercise 17

# Load dplyr
library(dplyr)

# Pull out revision list
revs <- content(resp_json)$query$pages$`41916270`$revisions

# Extract user and timestamp
revs %>% bind_rows() %>% select(user,timestamp)


####### Exercise 18

# Load xml2
library(xml2)

# Get XML revision history
resp_xml <- rev_history("Hadley Wickham", format = "xml")

# Check response is XML 
http_type(resp_xml)


# Examine returned text with content()
rev_text <- content(resp_xml,as='text')
rev_text

# Turn rev_text into an XML document
rev_xml <- read_xml(rev_text)

# Examine the structure of rev_xml
xml_structure(rev_xml)


####### Exercise 19

# Find all nodes using XPATH "/api/query/pages/page/revisions/rev"
xml_find_all(rev_xml,xpath = "/api/query/pages/page/revisions/rev")

# Find all rev nodes anywhere in document
rev_nodes <- xml_find_all(rev_xml,xpath='//rev')

# Use xml_text() to get text from rev_nodes
xml_text(rev_nodes)


####### Exercise 20  

# All rev nodes
rev_nodes <- xml_find_all(rev_xml, "//rev")

# The first rev node
first_rev_node <- xml_find_first(rev_xml, "//rev")

# Find all attributes with xml_attrs()
xml_attrs(first_rev_node)

# Find user attribute with xml_attr()
xml_attr(first_rev_node,'user')

# Find user attribute for all rev nodes
xml_attr(rev_nodes,'user')

# Find anon attribute for all rev nodes
xml_attr(rev_nodes,'anon')


####### Exercise 21

get_revision_history <- function(article_title){
  # Get raw revision response
  rev_resp <- rev_history(article_title, format = "xml")
  
  # Turn the content() of rev_resp into XML
  rev_xml <- read_xml(content(rev_resp, "text"))
  
  # Find revision nodes
  rev_nodes <- xml_find_all(rev_xml,xpath='//rev')
  
  # Parse out usernames
  user <- xml_attr(rev_nodes,'user')
  
  # Parse out timestamps
  timestamp <- readr::parse_datetime(xml_attr(rev_nodes, "timestamp"))
  
  # Parse out content
  content <- xml_text(rev_nodes)
  
  # Return data frame 
  data.frame(user = user,
             timestamp = timestamp,
             content = substr(content, 1, 40))
}

# Call function for "Hadley Wickham"
get_revision_history(article_title='Hadley Wickham')


######################### Chapter 4 - Web scraping with XPATHS

##### Exercise 22

# Load rvest
library(rvest)

# Hadley Wickham's Wikipedia page
test_url <- "https://en.wikipedia.org/wiki/Hadley_Wickham"

# Read the URL stored as "test_url" with read_html()
test_xml <- read_html(test_url)

# Print test_xml
print(test_xml)


########## Exercise 23 


# Use html_node() to grab the node with the XPATH stored as `test_node_xpath`
node <- html_node(x = test_xml,xpath = test_node_xpath)

# Print the first element of the result
print(node[1])



###### Exercise 24


# Extract the name of table_element
element_name <- html_name(table_element)

# Print the name
print(element_name)



##### Exercise 25

# Extract the element of table_element referred to by second_xpath_val and store it as page_name
page_name <- html_node(x = table_element, xpath = second_xpath_val)

# Extract the text from page_name
page_title <- html_text(page_name)

# Print page_title
print(page_title)



##### Exercise 26

# Turn table_element into a data frame and assign it to wiki_table
wiki_table <- html_table(table_element)

# Print wiki_table
print(wiki_table)


#####  Exercise 27


# Rename the columns of wiki_table
colnames(wiki_table) <- c("key", "value")

# Remove the empty row from wiki_table
cleaned_table <- subset(wiki_table,!key=='' | !value=='')

# Print cleaned_table
print(cleaned_table)



##### Chapter 5 - CSS Web Scraping and Case study


##### Exercise 28

# Select the table elements
html_nodes(test_xml, css = 'table')

# Select elements with class = "infobox"
html_nodes(test_xml, css = '.infobox')

# Select elements with id = "firstHeading"
html_nodes(test_xml, css = '#firstHeading')


###### Exercise 29

# Extract element with class infobox
infobox_element <- html_nodes(test_xml, css = '.infobox')

# Get tag name of infobox_element
element_name <- html_name(infobox_element)

# Print element_name
print(element_name)


####### Exercise 30


# Extract element with class fn
page_name <- html_node(x = infobox_element,css='.fn')

# Get contents of page_name
page_title <- html_text(page_name)

# Print page_title
print(page_title)


###### Exercise 31 - Case Study begins

# Load httr
library(httr)

# The API url
base_url <- "https://en.wikipedia.org/w/api.php"

# Set query parameters
query_params <- list(action='parse', 
                     page='Hadley Wickham', 
                     format='xml')

# Get data from API
resp <- GET(url = base_url, query = query_params)

# Parse response
resp_xml <- content(resp)


####### Exercise 32


# Load rvest
library(rvest)

# Read page contents as HTML
page_html <- read_html(xml_text(resp_xml))

# Extract infobox element
infobox_element <- html_node(page_html,css='.infobox')

# Extract page name element from infobox
page_name <- html_node(infobox_element,css='.fn')

# Extract page name as text
page_title <- html_text(page_name)


###### Exercise 33

# Your code from earlier exercises
wiki_table <- html_table(infobox_element)
colnames(wiki_table) <- c("key", "value")
cleaned_table <- subset(wiki_table, !key == "")

# Create a dataframe for full name
name_df <- data.frame(key = 'Full name', value = page_title)

# Combine name_df with cleaned_table
wiki_table2 <- rbind(name_df,cleaned_table)

# Print wiki_table
print(wiki_table2)


####### Exercise 34


library(httr)
library(rvest)
library(xml2)

get_infobox <- function(title){
  base_url <- "https://en.wikipedia.org/w/api.php"
  
  # Change "Hadley Wickham" to title
  query_params <- list(action = "parse", 
                       page = title, 
                       format = "xml")
  
  resp <- GET(url = base_url, query = query_params)
  resp_xml <- content(resp)
  
  page_html <- read_html(xml_text(resp_xml))
  infobox_element <- html_node(x = page_html, css =".infobox")
  page_name <- html_node(x = infobox_element, css = ".fn")
  page_title <- html_text(page_name)
  
  wiki_table <- html_table(infobox_element)
  colnames(wiki_table) <- c("key", "value")
  cleaned_table <- subset(wiki_table, !wiki_table$key == "")
  name_df <- data.frame(key = "Full name", value = page_title)
  wiki_table <- rbind(name_df, cleaned_table)
  
  wiki_table
}

# Test get_infobox with "Hadley Wickham"
get_infobox(title = "Hadley Wickham")

# Try get_infobox with "Ross Ihaka"
get_infobox(title = "Ross Ihaka")

# Try get_infobox with "Grace Hopper"
get_infobox(title = "Grace Hopper")



###################################################################




















