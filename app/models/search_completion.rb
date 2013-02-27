class SearchCompletion < ActiveRecord::Base
  def self.add_term(search_term)
    search_completion = self.find_by_search_term(search_term) || self.new({search_term: search_term})
    search_completion.search_count += 1
    search_completion.save
  end
end
