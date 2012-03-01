authorization do

  role :admin do
    has_permission_on :alchemy_admin_domains, :to => [:manage]
  end

end