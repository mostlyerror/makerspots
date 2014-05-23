$(document).ready(function(){
  // alert("ready");
  toggleDescription();
});

var showDescription = function(item){
  item.closest('.desktop-layout')
  .addClass('clicked')
  .find('.description')
  .slideDown();
}

var hideDescription = function(item){
  item.closest('.desktop-layout')
  .removeClass('clicked')
  .find('.description')
  .slideUp();
}

var toggleDescription = function(){
  var image = $('.desktop-layout .image');
  image.click(function(){
    var current_item = $(this).closest('.desktop-layout');
    if (current_item.hasClass('clicked')) {
      hideDescription(current_item);
    }
    else {
      showDescription(current_item);
    }
  });
}
