rapache configuration
=====================

For now we have to add this to rapache for configuration:

```
LoadModule R_module /usr/libexec/apache2/mod_R.so

# Load required DBI and RMySQL packages
## FILE is from <- system.file("rapache", "startup.R", package="gWidgetsWWW2.rapache")
RFileHandler FILE
## from system.file("rapache", "www2.R", package="gWidgetsWWW2.rapache")
<Location /custom/gw>
        SetHandler r-handler
	RFileHandler /Library/Frameworks/R.framework/Versions/2.15/Resources/library/gWidgetsWWW2.rapache/rapache/www2.R
</Location>
```


The module location and location of `www2.R` depend on the installation. These came from a Mac OS X Mountain Lion install.

The two files ("startup.R" and "www2.R") can (should) be moved out of
the package tree and edited, especially the "startup.R" file. When
done, you can edit some variables that effect the operation.  For now
the "/custom/gw" is hardcoded into scripts, so can't readily be
changed.
