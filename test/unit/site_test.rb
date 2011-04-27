require 'test_helper'

class SiteTest < ActiveSupport::TestCase
  def setup
    @user = create_user
    @site = Site.create :urlname => 'urlname', :name => 'name'
  end

  test 'site should have admins' do
    @site.admins << @user

    assert @site.admins.include? @user
    assert @user.admin_sites.include? @site
  end

  test 'urlname can not change' do
    @site.update_attributes :urlname => 'change'
    assert_equal @site.urlname, 'urlname'
  end

  test 'urlname format is word character and not case sensitive' do
    assert @site.valid?, @site.errors.to_s

    assert !Site.new(:name => 'name').valid?
    assert !Site.new(:urlname => 'urlname', :name => 'name').valid?
    assert !Site.new(:urlname => 'UrlName', :name => 'name').valid?
    assert !Site.new(:urlname => 'a' * 2, :name => 'name').valid?
    assert !Site.new(:urlname => 'a' * 21, :name => 'name').valid?
  end
end
