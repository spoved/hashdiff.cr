require "./util"

module Hashdiff
  # caculate array difference using LCS algorithm
  # http://en.wikipedia.org/wiki/Longest_common_subsequence_problem
  # ameba:disable Metrics/CyclomaticComplexity
  def lcs(arraya, arrayb, **options) : Array(Tuple(Int32, Int32))
    return Array(Tuple(Int32, Int32)).new if arraya.empty? || arrayb.empty?

    opts = {similarity: 0.8, prefix: ""}
      .merge(options)
    opts = opts.merge({
      prefix: prefix_append_array_index(**opts, array_index: "*"),
    })

    a_start = b_start = 0
    a_finish = arraya.size - 1
    b_finish = arrayb.size - 1
    vector = Array(Tuple(Int32, Int32)).new

    lcs = Array(Array(Tuple(Symbol, Int32))).new
    (b_start..b_finish).each do |bi|
      lcs.insert(bi, Array(Tuple(Symbol, Int32)).new)
      (a_start..a_finish).each do |ai|
        if similar?(arraya[ai], arrayb[bi], **opts)
          topleft = (ai > 0) && (bi > 0) ? lcs[bi - 1][ai - 1][1].as(Int32) : 0
          lcs[bi].insert(ai, {:topleft, topleft + 1})
        elsif (top = bi > 0 ? lcs[bi - 1][ai][1] : 0)
          left = ai > 0 ? lcs[bi][ai - 1][1].as(Int32) : 0
          count = top > left ? top : left

          direction = if top > left
                        :top
                      elsif top < left
                        :left
                      elsif bi.zero?
                        :top
                      elsif ai.zero?
                        :left
                      else
                        :both
                      end

          lcs[bi].insert(ai, {direction, count})
        end
      end
    end

    x = a_finish
    y = b_finish
    while (x >= 0) && (y >= 0) && (lcs[y][x][1] > 0)
      if lcs[y][x][0] == :both
        x -= 1
      elsif lcs[y][x][0] == :topleft
        vector.insert(0, {x, y})
        x -= 1
        y -= 1
      elsif lcs[y][x][0] == :top
        y -= 1
      elsif lcs[y][x][0] == :left
        x -= 1
      end
    end

    vector
  end
end
