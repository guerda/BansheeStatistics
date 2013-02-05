library("RSQLite")

con <- dbConnect(drv="SQLite", dbname="~/.config/banshee-1/banshee.db")

tables <- dbListTables(con)

countOfArtists <- dbGetQuery(conn=con, statement="SELECT COUNT(1) FROM CoreArtists")

barplotCount <- function(data,file,count=20) {
  png(file=file, width=800, height=800)
  palette(topo.colors(count))
  ylim <- c(0,max(data[,2])*1.1)
  print(ylim)
  p <- barplot(data[1:count,2], names.arg=data[1:count,1], legend.text=data[1:count,1], col=topo.colors(count), ylim=ylim, las=2)
  text(p, data[1:count,2], labels=data[1:count,2],pos=3)
  graphics.off()
}


genreGroupsSelect <- "Select genre, count(1) as count from coretracks where genre is not null group by genre order by count desc;"
genreGroups <- dbGetQuery(conn=con, statement=genreGroupsSelect)

barplotCount(genreGroups, file="Genre_Groups.png")

artistCountSelect <- "select a.name, count(1) as count from coretracks t left join coreartists a on a.artistid = t.artistId where a.name is not null group by t.artistid order by count desc;"
artistCount <- dbGetQuery(conn=con, statement=artistCountSelect)
barplotCount(artistCount, file="Artist_Count.png")


artistPlayCountSelect <- "select a.name, sum(playcount) as count from coretracks t left join coreartists a on a.artistid = t.artistid where a.name is not null group by t.artistid order by count desc;"
artistPlayCount <- dbGetQuery(conn=con, statement=artistPlayCountSelect)
barplotCount(artistPlayCount, file="Artist_Play_Count.png")

ratingCountSelect <- "SELECT t.Rating, count(1) AS count FROM CoreTracks t WHERE t.Rating > 0 GROUP BY t.Rating;"
ratingCount <- dbGetQuery(conn=con, statement=ratingCountSelect)
barplotCount(ratingCount, file="Rating_Count.png", count=5)

yearCountSelect <- "SELECT t.year, count(1) AS count FROM CoreTracks t WHERE t.year > 0 GROUP BY t.year;"
yearCount <- dbGetQuery(conn=con, statement=yearCountSelect)
barplotCount(yearCount, file="Year_Count.png", count=length(yearCount[,1]))


avgArtistRatingSelect <- "select a.Name, avg(t.Rating) as Rating, count(1) as Count from coretracks t left join coreartists a on a.artistid = t.artistid group by a.artistid order by Rating desc, Count DESC;"
avgArtistRating <- dbGetQuery(conn=con, statement=avgArtistRatingSelect)
barplotCount(avgArtistRating, file="Average_Artist_Rating.png")
