xml.instruct!
xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
  xml.title "Lightmind"
  xml.subtitle "Output: on"
  xml.id "http://blog.lightmind.co.uk/"
  xml.link "href" => "http://blog.lightmind.co.uk/"
  xml.link "href" => "http://blog.lightmind.co.uk/feed.xml", "rel" => "self"
  xml.updated data.blog.articles.first.date.to_time.iso8601
  xml.author { xml.name "Rupert Meese" }

  data.blog.articles.each do |article|
    xml.entry do
      xml.title article.title
      xml.link "rel" => "alternate", "href" => article.url
      xml.id article.url
      xml.published article.date.to_time.iso8601
      xml.updated article.date.to_time.iso8601
      xml.author { xml.name "Rupert Meese" }
      xml.summary article.summary, "type" => "html"
      xml.content article.body, "type" => "html"
    end
  end
end
