require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))

    student_info_array = []

    doc.css(".student-card").each do |student|
      student_info = {
        :name => student.css("h4").text,
        :location => student.css("p.student-location").text,
        :profile_url => student.css("a")[0]["href"]
      }
      student_info_array << student_info
    end
    student_info_array
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))

    student_bios = {}

    social_media_links = doc.css("div.social-icon-container").css("a").collect {|o| o.attributes["href"].value}

    social_media_links.detect do |o|
      student_bios[:twitter] = o if o.include?("twitter")
      student_bios[:linkedin] = o if o.include?("linkedin")
      student_bios[:github] = o if o.include?("github")
      end

    student_bios[:blog] = social_media_links[3] if social_media_links[3] != nil
    student_bios[:profile_quote] = doc.css("div.vitals-text-container").css("div.profile-quote").text
    student_bios[:bio] = doc.css("div.details-container").css("div.description-holder").css("p").text

    student_bios
  end

end
binding.pry
