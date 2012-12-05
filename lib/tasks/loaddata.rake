namespace :loaddata do
  desc "Load product data"
  task :product => :environment do
    data_dir = "#{Rails.root}/data/crawled_data/*.json"
    Dir.glob(data_dir) do |fname|
      data = []
      File.readlines(fname).each do |line|
        json = JSON.parse(line)
        data << json
      end
      shop_code = File.basename(fname, '.json')
      shops = Shop.where(:shop_code => shop_code).all
      shops.each do |shop|
        data.each do |json|
          product = Product.find_by_product_name(json["name"])
          if !product
            product = Product.create(:name => json["name"],
                                     :category => json["category"],
                                     :specifics => json["specifics"])
          end
          shop_product = ShopProduct.find_by_id(product.id)
          if !shop_product
            shop_product.create(:warranty => json["warranty"],
                                :price => json["price"],
                                :origin => json["origin"],
                                :condition => json["condition"],
                                :product => product)
          else
            shop_product.update_attributes(:warranty => json["warranty"],
                                           :price => json["price"],
                                           :origin => json["origin"],
                                           :condition => json["condition"])
          end
        end
      end
    end
  end
end