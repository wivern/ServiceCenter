Then /^button "([^"]*)" should be enabled$/ do |arg1|
  page.driver.browser.execute_script(<<-JS).should == true
    var btn = Ext.ComponentMgr.all.filter('text', '#{arg1}').filter('type','button').first();
  return typeof(btn)!='undefined' ? !btn.disabled : false
  JS
end

Then /^button "([^"]*)" should be disabled$/ do |arg1|
  page.driver.browser.execute_script(<<-JS).should == true
    var btn = Ext.ComponentMgr.all.filter('text', '#{arg1}').filter('type','button').first();
    return typeof(btn)!='undefined' ? btn.disabled : false
  JS
end


Given /^I am on page "([^"]*)"$/ do |addr|
  visit(addr)
  #step "I wait for the response from the server"
end

Given /^[t|T]here are "([^"]*)" named "([^"]*)"$/ do |model,type|
  klass = model.parameterize.underscore.camelize.constantize
  klass.create!(:name => type)
end

Given /^[T|t]here are product named "([^"]*)" and produced by "([^"]*)"$/ do |name, producer_name|
  producer = Producer.find_by_name(producer_name)
  Product.create!(:name => name, :producer => producer)
end

When /^I should see "([^"]*)"$/ do |text|
  page.should have_content(text)
end

Then /^I should be on page "([^"]*)"$/ do |addr|
  page.current_path == addr
end

When /^I wait for the response from the server$/ do
  page.wait_until{ page.driver.browser.execute_script("return !Ext.Ajax.isLoading();") }
end

When /I sleep (\d+) seconds?/ do |arg1|
  sleep arg1.to_i
end
