# This small script is launched every 24 hours so it takes as input
# user experiences and generates relationships at a user level


require "mysql"
require "logger"

class DBGenerator


   def initialize

	  @processed_users = Hash[]
	  @db = Mysql.real_connect("localhost","root","123456","mydb")
 
   end

  def compare(basepath)
    lo = Logger.new('/var/log/filldb.log')
     lo.info('initialize') { "=============== Starting compare and DB generation process ===============" }
     if (!File.file?(basepath))
     users = Dir.entries(basepath)
     index = 0
     users.each { |x|
                     if (self.user?(x)) 
	               users.each { |y|
		                        #puts "THIS IS VALUE X " + x + " AND THIS IS Y " + y
		                      #debugger
		  		      if ( x != y )
	                                  if (self.user?(x) && self.user?(y))
                                            #puts "RUNNING EXECUTE COMPARE ON: " + x + " AND " +  y
					    if (@processed_users[x] != y && @processed_users[y] != x && !already_processed(x,y))
					      result = self.execute_compare(x,y)
					      insert_intodb(x,y,result)
					      @processed_users[x] = y
					      @processed_users[y] = x
                                              lo.info('initialize') { x + " and " + y + " are processed." }
                                            else
					      lo.error(x + " and " + y + " are already processed \n")
					    end  
                                          end
			 	        end
 		                  }
		     end
                }
    else
      puts "Usage: compare directory\n"
    end
     lo.info('initialize') { "=============== Starting compare and DB generation process ===============" }
    lo.close
    @db.close
  end


  def getid_from_username(u)
    resulset = @db.query("SELECT id FROM users WHERE (email like '" + u + "');")
    if (resulset.num_rows == 0)
      puts "No " + u + " enail found on database;"
      @db.query("INSERT INTO users(email) VALUES ('" + u + "');")
      @db.commit
      resulset = @db.query("SELECT id FROM users WHERE (email like '" + u + "');")
    end
    row = resulset.fetch_row
    
    return row[0]
  end

  def already_processed(u1,u2)
    res = @db.query("SELECT * FROM users_has_users WHERE (((user_id = " + getid_from_username(u1) + ") AND (relatives_id = " + getid_from_username(u2) + ")) OR ((user_id = " + getid_from_username(u2) + ") AND (relatives_id = " + getid_from_username(u1) + ")))")
   r = res.fetch_row
   return (res.num_rows != 0)   

  end
  
  
  def insert_intodb(u1,u2,diff)
   #if (already_processed(u1,u2))
     puts "INSERT INTO users_has_users (user_id,relatives_id,comparison_value)
              VALUES
	        (" + getid_from_username(u1) + "," + getid_from_username(u2) + "," + diff.to_s + ");"
     @db.query("INSERT INTO users_has_users (user_id,relatives_id,comparison_value)
              VALUES
	        (" + getid_from_username(u1) + "," + getid_from_username(u2) + "," + diff.to_s + ");")
  #  end
  end



  def user?(str)
    ((str.count('@')==1) && (!File.file?("shots/" + str)))
  end


  def execute_compare(dir1,dir2)
    distance = 0   #This is computational distance between two shot files
    l1 = Dir.entries("shots/" + dir1)
    l2 = Dir.entries("shots/" + dir2)
    usel1 = (l1.size >= l2.size)
    ddir1 = dir1
    ddir2 = dir2
    if (!usel1)
      ll1 = l2
      ll2 = l1
      ddir1 = dir2
      ddir2 = dir1
    else
      ll1 = l1
      ll2 = l2
    end
    puts "================ Distance Between " + ddir1 + " and " + ddir2 + "==============================="
    ll1.each { |x|
                   distance = 0
                   if (File.file?("shots/" + ddir1 + "/" + x))
                     ll2.each { |y|
		       if (File.file?("shots/" + ddir2 + "/" + y))
		         current_distance = compare_files("shots/" + ddir1 + "/" + x, "shots/" + ddir2 + "/" + y)
                         #puts "      * The distance between " + x + " and " + y + " is " + current_distance.to_s + "."
                         distance = distance + current_distance
                       end

		     }
		   end
    }
    puts "============================================================Total " + distance.to_s() + " ==========="
    return distance.to_s
 end


 

 def compare_files(file1,file2)
  f = (IO.popen("./xp-levenshtein " + file1 + " " + file2)).readlines
  #puts "The computational distance between" +  file1 + " and " + file2 + " is: " + f[1]
  return f[1].to_i
 end

end


puts "Wellcome to the computational distance database generator"
dbgen = DBGenerator.new
dbgen.compare("shots")

