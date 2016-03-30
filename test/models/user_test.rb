require 'test_helper'

class UserTest < ActiveSupport::TestCase
  describe 'validations' do
    it 'should not be valid without an email' do
      # Arrange
      user = User.new(name: 'Matt')

      # Act
      result = user.valid?

      # Assert
      refute result, 'User objects must have an email'
      assert_not_empty user.errors
      assert_includes user.errors, :email
    end

    it 'should not be valid with an email larger than 255 characters' do
      email = 'a' * 257
      user = User.new(name: 'matt', email: email)

      result = user.valid?

      refute result, 'User emails cannot be longer than 255 characters'
      assert_not_empty user.errors
      assert_includes user.errors, :email
    end

    it 'should not be valid with an invalid email format' do
      email = 'heybob&me.we'
      user = User.new(name: 'matt', email: email)

      result = user.valid?

      refute result, 'User emails must be valid format'
      assert_not_empty user.errors
      assert_includes user.errors, :email
    end

    it 'should not allow for users with duplicate emails' do
      email = 'matthew@billie.com'
      user_1 = User.create(name: 'matt', email: email, password: 'password', password_confirmation: 'password')
      user_2 = User.new(name: 'bob', email: email.upcase)

      result = user_2.valid?

      refute result, 'Users must have a unique email address'
      assert_not_empty user_2.errors
      assert_includes user_2.errors, :email
    end

    it 'should downcase a users email before saving' do
      email = 'MATTHEW@BILLIE.COM'
      user = User.new(name: 'matt', email: email, password: 'password', password_confirmation: 'password')
      user.save

      result = user.email

      assert_equal email.downcase, user.email
    end

    it 'should not be valid without a name' do
      # Arrange
      user = User.new(email: 'matthew@billie.com')

      # Act
      result = user.valid?

      # Assert
      refute result, 'User objects must have a name'
      assert_not_empty user.errors
      assert_includes user.errors, :name
    end

    it 'should not be valid with a name greater than 50 characters' do
      name = 'a' * 60
      user = User.new(name: name)

      result = user.valid?

      refute result, 'Users name cannot be longer than 50 characters'
      assert_not_empty user.errors
      assert_includes user.errors, :name
    end

    it 'should be valid with a name and email' do
      # Arrange
      user = User.new(name: 'Matthew', email: 'matthew@billie.com', password: 'password', password_confirmation: 'password')

      # Act
      result = user.valid?

      # Assert
      assert result, 'Users should be valid with a name and email'
    end

    it 'should not be valid with a password less than 8 characters' do
      password = 'matt'
      user = User.new(name: 'matt', email: 'matthew@billie.com', password: password, password_confirmation: password)

      result = user.valid?

      refute result, 'Users password must be at least 8 characters'
      assert_not_empty user.errors
      assert_includes user.errors, :password
    end

    it 'should be valid with a password of 8 characters' do
      password = 'matthewb'
      user = User.new(name: 'matt', email: 'matthew@billie.com', password: password, password_confirmation: password)

      result = user.valid?

      assert result
    end
  end
end
