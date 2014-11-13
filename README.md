# dplyrNetezza

An R package that provides a database interface to Netezza.

This package wraps Netezza JDBC driver and extends dplyr.

#Installation

Install via github:

```R
install.packages('devtools')
devtools::install_github('chappers/dplyrNetezza')
```

#Usage

```R
library(RNetezza)

# JDBC URL FORMAT: jdbc:netezza://<host>:<port>/<dbname>
nzr <- src_JDBC(drv = NetezzaSQL(), url=url, user=user, password=password)

# Caches data from Netezza
NZtable <- tbl(nzr, "NZtable")
```

Normal `plyr` actions should then be able to take place.

#Credits

All credit goes to the projects below that inspired and make up parts of dplyrNetezza:

*  [dplyrJDBC](https://github.com/jimhester/dplyrJDBC) and [dplyr.sqlserver](https://github.com/hs3180/dplyr.sqlserver): which served as the boilerplate for this project.  
*  [dplyr](https://github.com/hadley/dplyr) : with which this project would otherwise not be possible.

