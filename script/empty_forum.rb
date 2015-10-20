# paste this into the console

Post.all.each{|fp| fp.destroy}
ForumPostVersion.all.each{|fpv| fpv.destroy}
ForumPersonInfo.all.each{|fpi| fpi.destroy}
ReputationStatement.all.each{|rs| rs.destroy}
