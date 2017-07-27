Rails.application.config.middleware.use OmniAuth::Builder do
  provider :kit,
    ShopifyApp::Kit.config.key,
    ShopifyApp::Kit.config.secret,
    scope: 'public message stats',
    client_options: {
      headers: {
        'Accept'       => 'application/json',
        'Content-Type' => 'application/json',
      }
    }
end
