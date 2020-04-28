

lab<-list()
for(i in 1:84){
url<-paste0("https://labour.org.uk/category/latest/press-release/page/",i)
lab[[i]]<-read_html(url)  
}

example<-lab[[1]]

linklist<-c()
for(i in 1:length(lab)){
example<-lab[[i]]
cont<-xml_find_all(example,xpath='//*[@class="main-content"]/a')
links<-html_attr(cont,"href")
linklist<-c(linklist,links)
}

read_statement<-function(url){
text<-read_html(url)  

  title_path<-'//*[@id="container-wrap"]/main/div[1]/div/div/div/div/h1'
  title<-html_nodes(text,xpath=title_path)
  title<-html_text(title)

  text_path<-'//*[@class="col-xs-12 col-md-8"]'
  textblock<-html_nodes(text,xpath=text_path)  
  statement<-html_text(textblock)

  datepath<-'//*[@class="page-meta"]/span'
  dateblock<-html_nodes(text,xpath=datepath)
  press_date<-html_text(dateblock)

  return(list(title,statement,press_date))
}


corpus<-list()
for(i in 1:length(linklist)){
  print(i)
  corpus[[i]]<-read_statement(linklist[i])
}


