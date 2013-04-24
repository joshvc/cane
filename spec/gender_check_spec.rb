require 'spec_helper'

require 'cane/gender_check'

describe Cane::GenderCheck do
  def check(file_name, opts = {})
    described_class.new(opts.merge(doc_glob: file_name))
  end

    it 'creates a GenderViolation for an appearance of the words' do
      file_name = make_file <<-RUBY
"Her code jumps over the lazy dog"
"That code belongs to him"
"His code is adequate"
"That code is hers"
"They are an exceptional tester"
"He is a good coder"
"She is also a good coder"
"Sheep are animals"
"Check to make sure everything works"
    RUBY

    violations = check(file_name).violations
    violations.length.should == 6 

    violations[0].values_at(:file, :line, :description).should == [
      file_name, 1, "Potential Non-Gender-Neutral wording"
    ]
    violations[1].values_at(:file, :line, :description).should == [
      file_name, 2, "Potential Non-Gender-Neutral wording"
    ]
    violations[2].values_at(:file, :line, :description).should == [
      file_name, 3, "Potential Non-Gender-Neutral wording"
    ]
    violations[3].values_at(:file, :line, :description).should == [
      file_name, 4, "Potential Non-Gender-Neutral wording"
    ]
    violations[4].values_at(:file, :line, :description).should == [
      file_name, 6, "Potential Non-Gender-Neutral wording"
    ]
    violations[5].values_at(:file, :line, :description).should == [
      file_name, 7, "Potential Non-Gender-Neutral wording"
    ]
  end
end