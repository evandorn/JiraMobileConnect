Pod::Spec.new do |s|
  s.name         = "JIRAMobileConnect"
  s.version      = "1.2.2"
  s.summary      = "Enables JIRA to collect user feedback and real-time crash reports."

  s.description  = <<-DESC
                   JIRA Mobile Connect enables JIRA to collect user feedback and real-time crash reports for your mobile apps. Key features include:

                   * In-app User feedback- Get feedback from your mobile users or testers
                   * 2-way Communications -Developers can follow up with users or testers for additional feedback on your app or notify them that their issue has been resolved!
                   * Rich Data Collection-  Capture text and audio comments, annotated screenshots, and map any custom application data to fields in JIRA
                   DESC

  s.homepage     = "https://bitbucket.org/atlassian/jiraconnect-ios"
  s.license      = "Apache License, Version 2.0"
  s.authors          = { "Nick Pellow" => "http://twitter.com/niick", "Thomas Dohmke" => "http://twitter.com/ashtom", "Stefan Saasen" => "http://twitter.com/stefansaasen", "Shihab Hamid" => "http://twitter.com/shihabhamid", "Erik Romijn" => "http://twitter.com/erikpub", "Bindu Wavell" => "http://twitter.com/binduwavell", "Theodora Tse" => "" }

  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/evandorn/JiraMobileConnect" }
  s.source_files = [
    'JIRAConnect/JMCClasses/Base/**/*.{h,m,mm}',
    'JIRAConnect/JMCClasses/Core/**/*.{h,m,mm}'
  ]
  s.public_header_files = [
    'JIRAConnect/JMCClasses/Base/**/*.{h}',
    'JIRAConnect/JMCClasses/Core/attachments/**/*.{h}',
    'JIRAConnect/JMCClasses/Core/sketch/**/*.{h}',
    'JIRAConnect/JMCClasses/Core/transport/**/*.{h}',
    'JIRAConnect/JMCClasses/Core/model/**/*.{h}',
    'JIRAConnect/JMCClasses/Core/queue/**/*.{h}',
    'JIRAConnect/JMCClasses/Core/audio/**/*.{h}'
  ]
  s.resources = [
    'JIRAConnect/JMCClasses/Base/**/*.{xib}',
    'JIRAConnect/JMCClasses/Core/**/*.{xib}',
    'JIRAConnect/JMCClasses/Resources/**/*.{png,bundle}'
  ]
  s.frameworks = 'CFNetwork', 'SystemConfiguration', 'MobileCoreServices', 'CoreGraphics', 'AVFoundation', 'CoreLocation'
  s.libraries = 'sqlite3'
  s.vendored_frameworks = "JIRAConnect/JMCClasses/libraries/CrashReporter.framework"

  s.requires_arc = true
end
