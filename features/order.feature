#encoding: utf-8

Feature: New order creation
  In order to make new maintenance order
  As an acceptor
  I want to create a new maintenance order

@javascript
Scenario: Make a new order
  Given I signed up as "admin" with password "Admin123"
  And I am on page "/#order_form"
#  And I sleep 5 seconds?
  And there are "producer" named "PENTAX"
  And there are product named "Optio A40" and produced by "PENTAX"
  And there are "repair type" named "Payed"
  #Submit new order
  When I fill the new "order" form with:
    |product_passport__factory_number       | 1234                |
    |product_passport__guarantee_stub_number| 567890345           |
    |customer__name                         | John Doe            |
    |customer__email                        | john.doe@gmail.com  |
    |customer__phone                        | +7(812)123-34-45    |
  And I select "repair type" as "Payed"
  And I choose "producer" as "PENTAX"
  And I choose "product" as "Optio A40"
