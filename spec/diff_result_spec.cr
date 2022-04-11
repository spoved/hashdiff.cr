require "./spec_helper"

Spectator.describe Hashdiff::DiffResult do
  let(diff) { Hashdiff::DiffResult(Array(Int32 | String | Symbol) | String, Int32).new("-", "a", 3) }
  let(diff_list) { Hashdiff.diff({"a" => 3, "b" => 2}, Hash(String, String).new) }

  it "#[]" do
    expect(diff[0]).to eq("-")
    expect(diff[1]).to eq("a")
    expect(diff[2]).to eq(3)
  end

  it "#to_t" do
    expect(diff.to_t).to eq({"-", "a", 3})

    expect(diff.to_t).to eq({"-", "a", 3})
    expect(diff.to_t).to be_a(Tuple(String, Array(Int32 | String | Symbol) | Array(String) | String, Int32))

    [diff, diff].each do |d|
      expect(d.to_t).to eq({"-", "a", 3})
      expect(d.to_t).to be_a(Tuple(String, Array(Int32 | String | Symbol) | Array(String) | String, Int32))
    end

    [diff, diff].map(&.to_t).each do |d|
      expect(d).to eq({"-", "a", 3})
      expect(d).to be_a(Tuple(String, Array(Int32 | String | Symbol) | Array(String) | String, Int32))
    end
  end

  it "#to_a" do
    expect(diff.to_a).to eq(["-", "a", 3])
  end

  # context "in a list" do
  #   it "#to_t" do
  #     puts diff_list.class
  #     diff_list.each do |d|
  #       puts d.class
  #       puts d.to_t.class
  #     end
  #   end
  # end
end
