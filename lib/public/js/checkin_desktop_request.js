$(document).ready(function(){
  $('.about button').click(function(){
    var button = $(this);
    if (button.hasClass("attending")) {
      checkOutDesktop(button);
    } else {
      checkInDesktop(button);
    }
    window.location.reload();
  })
});

var currentLocation;

var checkInDesktop = function(button){
  currentLocation = button.attr("id");
  $.post("/checkin/" + "" + currentLocation + "", function(data){
  });
}

var checkOutDesktop = function(button){
  currentLocation = button.attr("id");
  $.post("/checkout/" + "" + currentLocation + "", function(data){
  });
}
