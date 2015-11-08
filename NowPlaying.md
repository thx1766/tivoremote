The data acquired from the TiVo provides an accurate snapshot of what is on the TiVo (it sometimes takes a few minutes after a recording starts before it shows up), unfortunately, navigating to the items is not as foolproof as it should be.  There are a few things that make this less reliable than it should be.
  * The Now Playing screen on the TiVo can be sorted in different ways, and there is no way for TiVoRemote to automatically determine these settings (and there is no good way to set these settings automatically).
  * Pulling up the Now Playing screen, or any folders, takes a variable amount of time, and may not respond to certain remote commands while the screen is loading.

There are new options on the settings screen for addressing the first problem (I don't think many people change the sort/group options very often, so I don't think this will be a big deal).  The second problem is more difficult.  It appears that Channel Up/Down, and the Up/Down commands get queued, but Select and Play do not.  Depending on what the TiVo is currently doing, and what it has done recently, different groups take different amounts of time to load.  This makes it difficult to create robust, repeatable test scenarios.

To address the second issue, there are new configuration settings in the remote.xml file in the **navigation** section (all times are in milliseconds).
  * Now Playing Load -- How long to wait after sending the Now Playing command before sending any other commands.
  * Page Load -- How long to wait after sending the select command to enter a group before sending any other commands.
  * Base Page -- Before sending a Select, or Play command, TiVoRemote will wait for this, and the following values.
  * Folder Size Factor --  Multiply this value times the number of elements in the current folder.
  * Page Down Factor -- Multiply this value times the number of times page down (channel down) gets sent.
  * Down Factor -- Multiply this value times the number of times down gets sent.

(There is also an "Entries Per Page" setting that specifies how many entries can be advanced with a channel up/down command.  I don't think this can be changed, but I'm not sure.)

If you find better settings (which shouldn't be too hard), please post them.