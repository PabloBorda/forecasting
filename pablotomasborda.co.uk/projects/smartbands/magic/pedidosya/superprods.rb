require 'rubygems'
require 'hpricot' 
require 'open-uri'
require 'mechanize'
require 'logger'
require 'mysql'
require 'uri'





begin 
  # connect to the MySQL server 
  @dbh = Mysql.real_connect("localhost", "root", "justice", "delivery") # get server version string and display it 
  puts "Server version: " + @dbh.get_server_info 

  q = "SELECT sps.cant,sps.name,sps.id 
       FROM ( SELECT COUNT( * ) AS cant, name, id
              FROM superproducts 
              GROUP BY name) sps
       WHERE sps.cant > 1 
       ORDER BY sps.cant DESC;"
  @res = @dbh.query(q)
  if (@res.num_rows == 0)
    puts "No result"
  end

  @res.each { |sp| 

    puts sp.to_s
    myq =  "select * from superproducts where (name like '" + sp[1].to_s + "') and (id != " + sp[2].to_s + ");"
    equalsuperprods = @dbh.query myq 
    puts myq
    equalsuperprods.each { |es|
                           myq1 = "update products set superproduct_id=" + sp[2].to_s + " where superproduct_id=" + es[0].to_s + ";"
                           puts myq1
                           @dbh.query    
                          }
   puts "Remove extra superproducts"
   @dbh.query "delete from superproducts where (name like '" + sp[1].to_s + "') and (id != " + sp[2].to_s + ");"
   @dbh.commit
  } 

rescue Mysql::Error => e 
  puts "Error code: #{e.errno}" 
  puts "Error message: #{e.error}"
  puts "Error SQLSTATE: #{e.sqlstate}" 
end
