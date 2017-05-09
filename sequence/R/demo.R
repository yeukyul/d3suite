
##############
# chord chart
##############

library(chord)
df <- data.frame(incoming = c("A", "B", "C", "D"), 
                 outgoing = c("C", "D", "E", "F"), 
                 stringsAsFactors = F)
df <- data.frame(incoming = c("San Francisco", "Hong Kong", "Tokyo", "Seoul", "Hong Kong", "Singapore", "Singapore", "London"), 
                 outgoing = c("New York", "Tokyo", "London", "Okinawa", "New York", "New York", "Ho Chi Minh City", "Beijing"), 
                 stringsAsFactors = F)
chord(df, "incoming", "outgoing")

routes <- read.csv("https://raw.githubusercontent.com/jpatokal/openflights/master/data/routes.dat", header=F)
colnames(routes) <- c("airline", "airlineID", "sourceAirport", "sourceAirportID", "destinationAirport", 
                      "destinationAirportID", "codeshare", "stops", "equipment")
routes_short <- routes[1:50, ]
chord(routes, "sourceAirport", "destinationAirport")



##############
# sequence sunburst
##############

#library(sequence)
#sequence(Cars93, split_on=c("DriveTrain", "Origin", "Man.trans.avail"))



##############
# jsplot
##############

#library(magrittr)
#library(jsplot)
#ordered.df <- data.frame(x = 1:20, y = sample(1:100, 20))
#ordered.plot <- jsplot(ordered.df) %>% 
#               svg_circle(x="x", y="y",axis=F) %>% 
#               svg_line(x="x", y="y",axis=F) %>% 
#               jstitle("Random graph")
#ordered.plot %>% render()