require "./spec_helper"

Spectator.describe Hashdiff do
  let(described_class) { Hashdiff }

  it "is able to find LCS between two equal array" do
    a = [1, 2, 3]
    b = [1, 2, 3]

    lcs = described_class.lcs(a, b)
    expect(lcs).to match [{0, 0}, {1, 1}, {2, 2}]
  end

  it "is able to find LCS between two close arrays" do
    a = [1.05, 2, 3.25]
    b = [1.06, 2, 3.24]

    lcs = described_class.lcs(a, b, numeric_tolerance: 0.1)
    expect(lcs).to match [{0, 0}, {1, 1}, {2, 2}]
  end

  it "strips strings when finding LCS if requested" do
    a = %w[foo bar baz]
    b = [" foo", "bar", "zab"]

    lcs = described_class.lcs(a, b, strip: true)
    expect(lcs).to match [{0, 0}, {1, 1}]
  end

  it "is able to find LCS with one common elements" do
    a = [1, 2, 3]
    b = [1, 8, 7]

    lcs = described_class.lcs(a, b)
    expect(lcs).to match [{0, 0}]
  end

  it "is able to find LCS with two common elements" do
    a = [1, 3, 5, 7]
    b = [2, 3, 7, 5]

    lcs = described_class.lcs(a, b)
    expect(lcs).to match [{1, 1}, {2, 3}]
  end

  it "is able to find LCS with two close elements" do
    a = [1, 3.05, 5, 7]
    b = [2, 3.06, 7, 5]

    lcs = described_class.lcs(a, b, numeric_tolerance: 0.1)
    expect(lcs).to match [{1, 1}, {2, 3}]
  end

  it "is able to find LCS with two common elements in different ordering" do
    a = [1, 3, 4, 7]
    b = [2, 3, 7, 5]

    lcs = described_class.lcs(a, b)
    expect(lcs).to match [{1, 1}, {3, 2}]
  end

  it "is able to find LCS with a similarity value" do
    a = [
      {"value" => "New", "onclick" => "CreateNewDoc()"},
      {"value" => "Close", "onclick" => "CloseDoc()"},
    ]
    b = [
      {"value" => "New1", "onclick" => "CreateNewDoc()"},
      {"value" => "Open", "onclick" => "OpenDoc()"},
      {"value" => "Close", "onclick" => "CloseDoc()"},
    ]

    lcs = described_class.lcs(a, b, similarity: 0.5)
    expect(lcs).to match [{0, 0}, {1, 2}]
  end
end
