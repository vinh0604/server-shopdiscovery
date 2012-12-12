class Contact < ActiveRecord::Base
  def full_name
    [first_name, last_name].reject(&:blank?).join(" ")
  end
end
