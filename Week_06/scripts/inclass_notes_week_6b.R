###date created: 2024/10/04 ###
###created by: Brandon Brenes ###
###last edited: 2024/10/04 ###

#description: In class notes for markdown in R (Week_06b) - this is the second class of the week.

#library:
library(dplyr)
library(rmarkdown)
library(kableExtra)
library(tinytex) #this will be helpful if you want a PDF doc

#don't need to ggsave() to save document in markdown, just save it as a pdf or png

#you can still save with ggsave BUT there are more automated ways to export your figures in rmarkdown

#R markdown automatically saves everything to the file directory, NOT the project directory

#Automatically save all your figures to your output folder.
#The "../" means "go up a directory". 
#So this is saying, go out of the scripts folder (assuming that is where your script is saved) 
#and then go to your output folder (spelled the way YOU have it) 



#You can make tables in rmarkdown...you have to type in by hand.

#Tables with kable

penguins %>% 
  group_by(species) %>% 
  summarise(billmean = mean(bill_length_mm, na.rm = TRUE)) %>% 
  kbl()

#There are a lot of packages/themes to make your tables look more pretty

#One of my favorites is github_document. This makes a file that is easy to view on github.
#Importantly, every file type has different limitations for the YAML. 
#For example, there are several settings that only work in an html file that will 
#need to be removed when using a github_document or a pdf_document.


#Today's totally awesome R package

#Make a meme in R!

library(memer)
meme_get("DistractedBf") %>% 
  meme_text_distbf("Silly R package", "OCN 682 students", "actual coding")

#AND

library(memer)
meme_get("DosEquisMan") %>% 
  meme_text_top("I don't always like coding", size = 28) %>% 
  meme_text_bottom("But when I do\nIt's always today's totally awesome R package", size = 18)
