Rails.application.routes.draw do
  delete 'kit', to: 'kit#destroy'
  post   'kit/conversation/callback', to: 'kit#conversation_callback'
  get    'auth/kit/callback', to:  'kit#callback'
end
