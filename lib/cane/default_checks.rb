require 'cane/abc_check'
require 'cane/style_check'
require 'cane/doc_check'
require 'cane/threshold_check'
require 'cane/gender_check'

module Cane
  def default_checks
    [
      GenderCheck
    ]
  end
  module_function :default_checks
end
