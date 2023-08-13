
library(magick)
library(tidyverse)
library(readxl)
library(reshape2)
library(kableExtra)
library(here)


# Cost Erasmus+
Manager =  280
EC =  214
Technicien  = 162
Admin =131

#Conversion factors
Manager.2.EC =  Manager / EC
Tech.2.EC = Technicien / EC
Admin.2.EC = Admin / EC


Cost =
   tribble(~Role, ~Unit.cost, ~Factor.EC,
           "Manager",   280, Manager.2.EC, 
           "EC/Enseignant",   214, 1,
           "Technicien",   162, Tech.2.EC,
           "Administratif", 131 , Admin.2.EC
   )

rm(Manager.2.EC, Tech.2.EC , Admin.2.EC, Manager,  EC , Technicien , Admin)



# Creating WPs
Climatelabs.original <- 
   tibble (
      WP = rep(c("Preparation", "Development", "Quality Plan", "Dissemination\nexploitation", "Management"), 4),
      Role = rep(c("Manager", "EC/Enseignant", "Technicien", "Administratif"), 5)
   ) 

# ORdering factors
Climatelabs.original$WP <- factor(Climatelabs.original$WP, levels = c("Preparation", "Development", "Quality Plan", "Dissemination\nexploitation", "Management"))
Climatelabs.original$Role <- factor(Climatelabs.original$Role, levels = c("Manager", "EC/Enseignant", "Technicien", "Administratif"))

# Ordering
Climatelabs.original <- Climatelabs.original %>%  arrange(WP, Role, by_group = TRUE)

Jours_grant  <- 
   c(
      Preparation = c(0, 16, 9,0),
      Development = c(6,47,35,0 ), 
      "Quality Plan" = c(2,5,0,0 ), 
      "Dissemination\nexploitation" = c(1, 19, 2, 0), 
      Management = c(2, 8, 10, 10 ) 
   ) 

Climatelabs.original$Jours.GA =  Jours_grant

# FUsioning the Cost Table
Climatelabs.original <-  left_join(Climatelabs.original, Cost, by="Role")
rm(Cost)

# Transforming a jours E/C
EC <- Climatelabs.original %>% rowwise() %>% mutate(Jours.EC = Jours.GA * Factor.EC)
EC <- EC %>% group_by(WP) %>% summarise(Jours.GA.EC = sum(Jours.EC))
EC$Role <- "EC/Enseignant"

Climatelabs.original <-  left_join(Climatelabs.original, EC, by=c("WP", "Role"))


# From Gant
Climatelabs.gantt <-
   tibble (
      WP = c("Preparation", "Development", "Quality Plan", "Dissemination\nexploitation", "Management"),
      Gantt = c(6, 9, 36, 36, 36)
   )

Climatelabs.original <-  left_join(Climatelabs.original, Climatelabs.gantt, by=c("WP"))

Climatelabs.original <- Climatelabs.original %>% mutate(Sinchro = round( Jours.GA / Gantt, 2)) 

rm(EC, Climatelabs.gantt)
