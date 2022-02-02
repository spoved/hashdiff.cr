require "spectator"
require "../src/hashdiff"

def to_diff_results(array)
  array.map do |item|
    Hashdiff::DiffResult.new(item)
  end
end
