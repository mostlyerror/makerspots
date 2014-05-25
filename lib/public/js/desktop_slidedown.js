$(document).ready(function(){
  // alert("ready");
  toggleDescription();
});

var showDescription = function(item){
  item.addClass('clicked')
  .find('.description')
  .slideDown();
}

var hideDescription = function(item){
  item.removeClass('clicked')
  .find('.description')
  .slideUp();
}

var toggleDescription = function(){
  var image = $('.desktop-layout .image');
  image.click(function(){
    var currentItem = $(this).closest('.desktop-layout');
    if (currentItem.hasClass('clicked')) {
      hideDescription(currentItem);
    }
    else {
      showDescription(currentItem);
    }
  });
}
