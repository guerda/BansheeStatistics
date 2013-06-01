library("RSQLite")
library("hexbin")

con <- dbConnect(drv="SQLite", dbname="~/.config/banshee-1/banshee.db")

tables <- dbListTables(con)

countOfArtists <- dbGetQuery(conn=con, statement="SELECT COUNT(1) FROM CoreArtists")

barplotCount <- function(data,file,count=20, title) {
  png(file=file, width=800, height=800)
  palette(topo.colors(count))
  ylim <- c(0,max(data[,2])*1.1)
  print(ylim)
  p <- barplot(data[1:count,2], names.arg=data[1:count,1], legend.text=data[1:count,1], col=topo.colors(count), ylim=ylim, main=title, xaxt="n")
  labs <- paste(data[1:count,1])
  text(p, par("usr")[3]-1, labels=labs, xpd=TRUE, srt=45, adj=1)
  text(p, data[1:count,2], labels=data[1:count,2],pos=3, mgp=c(3,.5,2))
  graphics.off()
}


genreGroupsSelect <- "SELECT t.genre, count(1) AS count FROM CoreTracks t WHERE t.genre IS NOT NULL AND t.PrimarySourceID = 1 GROUP BY t.genre ORDER BY count DESC;"
genreGroups <- dbGetQuery(conn=con, statement=genreGroupsSelect)
barplotCount(genreGroups, file="Genre_Groups.png", title="Most Tracks per Genre")

artistCountSelect <- "SELECT a.name, count(1) AS count FROM coretracks t LEFT JOIN coreartists a ON a.artistid = t.artistId WHERE a.name IS NOT NULL AND t.PrimarySourceID = 1 GROUP BY t.artistid ORDER BY count DESC;"
artistCount <- dbGetQuery(conn=con, statement=artistCountSelect)
barplotCount(artistCount, file="Artist_Count.png", title="Artists With the Most Tracks")

artistPlayCountSelect <- "SELECT a.name, SUM(playcount) AS count FROM coretracks t LEFT JOIN coreartists a ON a.artistid = t.artistid WHERE a.name IS NOT NULL AND t.PrimarySourceID = 1 GROUP BY t.artistid ORDER BY count DESC;"
artistPlayCount <- dbGetQuery(conn=con, statement=artistPlayCountSelect)
barplotCount(artistPlayCount, file="Artist_Play_Count.png", title="Most Played Artists")

ratingCountSelect <- "SELECT t.Rating, count(1) AS count FROM CoreTracks t WHERE t.Rating > 0 AND t.PrimarySourceID = 1 GROUP BY t.Rating;"
ratingCount <- dbGetQuery(conn=con, statement=ratingCountSelect)
barplotCount(ratingCount, file="Rating_Count.png", count=5, title="Count of Tracks Per Rating")

yearCountSelect <- "SELECT t.year, count(1) AS count FROM CoreTracks t WHERE t.year > 0 AND t.PrimarySourceID = 1 GROUP BY t.year;"
yearCount <- dbGetQuery(conn=con, statement=yearCountSelect)
barplotCount(yearCount, file="Year_Count.png", count=length(yearCount[,1]), title="Count of Tracks Per Year")

avgArtistRatingSelect <- "SELECT a.Name, round(avg(t.Rating),2) as Rating, count(1) AS Count FROM coretracks t LEFT JOIN coreartists a ON a.artistid = t.artistid where a.ArtistId in (Select ArtistId FROM (Select a1.ArtistID, COUNT(1) from CoreArtists a1 left join CoreTracks t1 on t1.ArtistId = a1.ArtistId WHERE t1.PrimarySourceID = 1 GROUP BY a1.ArtistID ORDER BY 2 DESC LIMIT 10)) AND t.PrimarySourceID = 1 GROUP BY a.artistid ORDER BY Rating desc, Count DESC;"
avgArtistRating <- dbGetQuery(conn=con, statement=avgArtistRatingSelect)
barplotCount(avgArtistRating, file="Average_Artist_Rating.png", title="Average Rating per Artist")

png(file="Artist_Ratings.png",width=800,height=800)
artistRatingsSelect <- "SELECT t.Rating, a.Name FROM coretracks t LEFT JOIN coreartists a ON a.ArtistID = t.ArtistID WHERE t.Rating > 0 AND a.ArtistId in (Select ArtistId FROM (Select a1.ArtistID, COUNT(1) from CoreArtists a1 left join CoreTracks t1 on t1.ArtistId = a1.ArtistId AND t1.PrimarySourceID = 1 GROUP BY a1.ArtistID ORDER BY 2 DESC LIMIT 10)) AND t.PrimarySourceID = 1 ORDER BY a.Name ASC;"
artistRatings <- dbGetQuery(conn=con, statement=artistRatingsSelect)
boxplot(artistRatings$Rating~artistRatings$Name, ylim=c(0,5), las=2)
graphics.off()

png(file="Rating_PlayCount.png", width=800, height=800)
 select <- "SELECT t.Rating, t.PlayCount FROM CoreTracks t WHERE t.PrimarySourceId = 1"
data <- dbGetQuery(conn=con, statement = select)
plot(hexbin(data))
graphics.off()
