# Load required libraries
library(dplyr)
library(shiny)
library(reshape2)
library(readxl)
library(ggplot2)
# Set working directory

setwd("C:/Users/brake/OneDrive/Documents/AP_Test_Analysis/AP_Test_Analysis")

# Data import: applying read_excel across sheets
path = "AP_Test_Data.xlsx"
sheetnames <- excel_sheets(path)
mylist <- lapply(sheetnames, read_excel, path = path)
sheetnames <- gsub(' ','_',sheetnames) #stripping space in names

# naming and importing the dataframes to global
names(mylist) <- sheetnames
list2env(mylist ,.GlobalEnv)
Last_Year <- `Last_Years_Data_-_For_Comps`
rm(`Last_Years_Data_-_For_Comps`)
Goals <- This_Years_Goals
rm(This_Years_Goals)

# Define column names
cnames <-  c("ID","Grade","Cohort", "Predicted_AP_Score","Predicted_AP_Level", "Tested","Actual_AP_Score",
             "Actual_AP_Level") 
colnames(AP_Bio) = cnames
colnames(AP_Calculus) = cnames
colnames(AP_Chem) = cnames
colnames(AP_Gov) = cnames
colnames(AP_Lang) = cnames
colnames(AP_Literature) = cnames
colnames(AP_US_History) = cnames
colnames(AP_World) = cnames

# Assign subject names to each dataframe
AP_Bio$Subject <- rep('AP Bio',length(AP_Bio[1]))
AP_Calculus$Subject <- rep('AP Calc',length(AP_Calculus[1]))
AP_Chem$Subject <- rep('AP Chem',length(AP_Chem[1]))
AP_Gov$Subject <- rep('AP Gov',length(AP_Gov[1]))
AP_Lang$Subject <- rep('AP Lang',length(AP_Lang[1]))
AP_Literature$Subject <- rep('AP Lit',length(AP_Literature[1]))
AP_US_History$Subject <- rep('AP US History',length(AP_US_History[1]))
AP_World$Subject <- rep('AP World History',length(AP_World[1]))

# Combine all dataframes into one
AP_Bio%>%
  union_all(AP_Calculus)%>%
  union_all(AP_Chem)%>%
  union_all(AP_Gov)%>%
  union_all(AP_Lang)%>%
  union_all(AP_Literature)%>%
  union_all(AP_US_History)%>%
  union_all(AP_World)-> AP

# Data preprocessing
AP$ID <- as.integer(gsub('Student ','',AP$ID))
AP$Tested <-gsub('Did not test','No',AP$Tested)
AP$Actual_AP_Score <- as.numeric(AP$Actual_AP_Score)
AP$Result <- ifelse(AP$Actual_AP_Score>2,"Passed","Failed")
AP[which(is.na(AP$Actual_AP_Score)),'Result']= "Not Attempted" 
AP <- AP %>% mutate_if(is.character,as.factor)

