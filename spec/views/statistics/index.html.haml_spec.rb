require 'spec_helper'

describe "statistics/index" do
  before(:each) do
    assign(:statistics, [
      stub_model(Statistic),
      stub_model(Statistic)
    ])
  end

  it "renders a list of statistics" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
