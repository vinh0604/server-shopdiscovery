namespace :crawler do
  desc "Crawl data from vatgia"
  task :vatgia => :environment do
    require 'nokogiri'

    File.open("#{Rails.root}/data/shop.txt").each do |line|
      next if line.blank?
      shop_key = File.basename(line)
      crawler = CobwebCrawler.new({:internal_urls => ["#{line}&module=product&view=ucat&*",
                                                      "#{line}&module=product&view=listudv&*"]})
      product_crawler = CobwebCrawler.new({:internal_urls => ["#{line}&module=product&view=detail&*"]})
      crawler.crawl(line) do |content|
        puts "Processing #{content[:url]}..."
        product_crawler.crawl(content[:url]) do |product_content|
          if product_content[:url].include? "module=product&view=detail"
            puts "Processing #{product_content[:url]}..."
            doc = Nokogiri::HTML(product_content[:body])
            product = {}
            product_detail = doc.css('.product_detail')
            product[:name] = product_detail.css('h1').first.text
            product[:price] = product_detail.css('.price').first.text.gsub(/[^0-9]/,'')
            product_detail_table = product_detail.css('.product_detail_table')
            product[:condition] = product_detail_table.css('tr:nth-child(1) > td:nth-child(4)').first.text
            product[:warranty] = product_detail_table.css('tr:nth-child(2) > td:nth-child(2)').first.text.gsub(/[^0-9]/,'')
            product[:origin] = product_detail_table.css('tr:nth-child(2) > td:nth-child(4)').first.text
            product[:photo] = doc.css('.picture_larger img').first.attr('src')

            specifics = {}
            doc.css('.product_technical_table .technical').each do |row|
              name = row.css('.name').first.text
              specifics[name] = row.css('.value').first.inner_html.gsub('<br>', "\n")
            end

            product[:specifics] = specifics
            product[:category] = doc.css('.navigate .C a:not(.home)').inject([]) {|categories, node| categories << node.text}
            File.open("#{Rails.root}/data/crawled_data/#{shop_key}.json","a") do |f|
              f.puts product.to_json
            end
          end
        end
      end
    end
  end

  desc "Crawler example"
  task :example => :environment do
    require 'nokogiri'
    product_crawler = CobwebCrawler.new({:internal_urls => ["http://www.vatgia.com/ThanhLapStore&module=product&view=detail&*"], :redirect_limit => 1, :debug => true})
    product_crawler.crawl("http://www.vatgia.com/ThanhLapStore&module=product&view=ucat&record_id=3379") do |product_content|
      if product_content[:url].include? "module=product&view=detail"
        puts "Processing #{product_content[:url]}..."
        doc = Nokogiri::HTML(product_content[:body])
        product = {}
        product_detail = doc.css('.product_detail')
        product[:name] = product_detail.css('h1').first.text
        product[:price] = product_detail.css('.price').first.text.gsub(/[^0-9]/,'')
        product_detail_table = product_detail.css('.product_detail_table')
        product[:condition] = product_detail_table.css('tr:nth-child(1) > td:nth-child(4)').first.text
        product[:warranty] = product_detail_table.css('tr:nth-child(2) > td:nth-child(2)').first.text.gsub(/[^0-9]/,'')
        product[:origin] = product_detail_table.css('tr:nth-child(2) > td:nth-child(4)').first.text

        specifics = {}
        doc.css('.product_technical_table .technical').each do |row|
          name = row.css('.name').first.text
          specifics[name] = row.css('.value').first.inner_html.gsub('<br>', "\n")
        end

        product[:specifics] = specifics
        product[:category] = doc.css('.navigate .C a:not(.home)').inject([]) {|categories, node| categories << node.text}
        File.open("#{Rails.root}/tmp/example.json","a") do |f|
          f.puts product.to_json
        end
      end
    end
  end
end