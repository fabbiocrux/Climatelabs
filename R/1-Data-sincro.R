# Reading Export Multicriteria  From Jan to Month
#Climatelabs <- read_excel(here("Sinchro/Jan-2021.xlsx")) 
#Climatelabs <- read_excel(here("Sinchro/Avril-2021.xlsx")) 
#Climatelabs <- read_excel(here("Sinchro/June-2021.xlsx")) 
#Climatelabs <- read_excel(here("Sinchro/Septiembre-2021.xlsx")) 
# Data1 <- read_excel(here("Sinchro/01-01-2020-Sincro-31-12-2021.xlsx")) 
# Data2 <- read_excel(here("Sinchro/01-01-2022-Sincro-31-12-2022.xlsx")) 
# Data <- rbind(Data1, Data2)
# 
# Tout <- read_excel(here("Sinchro/June-2021.xlsx")) 
#Climatelabs <- read_excel(here("Sinchro/Janvier-2022.xlsx")) 

# Sincro data
Sincro2020 <- 
   read_excel(here("Sinchro/Export_multi_du_01_01_2020_au_31_12_2020.xlsx")) 
Sincro2021 <- 
   read_excel(here("Sinchro/Export_multi_du_01_01_2021_au_31_12_2021.xlsx")) 
Sincro2022 <- 
   read_excel(here("Sinchro/Export_multi_du_01_01_2022_au_31_12_2022.xlsx")) 

Climatelabs <- rbind(Sincro2020, Sincro2021, Sincro2022)
rm(Sincro2020, Sincro2021, Sincro2022)


# Testing with Fabio
# Climatelabs <-
#    read_excel(here("Sinchro/FABIO-Export_multi_du_01_10_2021_au_30_09_2022.xlsx"))


Climatelabs  <-  Climatelabs %>% select(-Service, -Nom, -"Unité d'export")
Climatelabs <- Climatelabs %>% pivot_longer(!Prénom) %>% set_names("Prenom", "WP", "Jours")

#Filtering only EC et Technicien
Climatelabs  <- Climatelabs %>% filter(str_detect(WP, 'EC/Enseignant|Technicien|administratif|Manager'))
names(Climatelabs)


# Step 1: ---- 
## Analysis Por Persona -----
Sincro.per.participant <-  
   Climatelabs %>% group_by(Prenom, WP) %>% summarise(Jours = sum(Jours))

## Wider view per personna
Sincro.per.participant <-  
   Sincro.per.participant  %>% 
   pivot_wider(id_cols = WP, names_from = Prenom, values_from = Jours)

# Step 2 ---- 
## Analisys Total -----
Total <-
   Climatelabs %>%
   group_by(WP) %>% summarise(Total = sum(Jours))


# Step 3: ----
# Joining the Table Complete
Sincro <- 
   Sincro.per.participant %>% 
   left_join(Total, by = "WP")


## Split the columns
Sincro <-  
   Sincro %>% 
   separate(WP, c("Project", "WP", "Task", "Role"),sep = " / ") %>%
   select(-Project)

# ORdering factors
Sincro$WP <- gsub('&', "\n", Sincro$WP)
Sincro$WP <- 
   factor(Sincro$WP, 
          levels = c("Preparation", "Development", "Quality Plan", "Dissemination\nexploitation", "Management"))

# Changing the levels
Sincro$Role <- 
   factor(Sincro$Role, levels = c("Manager", "EC/Enseignant", "Technicien", "administratif"))
levels(Sincro$Role)[levels(Sincro$Role)=="administratif"] <- "Administratif"


# TAble ------
rm(Climatelabs, Sincro.per.participant, Total)








