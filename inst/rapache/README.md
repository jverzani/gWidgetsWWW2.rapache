rapache configuration
=====================

For now we have to add this to rapache for configuration:

```
LoadModule R_module /usr/libexec/apache2/mod_R.so

# Load required DBI and RMySQL packages
REvalOnStartup "library(gWidgetsWWW2.rapache)"

## from system.file("rapache", "www2.R", package="gWidgetsWWW2.rapache")
<Location /custom/gw>
        SetHandler r-handler
	RFileHandler /Library/Frameworks/R.framework/Versions/2.15/Resources/library/gWidgetsWWW2.rapache/rapache/www2.R
</Location>
```


The module location and location of `www2.R` depend on the installation. These came from a Mac OS X Mountain Lion install.

Later, the url "/custom/gw" will be customized, like through an call such as

```
REvalOnStartup "options(gWidgetsWWW2.rapache::base_url='gw')"
```

Then the Location will change, but for now the "/custom/gw" is hardcode to scripts, so can't readily be changed.