# Color palette for plots
cbbPalette <- c("#CC79A7", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#000000")
palette =c("Dark Red","Orange","Dark Green", "Dark Green","Dark Green")
palette2 = c("Dark Red","Orange","Dark Green",
             "Dark Red","Orange",
             "Dark Red","Orange", "Dark Green",
             "Dark Red","Orange", "Dark Green",
             "Dark Red","Orange","Dark Green", "Dark Green","Dark Green",
             "Dark Red","Orange", "Dark Green",
             "Dark Red","Orange", "Dark Green","Dark Green",
             "Dark Red","Orange", "Dark Green","Dark Green")
             
# Visualizations #####
### Student AP Score Distribution ####

AP%>%
  ggplot(aes(x=Actual_AP_Score, y = after_stat(count)))+
  geom_bar(fill=palette)+
  geom_text(aes(y = after_stat(count), 
                label = scales::percent((after_stat(count))/sum(after_stat(count)))), stat = "count", vjust = -0.25)+
  theme_bw()+
  labs(title = "Student AP Score Distribution", x= "AP Score", y= "Number of Students")->v1

### Student AP Score Distribution By Subject ####
AP%>%
  filter(!is.na(Actual_AP_Score))%>%
  group_by(Subject,Actual_AP_Score)%>%
  tally()%>%
  mutate(percent= n/sum(n))-> percent
percent%>%
  ggplot(aes(x = Actual_AP_Score, y = n))+
  geom_bar(stat= 'identity',fill=palette2)+
  geom_text(aes(y = n,
                 label = scales::percent(percent)),vjust = -.25, size=3)+
  theme_bw()+
  facet_wrap(.~Subject)+
  ylim(0,20)+
  labs(title = "Student AP Score Distribution By Subject", x= "AP Score", y= "Number of Students")->v2
v2
### Student AP Pass/Fail####
AP%>%
  filter(!is.na(Actual_AP_Score))%>%
  ggplot(aes(x=Result,y = after_stat(count)))+
  geom_bar(fill = c("Dark Red", "Dark Green"))+
  geom_text(aes(y = after_stat(count), 
                label = scales::percent((after_stat(count))/sum(after_stat(count)))), stat = "count", vjust = -0.25)+
  theme_bw()+
  labs(title = "Student AP Pass/Fail", x= "", y= "Number of Students") ->v3
v3

### Student AP Pass/Fail by Subject####
AP%>%
  filter(!is.na(Actual_AP_Score))%>%
  group_by(Subject,Result)%>%
  tally()%>%
  mutate(percent= n/sum(n))-> percent
percent%>%
  ggplot(aes(x = Result, y = n))+
  geom_bar(stat= 'identity',fill= c("Dark Red", "Dark Green",
                                    "Dark Red",
                                    "Dark Red", "Dark Green",
                                    "Dark Red", "Dark Green",
                                    "Dark Red", "Dark Green",
                                    "Dark Red", "Dark Green",
                                    "Dark Red", "Dark Green",
                                    "Dark Red", "Dark Green" 
  ))+
  geom_text(aes(y = n,
                label = scales::percent(percent), vjust = -0.25))+
  theme_bw()+
  facet_wrap(.~Subject)+
  ylim(0,25)+
  labs(title = "Student AP Pass/Fail by Subject", x= "", y= "Number of Students")->v4
v4

### Pass Rate vs. Previous Years Pass Rate####
percent$Year = rep("This Year", length(percent$Subject))
percent$PassRate = as.numeric(round(percent$percent,2))
percent[which(percent$Result=="Passed"),c('Subject','PassRate')]
colnames(Last_Year) <- c("Subject", "PassRate","Last Year AP Index","Last Year Predicted Partipcation Rates")
Last_Year$Year = rep("Last Year", length(Last_Year$Subject))

rbind(Last_Year[,c(1:2,5)], percent[which(percent$Result=="Passed"),c('Subject','PassRate','Year')]) -> pass_rates
pass_rates$PassRate = as.numeric(pass_rates$PassRate)
pass_rates[16,] = list("AP Calc",0,"This Year")


pass_rates%>%
  ggplot(aes(Subject,PassRate, fill= Year))+
  geom_bar(stat = 'identity', position = 'dodge')+
  theme_bw()+
  scale_fill_manual(values=cbbPalette)+
  labs(title="Pass Rate vs. Previous Years Pass Rate", fill='')->v5
v5

### AP Interim Predicted vs. Actual#### 
AP$Predicted <- ifelse((AP$Predicted_AP_Level == "Below AP3"),"Fail",
                       (ifelse((AP$Predicted_AP_Level == "AP3 or Above"),"Pass",NA)))

AP$Accuracy <- ifelse((AP$Predicted=="Pass")&(AP$Result=="Passed"),1,
                      ifelse((AP$Predicted=="Fail")&(AP$Result=="Failed"),1,
                             ifelse((AP$Predicted=="Pass")&(AP$Result=="Failed"),0,
                                    ifelse((AP$Predicted=="Fail")&(AP$Result=="Passed"),0,NA))
                             ))
AP$Accuracy<- factor(AP$Accuracy)
     levels(AP$Accuracy) = c("Incorrectly Predicted","Correctly Predicted","Not Tested")

AP%>%
  filter(!is.na(Accuracy))%>%
  ggplot(aes(Accuracy, fill = Result ))+
  geom_bar()+
  labs(x = "",title="AP Interim Predicted vs. Actual", y="Number of Students",fill = "Student Result")+
  theme_bw()->v6
v6

### AP Participation by Predicted Score####
AP%>%
  filter(Predicted_AP_Level %in% c("AP3 or Above","Below AP3"))%>%
  ggplot(aes(Predicted_AP_Level, fill= Result))+
  scale_fill_manual(values=cbbPalette)+
  geom_bar()+
  labs(title = "AP Participation by Predicted Score", x="Predicted AP Level", y= "Number of Students", fill ="")+
  theme_bw() ->v7
v7
### AP Participation by Predicted Score & Subject####
AP%>%
  filter(Predicted_AP_Level %in% c("AP3 or Above","Below AP3"))%>%
  ggplot(aes(Predicted_AP_Level, fill= Result))+
  scale_fill_manual(values=cbbPalette)+
  geom_bar()+
  facet_wrap(.~Subject)+
  labs(title = "AP Participation by Predicted Score & Subject", x="Predicted AP Level", y= "Number of Students", fill ="")+
  theme_bw()->v8
v8

### Number of Tests Passed by Number of Tests Taken by Student####
AP%>%
  filter(Tested =="Yes")%>%
  group_by(ID)%>%
  count(ID)->numtest
colnames(numtest) <- c("ID","Number of Test Taken")

AP%>%
  group_by(Result)%>%
  filter(Result=="Passed")%>%
  count(ID)->resultcount
colnames(resultcount) <- c("Result","ID","PassCount")


numtest%>%
  left_join(resultcount, by = "ID") -> dat

dat$PassCount[is.na(dat$PassCount)] <- 0
dat$PassCount <- factor(dat$PassCount)
dat%>%
  ggplot(aes(`Number of Test Taken`, fill=PassCount))+
  geom_bar()+
  scale_fill_manual(values=cbbPalette)+
  theme_bw()+
  labs(title = "Number of Tests Passed by Number of Test Taken by Student", y="# of Students") ->v9
v9

round(cor(as.numeric(dat$`Number of Test Taken`),as.numeric(dat$PassCount)),2) -> testcor
# Correlation between number of tests taken and pass count
testcor_comment <- paste("Correlation between the number of tests taken and pass count:", testcor)
### Participation Rate Compared to Participation Goals####
AP$Tested[AP$Tested == "Late"] = "Yes"
colnames(Goals) = c("Subject","ParticipationRate", "Index")
Goals$Source = rep("Goal",length(Goals$Subject))

AP%>%
  group_by(Subject,Tested)%>%
  tally()%>%
  mutate(percent= n/sum(n))%>%
  filter(Tested != 'No')%>%
  select(-c("Tested","n"))%>%
  rename("ParticipationRate"="percent")%>%
  left_join(percent[percent$Result=="Passed",],by = "Subject")%>%
  mutate(Index= percent*PassRate)%>%
  select(-c('Result','n','percent','Year','PassRate'))%>%
  mutate(Source = "Actual")%>%
  union_all(Goals)->PTR

PTR[2,'Index']<-0

PTR%>%
  filter(Source=='Actual')%>%
  ggplot(aes(Subject,ParticipationRate))+
  geom_bar(stat = 'identity', color= 'black')+
  theme_bw()+
  geom_hline(yintercept = 0.65, linetype="dashed", color = "dark green", size=1)+
  geom_text(aes(y = 0.3, 
                label = round(ParticipationRate-0.65,3),color = 'red'))+
  theme(legend.position="none")+
  labs(title="Participation Rate Compared to Participation Goals")->v10
v10

### AP Index: Goal vs. Actual####
PTR%>%
  ggplot(aes(Subject,Index, fill=Source))+
  geom_bar(stat = 'identity',position ='dodge')+
  theme_bw()+
  labs(y="AP Index", title = 'AP Index: Goal vs. Actual', fill='') -> v11
v11




