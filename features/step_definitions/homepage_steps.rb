Given('I am on the Homepage') do
  visit("/")
end

When('I search for {string}') do |string|
  fill_in('q', with: string)
  find_field('q').native.send_key(:enter)
end

Then('I should see {string}') do |string|
  expect(page).to have_content(string)
end