require 'net/http'; bd=[];
Net::HTTP.get('bash.im','/').split('<div class="quote">')[1..-1].each{|sb| (
  i=sb.index('class="text"')
  bd.push(
      num:sb[sb.index('span id')+10,6],
      dat:sb[sb.index('class="date"')+13,10],
      tim:sb[sb.index('class="date"')+24,5],
      ret:sb[sb.index('class="rating"')+15,4].to_i,
      txt:sb[i+13..sb.index('</div>',i)-1].gsub('<br>',"\n")     #correct inserts like &gt;
  );
)if sb.index('CDATA') == nil }; print bd[-1][:tim]

require 'sqlite3';
SQLite3::Database.new( '123.db' ) do |sbd|
  sbd.execute( 'CREATE TABLE bash (
        uid INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        number INTEGER NOT NULL,
        data DATA NOT NULL,
        time DATA NOT NULL,
        rating INTEGER NOT NULL,
        citata TEXT NOT NULL );' );
  bd.each{|n|
    sbd.execute( 'INSERT INTO bash ( number, data, time, rating, citata )
              VALUES ('+n[:num].to_s+', "'+n[:dat].to_s+'", "'+n[:tim].to_s+'", '+n[:ret].to_s+', "'+n[:txt]+'");');
    };
end;

# bd.each{|n|
#   system('sqlite3.exe','123.db','INSERT INTO bash ( number, data, time, rating, citata )
#             VALUES ('+n[:num].to_s+', "'+n[:dat].to_s+'", "'+n[:tim].to_s+'", '+n[:ret].to_s+', "'+n[:txt]+'");');
#   };