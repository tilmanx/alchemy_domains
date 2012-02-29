authorization do

  role :admin do
    has_permission_on :admin_domains, :to => [:manage]
  end

end