document.addEventListener("turbolinks:load", function () {
  var submitButton = document.querySelector('button[type="submit"]');
  var form = document.querySelector('form');

  if (submitButton) {
    submitButton.addEventListener('click', function (event) {
      event.preventDefault();
      stripe.confirmCardPayment(clientSecret, {
        payment_method: {
          card: card
        }
      }).then(function (result) {
        if (result.error) {
          // Show error to your customer
          showError(result.error.message);
        } else {
          // The payment succeeded!
          // Handle the post-payment flow
          form.submit();
        }
      });
    });
  }
});
