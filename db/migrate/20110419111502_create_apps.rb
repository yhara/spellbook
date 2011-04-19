class CreateApps < ActiveRecord::Migration
  def self.up
    create_table :apps do |t|
      t.string :name
      t.integer :port
      t.string :command
    end
  end

  def self.down
    drop_table :apps
  end
end
