$(document).ready(function () {
  
  $( ".white" ).addClass( "droppable" );
  $( ".grey" ).addClass( "droppable" );
  $(function() {
    $('.pieces').draggable({
      snap: true, snapMode: "outer", containment: $('.board')
    });
    $( ".droppable" ).droppable({
      classes: {
        "ui-droppable-hover": "highlight"
      },
      drop: function( event, ui ) { 
        var $this = $(this);
        ui.draggable.position({
          my: "center",
          at: "center",
          of: $this,
          using: function( pos ) {
            $(this).animate(pos, 200, "linear");
          }
        });
        var x = $(event.target).data("x");
        var y = $(event.target).data("y");
        var piece = {
          x: x,
          y: y
        }
        $.ajax({
          type: 'PATCH',
          url: ui.draggable.parent().data('update-url'),
          dataType: 'json',
          data: { 
            piece: piece
          },
          success: function(){
            location.reload();
            $(".alert alert-info").html("<%= flash[:notice] %>");
          },
        });
      }
    });
  });

});