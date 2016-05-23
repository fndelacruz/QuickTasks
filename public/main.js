$(function(){
  // Allow content submission if not blank
  $('#task-content').keydown(function(e) {
    if (!$('#task-content').val() && e.keyCode === 13) {
      e.preventDefault();
    }
  });

  $('.tasks-list').on('dblclick', '.task-content-show', function(e) {
    var taskId = e.currentTarget.id.match(/\d+$/);
    window.location = '/tasks/' + taskId + '/edit';
  });

  var taskEditInput = $(".task-edit-form input[type='text']");
  taskEditInput.focus().val(taskEditInput.val());

  taskEditInput.blur(function() {
    console.log('blur');
    $(".task-edit-form").submit();
  });
});
