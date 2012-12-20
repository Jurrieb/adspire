class AddFilenameToFeeds < ActiveRecord::Migration
  def self.up
    add_attachment :feeds, :filename
  end

  def self.down
    remove_attachment :feeds, :filename
  end
end
