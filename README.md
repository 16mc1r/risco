# risco
R isco 88 label recoding

Changing ISCO88 labels from one language to another for publication can be a pain. A challenge I faced when converting my results from the German Socieconomic Panel (SOEP) into english for a paper. In R there is the wonderful countrycode package that translates all sorts of countrycode schemes (e.g. OECD to Eurostat to ISO3 etc.). Sadly,  no such package exists for ISCO88 codes. 
So I made one.

# The R-ISCO88 relabeler: risco

## How do I get it?
You need the devtools package installed in R and then load the latest version of risco from Github. 

``` require(devtools)
install_github(“16mc1r/risco”)
```

## How does it work?

```
require(risco)
isco_relabel(isco_col, label_col, dest_language = “english”)
```

The core, and only, function of risco is the command isco_relabel() which has three arguments: 

– *isco_col* : The column in which your ISCO88 codes are stored. The package can handle all codes from two to four digits. 
– *label_col* : The column in which your current labels are stored. These are needed in the case that no match (more on that later) could be found. For example, when you merged some ISCO88 groups by hand due to a lack of people in these groups. 

*dest_language* : The destination language. The package provides German, English and French occupation labels. This defaults to English.  The codes are based on the label files of the [Warwick Institute for Employment Research](https://web.archive.org/web/20170117172404/http://www2.warwick.ac.uk/fac/soc/ier/research/classification/isco88). In R this is just a data.frame with four columns that hold the ISCO88 code and the labels in the three languages.

## Usage

Using the example code from the isco_relabel function 

```
#setting up the container for the results
res2 <- risco::risco_test_2
# adding German labels to the data
res2$german <- isco_relabel(isco_col = res2$isco_code, label_col = res2$english, dest_language = “german”)
```

### Input restrictions:
* The isco_col must be a numeric (i.e. of class integer or double)
* The label_col must be of the class “character”

Here I tell R that the isco88 codes are found in the “isco_code” column of the res2 data.frame, that the labels are in the column “english” and that I want to have them translated to German. 

Of course you could overwrite the original labels in “english” but I think its better to put them in a new column in the data frame holding your ISCO88 data. Therefore, I put them in res2$german. This allows you to compare them and check if the operation worked.

** image here**

Here it worked. Furthermore, we can see what happens when there are no matches to be found for that code, or the code is missing (NA): The package takes the label supplied in the function call(isco_relabel) and adds a “NO MATCH_” to the beginning so that you can easily spot errors. In addition R gives you the warning:

```
# function call
res2$german <- isco_relabel(isco_col = res2$isco_code, 
                                                                label_col = res2$english,
                                                                dest_language = “german”)
Warning message:
In isco_relabel(isco_col = res2$isco_code, label_col = res2$english,  :
  Some isco codes could not be matched! They are labeled with ‘NO MATCH’
```

## What do I do when it doesn’t work?
Firstly, see if there are error messages and what they tell you. Secondly, check whether the object you try to use the relabeler function on is a data.frame or a matrix. NB:The function’s output is a character vector.
Still doesn’t work? Well, I might have made a mistake or not encountered a bug yet so either write me an email or propose a change in the code on GitHub.

## Caveats in risco and isco
A general caveat when working with ISCO88 data is that the occupation codes can differ a bit from dataset to dataset. In the ISCO88 coding scheme, according to Elias and Birch (1994), armed forces codes start with 0. The SOEPlong v31.1 places them in 100. This can cause problems when you aggregate groups at the three-digit level so you might consider recoding them to a number where mistaking them for another group is not possible.


# References
Elias, P., & Birch, M. (1994). Establishment of Community-Wide Occupational Statistics:
ISCO 88 (COM), A Guide for Users. Institute for Employment Research. University of Warwick.
