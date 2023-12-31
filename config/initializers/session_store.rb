if Rails.env.production?
  # Production では session_store に Redis を利用する
  Rails.application.config.session_store :redis_store,
    servers: ENV['REDIS_URL'],
    expire_after: 90.minutes,
    key: "_risk_management_of_children_session",
    threadsafe: true,
    secure: true
else
  # Production以外 では session_store に cookie_store(default) を利用する
  Rails.application.config.session_store :cookie_store, expire_after: 90.minutes
end
