namespace :product do
  desc "Normalize product data"
  task :normalize => :environment do
    # CONDITIONS = [{code: 1, value: ["mới", "new"]},
    #               {code: 2, value: ["cũ","used"]}]
    # ORIGINS = [{code: 1, value: ["chính hãng"]},
    #            {code: 2, value: ["xách tay"]}]
  end
end