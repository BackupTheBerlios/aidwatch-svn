require 'fileutils'
class WikiHelperController < ApplicationController
  REGEXPATTERN = /^\$wgSpamRegex\s=\s(.*)/
  def update_regexp
    oldgid = nil
    if params[:approved]
      regexp = get_regexp("http://www.myseattle.com/mediawiki/wgSpamRegex.txt")
      raise "Can't find valid wgSpamRegex" unless regexp.length > 0
      update_wiki(regexp)
      flash[:notice] = "Congrats, updated wgSpamRegex to\n
                        $wgSpamRegex = #{regexp}"
    end
 #   rescue
 #   flash[:notice] = "Sorry, you're running as: #{$!}"
    ensure
#    flash[:notice] = "ensuring gid reset"
 #   Process::Sys.setegid(oldgid) if oldgid
  end

  private
  def get_regexp(uri)
    regexfile = "/tmp/wgSpamRegex.txt"
    # grab regexp file and save in tmp location
    system("wget #{uri} -O #{regexfile}")
    regexp = ''
    File.readlines(regexfile).each do |line|
      regexp = $1 if line =~ REGEXPATTERN
    end
    regexp
  end

  def update_wiki(spamRegex)
    scriptdir = "/home/webuser/hosting/katrinahelp.info/htdoc/wiki"
    filename = scriptdir + "/LocalSettings.php"
    newname = scriptdir + "/LocalSettings.php.new"
    backup = scriptdir + "/LocalSettings.php.bak"

    # read in text of original LocalSettings.php
    src = File.readlines(filename)

    # write to a temporary filename
    File.open(newname,"w") { |f| f.write(src) }

    # move temporary file name to backup filename
    File.rename(newname, backup)

    File.open(filename,"w") do |f|
      src.each do |line|
        if line =~ REGEXPATTERN
          line.gsub!(/\s=\s*.*/, " = #{spamRegex}")
        end
        f.write(line)
      end
    end
    rescue
      raise "Got an exception #{$!}"
  end
end
