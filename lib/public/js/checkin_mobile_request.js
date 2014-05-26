$(document).ready(function(){
  $('.small-location button').click(function(){
    var button = $(this);
    if (button.hasClass("attending")) {
      checkOut(button);
    } else {
      checkIn(button)
    }
  })
});

var currentLocation;

var checkIn = function(button){
  currentLocation = button.attr("id");
  $.post( "/checkin_mobile/" + "" + currentLocation + "", function(data){
    $('.checkin-row').html(data);
    button.addClass('attending')
    .empty()
    .text("I'M ATTENDING");
  });
}

var checkOut = function(button){
  currentLocation = button.attr("id")
  $.post("/checkout_mobile/" + "" + currentLocation + "", function(data){
    $('.checkin-row').html(data);
    button.removeClass("attending")
    .empty()
    .text("ATTEND");
  })
}


