library("dplyr")
library("ggplot2")

EPL = read.csv("EPLResults_NoSpace.csv") #read from csv
EPL = EPL %>% mutate(WinnerScore = ifelse(HomeScore>=AwayScore,HomeScore,AwayScore))
EPL = EPL %>% mutate(LoserScore = ifelse(HomeScore<=AwayScore,HomeScore,AwayScore))


scorigami = data.frame(table(EPL$LoserScore,EPL$WinnerScore))

names(scorigami)[1] = "Lose"
names(scorigami)[2] = "Win"
scorigami = scorigami[scorigami[,"Freq"] > 0,]

firstfile = file("first.txt","w")
latefile = file("late.txt","w")
f = function(row) {
    l = row[1]
    w = row[2]
    # print(c(w,l))
    first = head(EPL[EPL[,"WinnerScore"] == w & EPL[,"LoserScore"] == l,],1)[,c(1,2,3,4,5,6)]
    last = tail(EPL[EPL[,"WinnerScore"] == w & EPL[,"LoserScore"] == l,],1)[,c(1,2,3,4,5,6)]
}

apply(scorigami,1,f)
ggplot(scorigami,aes(x=Lose,y=Win,fill=Freq)) + ylab("Winning/Tying Team Score") + 
    xlab("Losing/Tying Team Score") + 
    ggtitle("Frequency of final scores in the Premier League from 1992/93 to 2019/20") + 
    geom_tile(aes(fill=Freq)) + geom_text(aes(label=Freq)) + 
    scale_fill_continuous(low="white",high="lightblue",guide="colorbar",na.value="black") +
    theme(
        plot.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
    )
ggsave("plot.png")
