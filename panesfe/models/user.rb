class User
  include DataMapper::Resource
  include DataMapper::Validate
  attr_accessor :password, :password_confirmation

  ROLES = %W{admin user}

  # Properties
  property :id,               Serial
  property :name,             String
  property :surname,          String
  property :email,            String
  property :crypted_password, String, :length => 70
  property :role,             String
  property :provider,         String
  property :uid,              String
  has n, :presentations

  # Validations
  validates_presence_of      :email, :role
  validates_presence_of      :password,                          :if => :password_required
  validates_presence_of      :password_confirmation,             :if => :password_required
  validates_length_of        :password, :min => 4, :max => 40,   :if => :password_required
  validates_confirmation_of  :password,                          :if => :password_required
  validates_length_of        :email,    :min => 3, :max => 100
  validates_uniqueness_of    :email,    :case_sensitive => false
  validates_format_of        :email,    :with => :email_address
  validates_within           :role,     :set => ROLES

  # Callbacks
  before :save, :encrypt_password

  ##
  # This method is for authentication purpose.
  #
  def self.authenticate(email, password)
    account = first(:conditions => ["lower(email) = lower(?)", email]) if email.present?
    account && account.has_password?(password) ? account : nil
  end

  ##
  # This method is used by AuthenticationHelper
  #
  def self.find_by_id(id)
    get(id) rescue nil
  end

  def has_password?(password)
    ::BCrypt::Password.new(crypted_password) == password
  end

  def display_name
    [name, surname].join(' ')
  end

  def self.find_or_create_with_omniauth(auth)
    first(uid: auth["uid"], provider: auth["provider"]) ||
    create!(
      provider: auth["provider"],
      uid:      auth["uid"],
      name:     auth["info"]["given_name"] || auth["info"]["first_name"],
      surname:  auth["info"]["family_name"] || auth["info"]["last_name"],
      email:    auth["info"]["email"],
      role:     "user"
    )
  end

  private

  def password_required
    provider != 'google_oauth2' && (crypted_password.blank? || password.present?)
  end

  def encrypt_password
    self.crypted_password = ::BCrypt::Password.create(password) if password.present?
  end
end
