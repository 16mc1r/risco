# risco
R isco 88 label recoding

Changing ISCO88 labels from one language to another for publication can be a pain. A challenge I faced when converting my results from the German Socieconomic Panel (SOEP) into english for a paper. In R there is the wonderful countrycode package that translates all sorts of countrycode schemes (e.g. OECD to Eurostat to ISO3 etc.). Sadly,  no such package exists for ISCO88 codes. 
So I made one.

# The R-ISCO88 relabeler: risco

## How do I get it?
You need the devtools package installed in R and then load the latest version of risco from Github. 
> require(devtools)
install_github(“16mc1r/risco”)

