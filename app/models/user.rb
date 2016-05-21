class User < SQLObject
  finalize!

  attr_accessor :password

  has_many :tasks, foreign_key: :owner_id

  def initialize(params = {})
    ensure_session_token!
    super(params)
  end

  def self.find_by_credentials(username, password)
    user = User.where(username: username)[0]
    if user && user.is_password?(password)
      user
    end
  end

  def is_password?(password)
    BCrypt::Password.new(password_digest).is_password?(password)
  end

  def ensure_session_token!
    self.session_token ||= SecureRandom::urlsafe_base64(16)
  end

  def reset_session_token!
    self.session_token = SecureRandom::urlsafe_base64(16)
    save
    session_token
  end

  def password=(password)
    self.password_digest = BCrypt::Password.create(password)
  end

  def to_s
    "#{username}"
  end
end
