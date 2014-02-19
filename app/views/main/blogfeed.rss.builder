xml.instruct! :xml, :version=>"1.0"
xml.rss(:version=>"2.0"){
  xml.channel{
    xml.title("Turkopticon Blog")
    xml.link("/blog")
    xml.description("Turkopticon Blog")
    xml.language('en-us')
    for p in @posts
      xml.item do
        xml.title(p.title)
        xml.dc_creator(p.author_email)
        xml.description(p.body.gsub(/\n/,"<br/>"))
        xml.link("/post/" + p.slug)
      end
    end
  }
}
