class AddProxyToApps < ActiveRecord::Migration
  def self.up
    add_column :apps, :proxy, :boolean, :default => true
  end

  def self.down
    remove_column :apps, :proxy
  end
end
