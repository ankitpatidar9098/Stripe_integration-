Rails.configuration.stripe = {
  publishable_key:'pk_test_51O7X1eSG8L3EVXz9IY4TIHvWJnmCn0tQU2Xrk9u5YLNlAHKciZQFNCtY0P48tceoQdbN16OcaedIMb87r9W09TMB00mQi9Rgg3',
  secret_key: 'sk_test_51O7X1eSG8L3EVXz9u2ZfeXbKJ7c3Ud1MZ18Yj0eNc9qJHaUy8748KTrD7wSJVvER0CiXhm399B9YEoWeBgMCDppA00lR66Z8LO'
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]