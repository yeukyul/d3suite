
##############
# chord chart
##############

library(chord)
df <- data.frame(incoming = c("A", "B", "C", "A"), 
                 outgoing = c("D", "E", "F", "A"), 
                 stringsAsFactors = F)
chord(df, "incoming", "outgoing")



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