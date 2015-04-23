# Terminal Tools Site Sync Core

Core for syncing site assets and databases between local development 
environments to/from (or between) test/stage/live environments
with [Terminal Tools](https://github.com/titledk/ttools-core)

You'll need to add (or write) an additional framework specific module
to make this work with your framework.

Available modules:

* [Wordpress Site Sync](https://github.com/CPHCloud/ttools-sitesync-wordpress)


Under development:

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

TODO: it would make more sense for the keep option to also be environment specific

    Sitesync:
      FrameworkModule: 'ttools/sitesync-silverstripe'
      DumpBackupKeep: 2
