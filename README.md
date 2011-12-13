# Delete That Damn Event

## Presentation

Recently, Google updated the behavior of its Calendar service in a very unpleasant way: events deleted in iCal on Mac OS X aren't removed from Google Calendar. The reason is Google don't want your Google Calendar events to be removed when you enable iCloud sync. More info [here][googleSupport].

Delete That Damn Event is a [SIMBL][SIMBL] Plugin that bypass that limitation by changing the User-Agent of iCal. Thus, Google Calendar servers will believe that the requests sent by iCal come from another application. And your deleted events will be deleted.

## Installation

This plugin requires Mac OS X 10.6 and higher.

 * Download and install [SIMBL][SIMBL].
 * Download the [plugin][directDownload].
 * Copy the the plugin in `~/Library/Application Support/SIMBL/Plugins`.
 * Restart iCal.
 * That's it!

## Known issues

**CAUTION:** Deleting an event will delete the event.

## License

This project is provided under the Modified BSD License. You can read more about it in the LICENSE.md file.

[SIMBL]: http://www.culater.net/software/SIMBL/SIMBL.php
[googleSUpport]: http://support.google.com/calendar/bin/static.py?hl=en&page=known_issues.cs
[directDownload]: https://github.com/downloads/octiplex/DeleteThatDamnEvent/DeleteThatDamnEvent%201.1.zip