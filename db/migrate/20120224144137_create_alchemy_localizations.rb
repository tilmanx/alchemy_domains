class CreateAlchemyLocalizations < ActiveRecord::Migration
  def change
    create_table :alchemy_localizations do |t|
      t.integer :domain_id
      t.integer :language_id
      t.boolean :default_for_domain, :default => false

      t.timestamps
    end
  end
end
