#!/usr/bin/env ruby

require 'net/http'
require 'uri'
require 'twilio-ruby'
require 'yaml'

abort "usage: ./check.rb SEMESTER SUBJECT COURSE [SECTIONS]\n" unless ARGV.length > 2

settings = YAML.load_file('conf/settings.yml')

semesters = {
  'US13' => 'US131132summer 2013',      'FS13' => 'FS131134fall 2013',
  'SS14' => 'SS141136spring 2014',
  'US14' => 'US141142summer 2014',
}

semester = ARGV.shift
subject = ARGV.shift
course = ARGV.shift
sections = ARGV

abort "Requires a valid semester code\n" unless semesters.has_key?(semester)

data = {
  'Semester'        => semesters[semester],
  'Post'            => 'Y', 'Button'          => '', 'Online'           => '',
  'Subject'         => subject, 'CourseNumber'=> course,
  'Instructor'      => 'ANY',
  'StartTime'       => '0600', 'EndTime'      => '2350',
  'OnBeforeDate'    => '', 'OnAfterDate'      => '',
  'Sunday'          => 'Su', 'Monday'         => 'M', 'Tuesday'         => 'Tu',
  'Wednesday'       => 'W', 'Thursday'        => 'Th', 'Friday'         => 'F',
  'Saturday'        => 'Sa',
  'OnCampus'        => 'Y', 'OffCampus'       => 'Y', 'OnlineCourses'   => 'Y',
  'StudyAbroad'     => 'Y', 'MSUDubai'        => 'Y',
  'OpenCourses'     => 'A',
  'Submit'          => 'Search for Courses'
}

response = Net::HTTP.post_form(
  URI.parse('http://schedule.msu.edu/searchResults.asp'),
  data
)

courses = response.body.scan(/<a.*?title="(.*?) Section - LOG IN  to add Section (.*?) to your planner">.*<\/a>/)

open = Array.new
courses.each do |course|
  open << course.last if course.first == 'Open' && sections.include?(course.last)
end

if open.length > 0
  @client = Twilio::REST::Client.new settings['twilio']['sid'],
    settings['twilio']['token']

  @call = @client.account.calls.create(
    :from     => '+' + settings['application']['from'],
    :to       => '+' + settings['application']['to'],
    :url      => 'http://twimlbin.com/external/23144346c2f2a287'
  )
end
