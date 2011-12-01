Given /^I have a person named "([^"]*)" with password "([^"]*)"$/ do |username, password|
  Person.create!( :username => username, :password => password, :name => username, :email => 'some@example.com' )
end

Given /^I signed up as "([^"]*)" with password "([^"]*)"$/ do |username, password|
  step "I have a person named \"#{username}\" with password \"#{password}\""
  step "I sign up as \"#{username}\" with password \"#{password}\""
  step "I sleep 3 seconds"
  step "I should be on page \"#{root_path}\""
end

When /^I sign up as "([^"]*)" with password "([^"]*)"$/ do |username, password|
  visit(login_path)
  fill_in('Username', :with => username)
  fill_in('Password', :with => password)
  click_button(I18n.t('views.forms.login_form_panel.actions.login.text'))
  step "I wait for the response from the server"
end
