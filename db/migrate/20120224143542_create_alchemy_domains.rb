class CreateAlchemyDomains < ActiveRecord::Migration
  def change
    create_table :alchemy_domains do |t|
      t.boolean :default, :default => false
      t.string :hostname
      t.timestamps
    end
    add_index :alchemy_domains, :hostname
  end
end
