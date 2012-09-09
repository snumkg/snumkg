$(function(){
  $('.board').click(function(){
    $('.selected-board').removeClass('selected-board');
    var ele = $(this);
    ele.parent().addClass('selected-board');
    var board_id = ele.attr('board_id');
    $.ajax({
      url: edit_admin_board_path(board_id),
      success: function(html){
        $('#board_content').html(html);
      }
    });
    return false;
  });

  //board 들의 순서 결정
  $('[board_id]').each(function(i){
    var board_id = $(this).attr('board_id');
  });

  //게시판 위로
  $('#board_up_button').click(function(){
    var selected_li = $('.selected-board');
    var board_id = selected_li.find('[board_id]').attr('board_id');
    if (board_id && selected_li.prev().size() > 0){
      selected_li.prev().before(selected_li);
      send_board_orders();
    }
    return false;
  });
  //게시판 아래로
  $('#board_down_button').click(function(){
    var selected_li = $('.selected-board');
    var board_id = selected_li.find('[board_id]').attr('board_id');
    if (board_id && selected_li.next().size() > 0){
      selected_li.next().after(selected_li);
      send_board_orders();
    }
    return false;
  });
});

function edit_admin_board_path(board_id)
{
  return "/admin/boards/" + board_id + "/edit";
}

function send_board_orders()
{
  var board_orders = [];
  $('[board_id]').each(function(i){
    var board_id = $(this).attr('board_id');
    board_orders.push(board_id);
  });
  $.ajax({
    url: "/admin/groups/"+1+"/set_board_orders",
    type: "POST",
    data: {
      board_orders: board_orders
    }
  });
}
