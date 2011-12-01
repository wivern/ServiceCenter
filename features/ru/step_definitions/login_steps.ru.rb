#encoding: utf-8
#language: ru

Допустим /^есть пользователь с именем "([^"]*)" и паролем "([^"]*)"$/ do |name,password|
  step "I have a person named \"#{name}\" with password \"#{password}\""
end

Если /^(?:|я) вхожу под именем "([^\"]*)" с паролем "([^\"]*)"$/ do |name, password|
  step "I sign up as \"#{name}\" with password \"#{password}\""
end

Тогда /^я должен быть на странице "([^\"]*)"$/ do |addr|
  page.current_path == addr
end