require 'openssl'

class User < ActiveRecord::Base
  ITERATIONS = 20000
  DIGEST = OpenSSL::Digest::SHA256.new
  EMAIL_REGEXP = /\A[^@]+@[^@]+\Z/.freeze
  USERNAME_REGEXP = /\A[\w]+\Z/.freeze
  DEFAULT_PROFILE_COLOR = '#005a55'.freeze

  has_many :questions

  before_validation :set_default_color

  validates :email, format: { with: EMAIL_REGEXP }
  validates :username, format: { with: USERNAME_REGEXP }
  validates :email, :username, presence: true
  validates :email, :username, uniqueness: true
  validates :profile_color, hex_color: true
  validates_length_of :username, maximum: 40

  attr_accessor :password

  validates_presence_of :password, on: :create
  validates_confirmation_of :password

  before_save :encrypt_password

  def set_default_color
    self.profile_color ||= DEFAULT_PROFILE_COLOR
  end

  def encrypt_password
    if self.password.present?
      self.password_salt = User.hash_to_string(OpenSSL::Random.random_bytes(16))

      self.password_hash = User.hash_to_string(
        OpenSSL::PKCS5.pbkdf2_hmac(self.password, self.password_salt,
                                   ITERATIONS, DIGEST.length, DIGEST)
      )
    end
  end

  def self.hash_to_string(password_hash)
    password_hash.unpack('H*')[0]
  end

  def self.authenticate(email, password)
    user = find_by(email: email)

    if user.present? && user.password_hash == User.hash_to_string(
      OpenSSL::PKCS5.pbkdf2_hmac(password, user.password_salt,
                                 ITERATIONS, DIGEST.length, DIGEST)
    )
      user
    end
  end

  def downcase_username
    self.username.downcase!
  end
end
