# encoding: UTF-8

namespace :product do
  desc "Normalize product data"
  task :normalize => :environment do
    require "json"
    require 'utils/normalizator'

    CONDITIONS = [{code: 1, value: ["mới", "new"]},
                  {code: 2, value: ["cũ","used"]}]
    ORIGINS = [{code: 1, value: ["chính hãng"]},
               {code: 2, value: ["xách tay"]}]

    OUTPUT_PATH = "#{Rails.root}/data/normalized_data"
    INPUT_PATH = "#{Rails.root}/data/crawled_data"

    Dir.glob("#{INPUT_PATH}/*.json") do |fname|
      puts "Processing #{fname}..."
      file_name = File.basename(fname)
      f = File.new("#{OUTPUT_PATH}/#{file_name}",'a')
      File.readlines(fname).each do |line|
        json = JSON.parse(line)
        output = {}
        
        condition = CONDITIONS.detect{ |c| c[:value].include? json['condition'].mb_chars.downcase}
        output[:condition] = condition.blank? ? nil : condition[:code]

        origin = ORIGINS.detect{ |c| c[:value].include? json['origin'].mb_chars.downcase}
        output[:origin] = origin.blank? ? nil : origin[:code]

        output[:price] = json['price'].blank? ? nil : json['price'].to_f
        output[:warranty] = json['warranty'].blank? ? nil : json['warranty'].to_i
        category = json['category'].map{|el| el.gsub(/[\.\-\,\(\)]/, '').mb_chars.downcase}
        output[:category] = Normalizator.normalize(category)
        output[:photo] = json['photo']
        output[:name] = json['name']
        output[:specifics] = json['specifics']

        f.puts output.to_json
      end
    end
  end

  desc "Normalize product data"
  task :migrate => :environment do
    require 'open-uri'
    INPUT_PATH = "#{Rails.root}/data/normalized_data"
    TMP_PHOTO_PATH = "#{Rails.root}/tmp/images"

    categories = Category.all
    Dir.glob("#{INPUT_PATH}/*.json") do |fname|
      puts "Processing #{fname}..."
      shop_key = File.basename(fname,'.json')
      shop = Shop.find_by_shop_key shop_key
      File.readlines(fname).each do |line|
        begin
          json = JSON.parse(line)
          photo_name = File.basename(json['photo'],'.*')
          photo_ext = File.extname(json['photo'])
          photo_path = "#{TMP_PHOTO_PATH}/#{photo_name+photo_ext}"
          counter = 0
          while File.exist?(photo_path)
            counter += 1
            photo_path = "#{TMP_PHOTO_PATH}/#{photo_name}_#{counter}#{photo_ext}"
          end
          File.open(photo_path, 'wb') do |f|
            f.write open(json['photo'], 'rb').read
          end
          product = Product.find_by_name json['name']
          if product.nil?
            product = Product.new
            if json['category'].class == String
              category = Category.where(['lower(name) = lower(?)', json['category']]).first
            elsif json['category'].class == Array
              category_id = nil
              while !json['category'].blank?
                category_name = json['category'].shift
                if category_id
                  category = Category.where(['lower(name) = lower(?) AND parent_id = ?', category_name, category_id]).first
                else
                  category = Category.where(['lower(name) = lower(?)', category_name]).first
                end
                if category.nil?
                  break
                else
                  category_id = category.id 
                end
              end
            end
            product.name = json['name']
            product.category = category
          end
          product.specifics = json['specifics']
          product.save
          if product.id and shop
            shop_product = ShopProduct.where(['product_id = ? AND shop_id = ?', product.id, shop.id]).first
            if shop_product.nil?
              shop_product = ShopProduct.new
              shop_product.product = product
              shop_product.shop = shop
            end
            shop_product.price = json['price']
            shop_product.warranty = json['warranty']
            shop_product.origin = json['origin']
            shop_product.status = json['condition']
            if shop_product.save
              photo = Photo.new
              photo.image = File.open(photo_path)
              photo.imageable = shop_product
              photo.save
            end
          end
        rescue Exception => e
          puts e.message
          puts e.backtrace
        end
      end
    end
  end
end