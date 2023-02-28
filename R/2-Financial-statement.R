# Reading Staff documents

Staff <- here("Informes", "3", "Staff") %>% list.files( recursive = TRUE, pattern = "*.xlsm", include.dirs = TRUE)


Fabio_EC <- 
   read_excel(here("Informes", "3", "Staff", Staff[1]), skip = 11) %>% 
   mutate(People = "Fabio", Role = "EC")%>% drop_na()
Fabio_Man <- 
   read_excel(here("Informes", "3", "Staff", Staff[2]), skip = 11) %>% 
   mutate(People = "Fabio", Role = "Manager")%>% drop_na()

Ferney_Admin <- 
   read_excel(here("Informes", "3", "Staff", Staff[3]), skip = 11) %>% 
   mutate(People = "Ferney", Role = "Admin")%>% drop_na()

Ferney_tech <- 
   read_excel(here("Informes", "3", "Staff", Staff[4]), skip = 11) %>% 
   mutate(People = "Ferney", Role = "Tech")%>% drop_na()

#Grouping all
Total <- rbind(Fabio_EC, Fabio_Man, Ferney_Admin, Ferney_tech )
rm(Fabio_EC, Fabio_Man, Ferney_Admin, Ferney_tech )


# Group by Working package
# Total %>% group_by(`Work \r\nPackage`, Role) %>% summarise( Days = sum(`Number of Days`))













