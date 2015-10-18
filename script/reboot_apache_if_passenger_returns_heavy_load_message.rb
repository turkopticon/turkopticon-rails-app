#!/usr/bin/ruby

if `curl -silent https://turkopticon.ucsd.edu` =~ /heavy/
  `/etc/init.d/apache2 restart`
end
