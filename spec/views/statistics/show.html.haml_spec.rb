require 'spec_helper'

describe "statistics/show" do
  before(:each) do
    @statistic = assign(:statistic, stub_model(Statistic))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
