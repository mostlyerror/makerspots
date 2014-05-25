$(document).ready(function(){
  toggleOverflow();
})

var showOverflow = function(overflow){
  overflow.addClass('overflown')
  .find('.user-overflow')
  .slideDown();
}

var hideOverflow = function(overflow){
  overflow.removeClass('overflown')
  .find('.user-overflow')
  .slideUp();
}

var toggleOverflow = function(){
  var counter = $('.counter');
  counter.click(function(){
    var currentLocation = $(this).closest('.desktop-layout');
    if (currentLocation.hasClass('overflown')) {
      hideOverflow(currentLocation);
    } else {
      showOverflow(currentLocation);
    }
  });
}
