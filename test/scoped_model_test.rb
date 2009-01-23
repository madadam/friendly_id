require File.dirname(__FILE__) + '/test_helper'

class ScopedModelTest < Test::Unit::TestCase
  context "A slugged model that uses a scope" do
    setup do
      Person.delete_all
      Country.delete_all
      Slug.delete_all

      @usa = Country.create!(:name => "USA")
      @canada = Country.create!(:name => "Canada")
      @person = Person.create!(:name => "John Smith", :country => @usa)
      @person2 = Person.create!(:name => "John Smith", :country => @canada)
    end

    should "find all scoped records without scope" do
      assert_equal 2, Person.find(:all, @person.friendly_id).size
    end

    should "find a single scoped records with a scope" do
      assert Person.find(@person.friendly_id, :scope => @person.country.to_param)
    end

    should "raise an error when finding a single scoped record with no scope" do
      assert_raises ActiveRecord::RecordNotFound do
        Person.find(@person.friendly_id)
      end
    end

    should "append scope error info when missing scope causes a find to fail" do
      begin
        Person.find(@person.friendly_id)
        fail "The find should not have succeeded"
      rescue ActiveRecord::RecordNotFound => e
        assert_match /expected scope/, e.message
      end
    end

    should "append scope error info when the scope value causes a find to fail" do
      begin
        Person.find(@person.friendly_id, :scope => "badscope")
        fail "The find should not have succeeded"
      rescue ActiveRecord::RecordNotFound => e
        assert_match /scope=badscope/, e.message
      end
    end
  end

#  def test_should_create_non_unique_scoped_record
#    person = Person.create(:name => 'John Doe', :country => countries(:argentina))
#    assert person.valid?
#  end
#
#  def test_should_find_scoped_record_without_scope_if_it_is_unique
#    assert_equal people(:john_doe), Person.find("john-doe")
#  end
#
#  def test_should_raise_exception_if_non_unique_scoped_record_found_without_scope
#    assert_raise FriendlyId::RecordNotUnique do
#      Person.find("john-smith")
#    end
#  end
#
#  def test_should_find_scoped_records_with_scope
#    assert_equal people(:john_smith), countries(:argentina).people.find("john-smith")
#    assert_equal people(:john_smith2), countries(:usa).people.find("john-smith")
#  end
end
