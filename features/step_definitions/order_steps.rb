When /^I fill in "([^"]*)" with "([^"]*)"$/ do |name, value|
  fill_in(name, :with => value)
end

When /^I fill the new "([^"]*)" form with:$/ do |form, table|
 table.rows_hash.each{|name, value|
    step %{I fill in "#{name}" with "#{value}"}
 }
end

When /^I select "([^"]*)" as "([^"]*)"$/ do |elem, value|
  find(:xpath, "//input[contains(@name,\"#{elem.parameterize.underscore}\")]//..//*//div[contains(@class,'trigger')]").click
  sleep 1.second
  find(:xpath, "//li[contains(@class,'x-boundlist-item') and contains(text(), '#{value}')]").click
end

When /^I choose "([^"]*)" as "([^"]*)"$/ do |elem, value|
  find(:xpath, "//input[contains(@name,\"_#{elem.parameterize.underscore}\")]//..//*//div[contains(@class,'trigger')]").click
  sleep 1.second
  find(:xpath, "//div[contains(@class,'x-grid-cell-inner') and contains(text(), '#{value}')]").click
  find(:xpath, "//div[contains(@id, 'select_#{elem}')]//*/button[@data-qtip='Select']").click
end