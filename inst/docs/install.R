## run this from current directory
## eg. Rscript install.R 
require(knitr); require(markdown)
options(markdown.HTML.options=NULL)
knit2html("gWidgetsWWW2_rapache.Rmd")
file.copy("gWidgetsWWW2_rapache.html", "../extra/html", overwrite=TRUE)
