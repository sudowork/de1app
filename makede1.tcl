#!/usr/local/bin/tclsh

source pkgIndex.tcl
package require de1_utils
package require de1_vars
package require de1_misc
package provide de1plus 1.0
#package require md5
package require sha256
package require crc32
package require snit
package require de1_gui 

# optionally purge the source directories and resync
# do this if we remove files from the sync list
#file delete -force /d/download/sync/de1plus
#file delete -force /d/download/sync/de1
#file delete -force /d/download/desktop/osx/DE1PLUS.zip
#file delete -force /d/download/desktop/source/de1plus_source.zip

skin_convert_all
make_de1_dir

cd "[homedir]/desktop_app/osx"
exec zip -u -x CVS --exclude="*.DS_Store*" --exclude="*CVS*" -r /d/download/desktop/osx/DE1PLUS.zip DE1+.app

cd "/d/download/sync"
exec zip -u -x CVS --exclude="*.DS_Store*" --exclude="*CVS*" -r /d/download/desktop/source/de1plus_source.zip de1plus


