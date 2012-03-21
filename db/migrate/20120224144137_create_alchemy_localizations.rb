class CreateAlchemyLocalizations < ActiveRecord::Migration
  def change
    create_table :alchemy_localizations do |t|
      t.references :domain
      t.references :language
      t.boolean :default_for_domain, :default => false
      t.timestamps
    end
    add_index :alchemy_localizations, :domain_id
    add_index :alchemy_localizations, :language_id
  end
end
