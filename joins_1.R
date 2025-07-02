library(tidyverse)



tibble(uid = 1:10,
       Name = LETTERS[1:10],
       Ph_no = sample(c(9181767100:9181767611),10),
       Add = paste0(letters[1:10],sample(letters,10),sample(letters,10)))->customer_table


tibble(pid = 1:100,
       item = paste0("ITEM_",sample(LETTERS[21:30],100,replace = T)),
       price = sample(c(200:900),100,replace = T),
       quantity = sample(c(20:90),100,replace = T),
       uid = sample(1:10,100,replace = T))->purchase_table



purchase_table %>% 
  left_join(customer_table,by = c("uid" = "uid")) %>% view()

purchase_table %>% 
  full_join(customer_table,by = c("uid" = "uid")) %>% view()

purchase_table %>% 
  inner_join(customer_table,by = c("uid" = "uid")) %>% view()
