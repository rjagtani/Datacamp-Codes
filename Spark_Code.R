library(sparklyr)
library(dplyr)
library(pryr)

##### Expanding dataset - one time task


setwd('C:\\Users\\rjagtani\\Desktop\\Salesforce Reports')
files=list.files()
adj=read.csv(files[10])
k=rep(adj,5)
adj_all=as.data.frame(k)
for(i in 1:3)
{
  adj_all=rbind(adj_all,adj_all)
}
write.csv(adj_all,'adj_all.csv',row.names = F)



###### 





####### 

adj_local=read.csv('adj_all1.csv',stringsAsFactors = F)
for(i in 1:4)
{
  adj_local=rbind(adj_local,adj_local)
}

write.csv(adj_local,'adj_all1.csv',row.names = F)

#### Spark connection commands 

spark_conn=spark_connect(master='local[2]')
adj_spark=copy_to(spark_conn,adj_local)
src_tbls(spark_conn)
spark_read_csv(sc=spark_conn,name='adj_spark',path='C:\\Users\\rjagtani\\Desktop\\Salesforce Reports\\adj_all1.csv')
adj_spark_df=tbl(spark_conn,'adj_spark')
object_size(adj_spark_df)


###### Benchmarking sparklyr functions using BaseR functions

### Using Base R functions

unique_adj=as.character(unique(adj_local$Adjective))
temp1=list()
adj_local1=tbl_df(adj_local)
system.time(
for(i in 1:500)
{
  temp=adj_local1 %>% filter(Adjective==unique_adj[i])
  temp1=list(temp1,temp)
}
)






# user  system elapsed 
# 4.02    0.45    4.4###### Using spark functions



d=numeric()
temp2=list()
system.time(
  for(i in 1:500)
  {
    temp=adj_spark_df %>% filter(Adjective==unique_adj[i]) 
    temp2=list(temp2,temp)
  }
)

# user  system elapsed 
# 0.19    0.00    0.19


############## Function 2 

##### Base R 

system.time(adj_local %>% group_by(Adjective) %>% 
mutate(average_rating=mean(Rating),min_rating=min(Rating)) %>% arrange(desc(average_rating)))

### 50 L rows
# user  system elapsed 
# 8.16    0.34    8.50 

##########################

adj_spark1=adj_spark_df %>% group_by(Adjective) %>% mutate(average_rating=mean(Rating),min_rating=min(Rating)) %>% arrange(desc(average_rating))
rm(adj_local)
adj_spark1=as.data.frame(adj_spark1)

#### 50 L rows
# user  system elapsed 
# 0.00    0.00    0.02


########################            

spark_disconnect(spark_conn)


colnames(adj_all)

