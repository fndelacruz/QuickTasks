$(function(){
  // alert('ok');
  console.log('loaded ok');

  // Allow content submission if not blank
  $('#task-content').keydown(function(e) {
    if (!$('#task-content').val() && e.keyCode === 13) {
      e.preventDefault();
    }
  });
});
