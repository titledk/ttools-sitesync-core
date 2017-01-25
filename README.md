# Terminal Tools Site Sync Core

Core for

* syncing site assets and databases between environments
* dumping a site for backups - can be used together with [ttools-backups](https://github.com/titledk/ttools-backups)

You'll need to add (or write) an additional framework specific module
to make this work with your framework.

Available modules:

* [Wordpress Site Sync](https://github.com/CPHCloud/ttools-sitesync-wordpress)
* [SilverStripe Site Sync](https://github.com/titledk/ttools-sitesync-silverstripe)



## Installation

* run `git submodule add https://github.com/titledk/ttools-sitesync-core.git ttools/sitesync-core`
* Add the following to your `ttools-config.yml` (setting the framework module you're using):

	Sitesync:
		FrameworkModule: 'ttools/sitesync-silverstripe'


## Configuration options

Configuration options have been added only as needed this far.

### Environment specific

    Environments:
      Live:
        Sitesync:
          BackupPath: "/backups/mysite"

### Global

    Sitesync:
      FrameworkModule: 'ttools/sitesync-silverstripe'
      DumpBackupKeep: 2
      #don't run backups before overwriting a site (on large sites this can become tedious)
      SkipBackups: true
      #don't sync files - this may be beneficial on sites with huge amounts of assets - NEEDS TO BE IMPLEMENTED BY EACH MODULE SEPARATELY
      SkipFiles: true

These settings can also be environment specific, in that case create a `config_local.yml` file which you'll place next to the `config.yml` file, it could e.g. look like this:

```
Sitesync:
  SkipBackups: true
```
