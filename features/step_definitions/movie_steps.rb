# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  matches = page.body.match(/#{e1}(.|\n)*#{e2}/)
  if matches.nil?
    assert false
  else
    assert matches
  end
end

Then /I should (not )?see the following films: (.*)/ do |no, film_list|
  film_list.gsub! /"/, ''
  film_list.split(/,\s?/).each do |film|
    if no.nil?
      match = page.has_content? film
      if match.nil?
        assert false
      else
        assert match
      end
    else
      match = page.has_no_content? film
      if match.nil?
        assert false
      else
        assert match
      end
    end
  end
end

Then /I should (not )?see the following ratings: (.*)/ do |no, rating_list|
  ratings = page.all("table#movies tbody tr td[3]").map! {|t| t.text}
  rating_list.gsub! /"/, ''
  rating_list.split(/,\s?/).each do |rating|
    if no.nil?
      assert (ratings.include? rating.strip)
    else
      assert !(ratings.include? rating.strip)
    end
  end
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

Given /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.gsub! /"/, ''
  rating_list.split(/,\s?/).each do |rating|
    step %Q{I #{uncheck}check "ratings_#{rating.strip}"}
    if uncheck.nil?
      step %Q{the "ratings_#{rating.strip}" checkbox should be checked}
    else
      step %Q{the "ratings_#{rating.strip}" checkbox should not be checked}
    end
  end
end

Then /^I should see all of the movies$/ do
    rows = page.all('table#movies tr td[1]').count
    assert (rows == Movie.all.count)
end

Then /^I should not see any of the movies$/ do
    rows = page.all('table#movies tr td[1]').count
    assert (rows == 0)
end

Then /the director of (.*) should be (.*)/ do |title, director|
  title.gsub! /"/, ''
  director.gsub! /"/, ''
  assert (director == (Movie.find_by_title title).director)
end
