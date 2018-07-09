##### scraping images from google 

test_url <- "https://www.google.co.in/search?q=camera&source=lnms&tbm=isch&sa=X&ved=0ahUKEwiF6f7vkNrZAhWKsI8KHRSzAswQ_AUICygC&biw=1516&bih=1054"
#node <- html_nodes(page,xpath = '//img')
#set_config( config( ssl_verifypeer = 0L ))
gpage=GET(test_url,format='xml')
test_xml <- read_html(gpage)
cnt=content(gpage)

aa=html_nodes(test_xml, css  = '//*[@id="rg_s"]/div[1]/a/img')
aa1=html_table(aa[[1]],fill=T)

aa_attr=html_attr(aa,'src')
#aa_attr1=paste0('https:',aa_attr)


print(html_attrs(aa))
aa_attr1



for(i in 1:20)
{
  download.file(url = aa_attr[i],destfile = paste0("C:\\Users\\rjagtani\\Desktop\\dowloaded_files\\camera",i,".jpeg"),mode='wb')
}
