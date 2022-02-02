require "./util"
require "./lcs"

module Hashdiff::LcsCompareArrays
  extend self
  Log = ::Log.for(self)

  def call(obj1 : Array(T), obj2 : Array(L), **opts) forall T, L
    Log.trace { "compare #{obj1.class} and #{obj2.class}" }

    result = Array(DiffResult(Array(Int32 | String | Symbol) | String, T | L)).new

    changeset = Hashdiff.diff_array_lcs(obj1, obj2, **opts) do |lcs|
      lcs.each do |pair|
        prefix = Hashdiff.prefix_append_array_index(**opts, array_index: pair[0])
        Hashdiff._diff(obj1[pair[0]], obj2[pair[1]], **opts.merge(prefix: prefix)).each do |change|
          result += [change]
        end
      end
    end

    changeset.each do |change|
      next if change[0] != "-" && change[0] != "+"
      change_key = Hashdiff.prefix_append_array_index(**opts, array_index: change[1])
      result += [DiffResult.new({change[0].as(String), change_key, change[2]})]
    end

    result
  end
end
