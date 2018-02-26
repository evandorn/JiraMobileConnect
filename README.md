# JIRA Mobile Connect for iOS 7 and earlier

JIRA Mobile Connect (JMC) is an iOS library that can be embedded into any iOS app to provide following extra functionality:

*   **Real-time crash reporting**, have users or testers submit crash reports directly to your JIRA instance.
*   **User or tester feedback** views that allow users or testers to create bug reports within your app.
*   **Rich data input**, users can attach and annotate screenshots, leave a voice message, and have their location sent.
*   **Two-way communication with users**, thank your users or testers for providing feedback on your app!

## Changelog

Version | Description
--- | --- 
**2.0.0 Alpha 2** | If you are developing for iOS 8+, you should use JIRA Mobile Connect 2, which is a full re-write in the Swift programming language. You can find it in a separate Git repository here: [https://bitbucket.org/atlassian/jiraconnect-apple](https://bitbucket.org/atlassian/jiraconnect-apple)
**1.2.2** | JJIRA Mobile Connect 1 should only be used if you are developing for iOS 7 and earlier.

## Screenshots

![Report Issue Screen](https://bitbucket.org/atlassian/jiraconnect-ios/wiki/small_report-issue.png) ![Crash Report Dialog](https://bitbucket.org/atlassian/jiraconnect-ios/wiki/small_crash-report.png) ![2-Way Communications](https://bitbucket.org/atlassian/jiraconnect-ios/wiki/small_replies-view.png)

## Requirements

*   iOS 7.0 and earlier
*   Xcode 7.0+ _(Xcode 7.3.1 was used for these instructions)_
*   A JIRA Software instance _(if you don't have an instance, go to [go.atlassian.com/cloud-dev](http://go.atlassian.com/cloud-dev) and sign up for a free Cloud development environment)_
*   [JIRA Mobile Connect Plugin](https://plugins.atlassian.com/plugin/details/322837) _(this is only required if you are hosting the JIRA Software instance on your own server)_

## To install JIRA Mobile Connect into your current project:

1.  Get JIRA Mobile Connect by cloning the repository or downloading the latest release:
    *   `hg clone sh://hg@bitbucket.org/atlassian/jiraconnect-ios` 
    *   Latest release: [https://bitbucket.org/atlassian/jiraconnect-ios/get/tip.zip](https://bitbucket.org/atlassian/jiraconnect-ios/get/tip.zip)
2.  Open your project in Xcode, and click **Files** > **Add Files to "<YourProjectName>"**
3.  Navigate to the **jiraconnect-ios/JIRAConnect** directory for the repository you cloned earlier, and add the entire **JMCClasses** directory to your project.
    *   If the project you are integrating already contains the **Reachability** or **PLCrashReporter** libraries, remove those from the **JMCClasses/Libraries** directory.
    *   If your project does _not_ contain a JSON parsing library, then add the **SBJSON** library from **Support/SBJSON** to your project.
4.  Click the project (top-most) element in the file/groups tree. It should have a label that is the same as your project name.
5.  In the header of the main window, click **Build Phases** (located between to **Build Settings** and **Build Rules**).
6.  Click **Link Binary with Libraries** to expand the section, then click the **+** symbol.
7.  Add the iOS built-in frameworks:
    *   AVFoundation.framework
    *   CFNetwork.framework
    *   CoreGraphics.framework
    *   CoreLocation.framework
    *   libsqlite3.tbd _(this is used to cache issues on the device)_
    *   MobileCoreServices.framework
    *   SystemConfiguration.framework
8.  Build your App, and ensure there are no errors.
    *   If you wish to enable JMC debug logging in the console, define the '`JMC_DEBUG=1`' for the **Preprocessor Macro** of your build target. To do this,   

        1.  Navigate to **Build Settings** and look for the **Apple LLVM 7.1 - Preprocessing** section on the page. 
        2.  Hover over **Debug** and click the **+** icon, then add `JMC_DEBUG=1`        

## JIRA configuration

JIRA Mobile Connect needs to enabled in JIRA on a per project basis, otherwise it will not work with your app. Remember, if you are hosting your own JIRA instance, you will need to install the JIRA Mobile Connect plugin on your server before you can enable it. 

To enable JIRA Mobile Connect for a project in JIRA:

1.  Navigate to the desired project > **Project Settings**.
2.  Find the **Settings** section on the page and click **Enable** for the **JIRA Mobile Connect** setting.  
    This will enable the JIRA Mobile Connect plugin for the project, as well as create a user ('jiraconnectuser') in JIRA that is used to create all feedback and crash reports. 
3.  To enable the user to create tickets, you must grant it permission to create issues in the project. To do this, grant the 'Create Issues' permission to the 'jiraconnectuser' user. You can do this by adding the user to a group or project role that has the 'Create Issues' permission or grant the permission to the user directly (see [Managing project permissions](https://confluence.atlassian.com/display/AdminJIRACloud/Managing+project+permissions) for help).


## Using JIRA Mobile Connect in your app

### Set up JIRA Mobile Connect

1.Edit the **AppDelegate.m** file in your project and add the following code to import the **JMC.h** header file.
```
#import "<path-to-jiraconnect-ios-directory>/jiraconnect-ios/JIRAConnect/JMCClasses/Base/JMC.h"
```
2.Find the `-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions` method in the **AppDelegate.m** file, and add the following code:

```
[[JMC sharedInstance] configureJiraConnect:@"https://example-dev.atlassian.net/"
                      projectKey:@"EXAMPLEKEY"
                      apiKey:@"myApiKey"];
```
*   `configureJiraConnect` — Replace the string `@"https://example-dev.atlassian.net/"` with the location of the JIRA instance that you will be connecting to. We recommend that you use https (not http) to ensure secure communication between JMC and the User.
*   `projectKey` — Replace the string `@"EXAMPLEKEY"` with the name of the project that you will be using to collect feedback from users or testers
*   `apiKey` — If the JIRA Mobile Connect plugin in JIRA has an API Key enabled, update the `apiKey` parameter with the key for your project

### Create a trigger

A trigger mechanism will allow users to invoke the Feedback view. This typically goes on the 'About' or 'Info' view, or you could even add it to the shake gesture.

Add the following code to your **AppDelegate.m** to provide a trigger mechanism:  
_Note, the `UIViewController` returned by `viewController` is designed to be presented modally. If your info `ViewController` is in a `UINavigationController` stack, then the code below will show both the feedback view and the history view._
```
- (void)viewDidLoad
{
    self.navigationItem.rightBarButtonItem =
    [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                   target:self
                                                   action:@selector(showFeedback)] autorelease];
}
 
-(void) showFeedback
{
    [self presentModalViewController:[[JMC sharedInstance] viewController] animated:YES];
}
```

`[[JMC sharedInstance] viewController]` will return the 'Create Issue' view until the user creates feedback. Once the user has created feedback, the 'Issue Inbox' view is displayed and the user can tap the 'Create' icon to send more feedback. You can modify this behaviour, if you choose:

*   If you would like your users to always access the 'Create Issue' view, then you can do so by presenting the `[[JMC sharedInstance] feedbackViewController]` directly. Use the following code to present just the create issue ViewController programatically: 
```
    - (IBAction)triggerCreateIssueView
    {
        [self presentModalViewController:[[JMC sharedInstance] feedbackViewController] animated:YES];
    }
```
*   If you want to present the inbox directly, use `[[JMC sharedInstance] issuesViewController]` instead.

### Advanced configuration options

There are some other configuration options you can choose to set, if the defaults aren't what you require. To do this, explore the `[JMC sharedInstance] configureXXX]` methods. The `JMCOptions` object supports most of the advanced settings. This object gets passed to JIRA Mobile Connect when configure is called, i.e during `applicationDidFinishLaunching`. The `JMCOptions` class lets you configure:

*   screenshots
*   voice recordings
*   location tracking
*   crash reporting
*   custom fields
*   the application's Console Log (NSLog output)
*   UIBarStyle for JMC Views
*   JIRA Project Key
*   JIRA instance URL
*   API Key

See the the [JMC.h](https://bitbucket.org/atlassian/jiraconnect-ios/src/e97e35eef7dfd7c3ca78b70bd0e882679f979613/JIRAConnect/JMCClasses/Base/JMC.h?at=default) file for all `JMCOptions` available.

The **JMCCustomDataSource** can be used to provide JIRA with extra data at runtime. The following is supported:

*   an extra attachment (e.g. a database file)
*   customFields (these get mapped by key name if a custom field of the same name exists for the JIRA project)
*   issue components to set (e.g. iOS)
*   JIRA issue type - maps the name of the issue-type to use in JIRA. e.g. a Crash --> Bug, Feedback --> Improvement.
*   notifierStartFrame, notifierEndFrame: used to control where the notifier is animated from and to.

See the [JMCCustomDataSource.h](https://bitbucket.org/atlassian/jiraconnect-ios/src/e97e35eef7dfd7c3ca78b70bd0e882679f979613/JIRAConnect/JMCClasses/Base/JMCCustomDataSource.h?at=default) file for more information on these settings.

### Integration Notes

*   The notification view that slides up when a notification is received, is added to the application's keyWindow.

### Testing and distributing your app

*   If you want to test the crash reporting, adding a `CFRelease(NULL);` statement somewhere in your code.

*   Before distributing your software, you must include the contents of the **JIRAConnect/JMCClasses/LICENSES **file somewhere within your app, along with the License information that you can find at the bottom of this page.

## Need Help?

If you have any questions regarding JIRA Mobile Connect, please ask on [Atlassian Answers](https://answers.atlassian.com/tags/jira-mobile-connect/).

You can also check out our sample iPhone and iPad Apps in the [jiraconnect-ios/samples](https://bitbucket.org/atlassian/jiraconnect-ios/src/e97e35eef7dfd7c3ca78b70bd0e882679f979613/samples/?at=default) directory. AngryNerds and AngryNerds4iPad both demonstrate submitting feedback and crashes to a JIRA project.

## License

Copyright 2011-2012 Atlassian Software.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use these files except in compliance with the License. You may obtain a copy of the License at [http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0).

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

## Third party Package - License - Copyright / Creator

plcrashreporter MIT Copyright (c) 2008-2009 [Plausible Labs Cooperative, Inc.](http://code.google.com/p/plcrashreporter/)

crash-reporter Copyright (c) 2009 Andreas Linde & Kent Sutherland.

UIImageCategories Created by [Trevor Harmon.](http://vocaro.com/trevor/blog/2009/10/12/resize-a-uiimage-the-right-way/)

FMDB MIT Copyright (c) 2008 [Flying Meat Inc.](http://github.com/ccgus/fmdb)