# frozen_string_literal: true

# Base ApplicationRecord class
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
