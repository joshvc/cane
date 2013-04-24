require 'cane/file'
require 'cane/task_runner'

module Cane
  # Creates violations for use of him, her, his, hers.
  class GenderCheck < Struct.new(:opts)
    NAUGHTY = ["him", "her", "his", "hers", "he", "she"]
    def self.key; :doc; end
    def self.name; "documentation checking"; end
    def self.options
      {
        doc_glob:    ['Glob to run doc checks over',
                        default:  '{app,lib}/**/*.rb',
                        variable: 'GLOB',
                        clobber:  :no_doc],
        doc_exclude: ['Exclude file or glob from documentation checking',
                        variable: 'GLOB',
                        type: Array,
                        default: [],
                        clobber: :no_doc],
        no_readme:   ['Disable readme checking', cast: ->(x) { !x }],
        no_doc:      ['Disable documentation checking', cast: ->(x) { !x }]
      }
    end

    def violations
      return [] if opts[:no_doc]

      worker.map(file_names) {|file_name|
        find_violations(file_name)
      }.flatten
    end

    def find_violations(file_name)
      last_line = ""
      Cane::File.iterator(file_name).map.with_index do |line, number|
        result = if NAUGHTY.any? {|word| line.downcase =~ /(\b|^)#{word}(\s|$|\W|\b)/i }
          {
            file:        file_name,
            line:        number + 1,
            label:       "Line #{number + 1}",
            description: "Potential Non-Gender-Neutral wording"
          }
        end
        last_line = line
        result
      end.compact
    end

    def exclusions
      @exclusions ||= opts.fetch(:doc_exclude, []).flatten.map do |i|
        Dir[i]
      end.flatten.to_set
    end

    def excluded?(file)
      exclusions.include?(file)
    end

    def worker
      Cane.task_runner(opts)
    end

    def file_names
      Dir[opts.fetch(:doc_glob)].reject { |file| excluded?(file) }
    end
  end
end