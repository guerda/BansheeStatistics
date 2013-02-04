library("RSQLite")

con <- dbConnect(drv="SQLite", dbname="~/.config/banshee-1/banshee.db")

tables <- dbListTables(con)

countOfArtists <- dbGetQuery(conn=con, statement="SELECT COUNT(1) FROM CoreArtists")

barplotCount <- function(data,file,count=20) {
  png(file=file, width=800, height=800)
  palette(topo.colors(count))
  p <- barplot(data[1:count,2], names.arg=data[1:count,1], legend.text=data[1:count,1], col=topo.colors(count), ylim=c(0,data[1,2]*1.1))
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

ratingHistogramSelect <- "SELECT t.Rating FROM CoreTracks t WHERE t.Rating > 0 ORDER BY 1 ASC;"
ratingHistogram <- dbGetQuery(conn=con, statement=ratingHistogramSelect)$Rating
png(file="Rating_Histogram.png", width=800, height=800)
hist(ratingHistogram, col=topo.colors(5))
graphics.off()
