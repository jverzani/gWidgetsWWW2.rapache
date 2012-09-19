rapache configuration
=====================

We need to install `gWidgetsWWW2.rapache` so that the apache process
has access and then configure `rapache` along the lines of:

```
## only if not already configured for rapache
LoadModule R_module /usr/libexec/apache2/mod_R.so

## Simple configuration. Here we modify value. Could also move script and edit.
RSourceOnStartup('system.file("rapache", startup.R", package="gWidgetsWWW2.rapache")')
## override to look in more places than default
REvalOnStartup "options('gWidgetsWWW2.rapache::script_base'=c(system.file('examples', package='gWidgetsWWW2.rapache'), '/tmp/','/var/www/gw_scripts'))"

## LimitRequestBody puts cap on upload size. Set to 0 for unlimited
<Location /gw>
	  LimitRequestBody 1024000
        SetHandler r-handler
        ## from system.file("rapache", "www2.R", package="gWidgetsWWW2.rapache")
	RFileHandler /Library/Frameworks/R.framework/Versions/2.15/Resources/library/gWidgetsWWW2.rapache/rapache/www2.R
</Location>
```


The module location and location of `www2.R` depend on the
installation. These came from a Mac OS X Mountain Lion install.

The two files ("startup.R" and "www2.R") can (should?) be moved out of
the package tree and edited, especially the "startup.R" file. When
done, you can edit some variables that effect the operation.
