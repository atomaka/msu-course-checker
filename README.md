#MSU Course Checker

##Description
Monitor http://schedule.msu.edu if a course you needed to get into was full.  The base alert system only checks every twenty minutes and will only alert you if you are one of the top five in the queue.  This script avoids at least the second restriction.

##Dependencies
* Twilio account with credits
* Ruby

##Install
```
chmod +x check.rb
cp conf/settings.yml.sample conf/settings.yml
vim settings.yml
```

Edit the information as needed.


##Usage
Create a schedule on your computer that calls the script:

```
/path/to/check.rb SEMESTER SUBJECT COURSE [SECTIONS]
```

##Example
Setup a crontab:

```
*/2 * * * * /path/to/check.rb US13 IAH 241A 730 731
```

Will monitor for openings to IAH 241A sections 730 and 731 during the Summer Semester of 2013.

##Warnings
Once a section opens up, this script will **not** stop calling until the section has filled again or you have stopped the scheduler on your computer.
