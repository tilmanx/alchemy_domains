authorization do

  role :admin do
    has_permission_on :alchemy_domains_admin_domains, :to => [:manage]
    has_permission_on :alchemy_domains_admin_localizations, :to => [:manage]
  end

end
