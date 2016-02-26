Dir.foreach('public/images') do 
  |f|
  if !f.to_s.include? 'success' and !f.to_s.include? 'failed' and !f.to_s.include? 'reload' and f.to_s.include? '.png' and ((Time.now - File.atime('public/images/' + f.to_s)) >= 300)
    puts "Delete : " + f.to_s
    File.delete("public/images/" + f.to_s)
    
  end
  
end