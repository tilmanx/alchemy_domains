class CreateAlchemyDomains < ActiveRecord::Migration
  def change
    create_table :alchemy_domains do |t|
      t.string :subdomain
      t.string :tld

      t.timestamps
    end
  end
end
