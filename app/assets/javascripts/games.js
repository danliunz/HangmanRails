$(document).ready(function() {
  init_guess_submission();
});

function init_guess_submission() {
  $('.game-input .btn').click(function(event) {
    $btn = $(event.currentTarget);
    
    if($btn.hasClass('disabled')) {
      return false;
    }
    
    var guess = $btn.text().trim();
    
    $('#submit_guess_form input[name=guess]').val(guess);
    $('#submit_guess_form').submit();
  });
}
