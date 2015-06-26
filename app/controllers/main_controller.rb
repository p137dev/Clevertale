class MainController < ApplicationController
  def home
  end
  
  def create
    
    require 'rubygems'
    require 'nokogiri'
    require 'open-uri'
    require 'wicked_pdf'
    require 'cleverbot-api'
    require 'securerandom'
    
    # Note to self: if this project gets bigger, you might want to use task backgrounding...
    
    # Bigger arrays go here...
    
    traits = %w[brave cowardly calm wicked righteous chaotic lazy clever stupid mysterious]
    classes = %w[wanderer knight peasant hunter magician wizard]

    # Basic data...
    
    cleverbot = CleverBot.new
    
    case rand(0..1)
      when 0
        # woman!
        name = Nokogiri::HTML(open('https://www.randomlists.com/random-girl-names')).xpath('//*[@id="result"]/li[1]/div/span').text
        pronouns = ["she", "her", "her"]
      when 1
        # man!
        name = Nokogiri::HTML(open('https://www.randomlists.com/boy-names')).xpath('//*[@id="result"]/li[1]/div/span').text
        pronouns = ["he", "his", "him"]
    end
    
    place = %w[forest desert city town].sample
    occupation = classes.sample
    weapon_name = Nokogiri::HTML(open('http://tvtropes.org/pmwiki/randomitem.php?p=1')).xpath('//*[@id="mp-pusher"]/div/div/div[3]/div[3]/div[3]/div/h1/span').text
    weapon_type = Nokogiri::HTML(open('https://www.randomlists.com/things')).xpath('//*[@id="result"]/li[1]/div/span[2]').text
    
     
    # Which story?
    
    story = "A #{traits.sample(2).join(", ")} #{occupation} called #{name} #{%w[wandered hurried walked trekked rode].sample} through the #{place}.\n"
    
    case rand(1..1)
      when 1
      
      close_person = %w[sister lover mom grandma].sample
      trouble = %w[hydra assassin dragon vampire ghost].sample
      
      story << "#{pronouns[0].capitalize} was #{%w[greatly exceptionally extremely extraordinarily].sample} #{%w[eager inclined longing yearning craving zealous].sample} to see #{pronouns[1]} #{close_person}, who waited for #{pronouns[2]} at the end of it.\n"
      story << "However, this tale couldn't have gone without difficulties... A #{trouble} appeared on #{name}'s way.\n"
      
      story << "-#{%w[greeting hello welcome hail].sample.capitalize}, said #{name}.\n"
      story << "-#{cleverbot.think "Hello!"}, answered the #{trouble}.\n"
      story << "-What do you want from me?!, asked the #{occupation} with #{%w[anxiety zeal worry wail].sample}.\n"
      story << "-#{cleverbot.think "What do you want from me?!"}, the #{trouble} responded and attacked #{pronouns[2]}.\n"
      story << "#{name} took out #{pronouns[1]} most prized weapon named 'The #{weapon_name}' which was, in fact, a #{weapon_type}. "
      
      damage = rand(1..100)
      puts damage
      
      case damage
        when (1..60)
          story << "#{pronouns[0].capitalize} swung it with power. This was enough to slay the #{trouble}.\n"
          password = SecureRandom.urlsafe_base64(5)
          story << "'-You have bested me...', uttered the #{trouble}. 'The password is... #{password}... you will need it later...', the #{trouble} added and disappeared."
          # To be continued.
        when (60..100)
          story << "#{pronouns[0].capitalize} swung it lightly... definitely not hard enough to slay the #{trouble}."
          # To be continued.
      end
      
    end
    
    
    # Now, let's make a neat PDF with the story.
    
    pdf = WickedPdf.new.pdf_from_string(story)
    
    save_path = Rails.root.join('pdfs', "#{name}-#{Time.now.to_i}.pdf")
    
    File.open(save_path, 'wb') do |file|
      file << pdf
    end
    
    File.open(save_path, 'r') do |f|
      send_data f.read.force_encoding('BINARY'), :filename => save_path, :type => "application/pdf", :disposition => "inline"
    end
    
    File.delete(save_path)
    
  end
    
    
    

  def about
  end
  
end
