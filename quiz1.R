con <- file("final/en_US/en_US.twitter.txt", "r")
a_twit <- readLines(con)
close(con)

con <- file("final/en_US/en_US.blogs.txt", "r")
a_blogs <- readLines(con)
close(con)

con <- file("final/en_US/en_US.news.txt", "r")
a_news <- readLines(con)
close(con)

head(twit)

max(stringr::str_length(news))
max(stringr::str_length(blogs))

sum(grepl(pattern = "love",x = twit))/sum(grepl(pattern = "hate",x = twit))

twit[grepl(pattern = "biostats",x = twit)]
A computer once beat me at chess, but it was no match for me at kickboxing

sum(twit[grepl(pattern = "A computer once beat me at chess, but it was no match for me at kickboxing",x = twit)])
a <- stringr::str_detect(twit,"(A computer once beat me at chess\\, but it was no match for me at kickboxing)")
twit[!is.na(a)]
