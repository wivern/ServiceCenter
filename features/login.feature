#encoding: UTF-8
Feature: Person sign up
  In order to allow access to application
  Person should be able to sign up

@javascript
Scenario: Person sign up
  Given I have a person named "admin" with password "Admin123"
  When I sign up as "admin" with password "Admin123"
  Then I should be on page "/"

@javascript
Scenario: Failure sign up with wrong password
  Given I have a person named "admin" with password "Admin123"
  When I sign up as "admin" with password "wrong"
  Then I should see "Failure"