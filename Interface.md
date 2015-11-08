With version .05, it is now possible to configure the appearance of the program.  The configuration information is stored in /Applications/TiVoRemote.app/remote.xml.

There are four parts of this file, **connections**, **functions**, **sections**, and **pages**.  There isn't too much that can be done with the first two (although if you want to create new buttons, adding entries to **functions** would be useful), but the last two offer a lot of possibilities for controlling the layout.

# sections #

**sections** are an abstraction for a subset of the elements of a page.  It is often useful to share common buttons across different pages, having the button information in a shared section will help keeping the pages in sync.  Sections do not need to define any specific location for which they apply.  Two sections can share space like spaces on a checkerboard.

**sections** are a collection of **buttons**.

## buttons ##

**buttons** define the buttons that will appear on the screen.
  * function -- This determines what action will be performed when the button is pressed.  The function must map to a previously defined function in **functions**.
  * connection -- The connection (maps to a connection defined in **connections**) that the button should apply to.
  * title -- The text that will appear on the button.
  * icon -- The image that will be displayed for the button.  The dimensions of the icon will determine the size of the button (no scaling takes place).
  * pressed-icon -- The image that will be displayed for the button when it is pressed.  If no **pressed-icon** is specified, it will default to **icon**.
  * xCoord -- The x coordinate for where the icon will be drawn.  (These are pixel coordinates. 0 - 320).  (This is the left edge of the icon.)
  * yCoord -- The y coordinate for where the icon will be drawn.  (These are pixel coordinates.  0 - 412?).  (This is the top edge of the icon.)
  * confirm -- If the button has the potential of causing problems when accidentally pressed, including this field will display this message in a dialog box before executing the command.
  * tag -- This is presently only used when determining if a button should be displayed when the "Show Standby" option is selected.


# pages #

In the simplest terms, a page is a collection of **sections**.  A page also has some other information, like a title (which is used for labeling the left navbar button), and a button (which is the button that appears on the navbar.  Unfortunately, this navbar button doesn't update when pages change).  The order of sections for a page does not matter.

**pages** is an array of 'dict's.  The user will be able to scroll between each of the pages.
The following keys are expected to be defined for each of the pages.
  * title -- The title of the page.  A string.
  * sections -- An array of the sections that make up this page.
  * background -- The image that will be displayed as the background for this page.
  * button -- The button that will appear on the navigation bar.