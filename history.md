#0.4.4
* By default Limited red is off unless ENV['LIMITED_RED'] is set

#0.3.10
* Experimental support for Rspec added (Joseph Wilk)

#0.3.9
* Limited Red will not cause the test run to abort if it cannot contact limited-red.com (for example if the internet is down). (Joseph Wilk) 

#0.3.8
* Limited no longer kills the Cucumber run if you do not have the correct config. It instead logs an error (Joseph Wilk)