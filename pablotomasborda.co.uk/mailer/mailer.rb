require 'mail'


  def send_keep_in_touch(name,email)
  
  puts "Sending email to " + name + " at " + email
    Mail.deliver do
      from     'pablotomasborda@gmail.com'
      to       email
      subject  (name.to_s + ' keep in touch with Pablo Tomas Borda for new positions')
      body     ("Hello recruiter " + name + ". We have been in touch on previous weeks, " + 
	       " by email and by phone or skype. \n The purpose of this email is to know how " + 
               " the recruiting process went for the positions we talked, and in case you have " + 
	       " moved fordward with another candidate, or the business specs have changed, " +
               " you can still take me into account for current Android/Ruby or Phonegap positions " + 
	       " you may have available. \n Take a look at my updated resume and visit my site "  +
	       " http://www.pablotomasborda.com.ar . I updated and uploaded more information, there" +
               " are sample applications for the different technologies, including screenshots, android apps screencasts" + 
	       " and sample source code.\n Being in touch is good since we know how each other work, and I can be helpful" + 
	       " when you are in a hurry to cover a position and you want to take a shorcut on the process, since we have already talked. \n\n\n" + "Regards, \n\n Pablo Tomas Borda")
      
      add_file ({:filename => "resume.pdf"})
     end
    
    puts "OK"
  end
  
  
 
  
  line_num=0
  text=File.open('rest.csv').read
  lines = text.split "\n"
  lines.each do |line|
    cells = line.split ","
    name = cells[0]
    email = cells[1]
    send_keep_in_touch(name.to_s,email.to_s)
  end
  
  

