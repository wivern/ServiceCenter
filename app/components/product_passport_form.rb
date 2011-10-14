class ProductPassportForm <  Netzke::Basepack::FormPanel

  def default_config
    super.merge(:model => "ProductPassport")
  end

  def configuration
    super.tap do |s|
      configure_locked(s)
      configure_bbar(s)
      s[:items] = [ :producer__name, :product_name__name, :gurantee_stub_number, :purchase_place__name, :purchased_at ]
    end
  end

end