class AddParentsToPosts < ActiveRecord::Migration
    def self.up
        change_table :posts do |t|
            t.integer :parent_id
        end
    end

    def self.down
        change_table :posts do |t|
            remove_column :parent_id
        end
    end
end
