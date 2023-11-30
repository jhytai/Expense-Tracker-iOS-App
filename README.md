# CPSC 411 - Final Project #

This is our submission for the Final Project.

## Project and Team Information ##

* Project: Expense Tracker mobile app for iOS
* Institution: California State University Fullerton (CSUF)
* Course: CPSC 411 - Mobile Device Application Programming (Fall 2023, Section 03, 13849)
* Team Name: iCode_Duology_4x

	* Name: Josue Han Yan Tai Liu
		* CWID: 885540690
		* Email: josue.tai@csu.fullerton.edu

	* Name: Maria Fernandez
		* CWID: 887569838
		* Email: mariaibis@csu.fullerton.edu

	* Name: Danyal Nemati
		* CWID: 886736347
		* Email: dnemati@csu.fullerton.edu

	* Name: Indrajeet Patwardhan
		* CWID: 886908821
		* Email: Indrajeet2002@csu.fullerton.edu

## Notes ##

* Developed with Xcode 15.0.1 (based on iOS 17.0.1 - iPhone 15 Pro - iPad 10th gen)

## Development Milestones ##

- [x] Launching & Landing pages
- [x] Login & Create Acc pages (Google firebase authentication)
- [x] Expenses input page
- [x] Expenses by Category viewer page
- [x] Expenses History viewer page
- [x] Double-check project requirements
- [x] Testament Document

## Project Requirements ##

- [x] API Based User Interface

	- At least one View should be created, setup, and constrained programmatically. If you wish to code your entire app using API Based User Interface and avoid Storyboard altogether, you may do so. But only if you wish.

- [x] Interactive Assets

	- Your app should have at least two distinct assets utilized within the Storyboard/scene, somewhere.
	- The user should be able to cause at least one of the resources to change via interaction (i.e., callback). Example: UIImageView holding a custom image for your app, which changes when the user clicks some button (or when the user has changed something, somewhere).
	- At least one asset should change/adapt based on device configuration or other qualifier. Example: Logo that changes depending on screen size or orientation or whether the app runs on an iPhone/iPad.

- [x] Text Input and Delegation

	- Your app must use at least two different types of software keyboards. Your app must also detect the type of the keyboard at some point and use it to filter the user’s invalid character input.

- [x] Internationalization and Localization

	- Your app must be prepared for internationalization and localized to at least two languages (aside from English), and two total regions. The regions must use different decimal separators or some other significant aspect that can be demonstrated in class.
	- This should include translations both for the Storyboard and internal strings using NSLocalizedString.
	- Example: English/US, Spanish/Spain, French/France.

- [x] RESTful Interactivity

	- The app should communicate with a RESTful API server using the classes **URLSession**,
**URLRequest**, **Codable**, **JSONDecoder**, etc, as well as the URLSession’s data task, dedicated data classes, and so forth.
	- The app should pull some sort of data from the remote API using an HTTP GET request and render it somewhere in the local app. The app should also allow the local user to provide some sort of data that will be sent to the remote API using an HTTP POST request.
	- When the user exits and relaunches the app, data previously sent to the remote API should be fetched from the remote API and shown to the user. The previously sent data should not be saved using local persistence, but fetched from the live server instead, to prove the app is “cloudified” in some way.
	- You may choose to use an existing API or create one yourself, as long as your app is able to both create data on the remote server, and fetch those records.

- [x] Persistent settings

	- Your app should allow the user to save settings within the app using the **UserDefaults** class. The settings should persist after the app is exited and relaunched. You may choose any data you’d like for these settings, but your app should have at least two.

- [x] File persistence

	- Your app should have the ability to save files. At least one area of the app should save some sort of file (image file, text data file, internet download, etc), and have the ability to view or recall those files across app restarts.
	- Your app should also utilize file caching in at least one area. One good example for this would match our slideshow, where an image is downloaded from the internet and saved to cache, then subsequent accesses of that images are pulled from the cache rather than the internet.

- [x] Database persistence

	- Your app should allow the user to save items to a local SQLite database, utilizing **Core Data**. The user should be able to save an unlimited number of these items, and view them somehow. The data should survive across app exits.
	- This requirement may be tweaked slightly the week before presentations or converted to extra credit, if needed.

- [x] Clear Separation of Concerns (MVC)

	- Your code has been decoupled and separated into Model / View / Controller modules. Models appear in a separate folder/directory.
