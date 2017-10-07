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
        var type = ui.draggable.data("type");
        var color = ui.draggable.data("color");
        var piece = {
          x: x,
          y: y,
          type: type,
          color: color
        }
        console.log(x);
        console.log(y);
        console.log(type);
        console.log(color);

        $.ajax({
          type: 'PATCH',
          url: ui.draggable.data('update-url'),
          dataType: 'json',
          data: { 
            piece: piece
          },
          success: function(){
            if ( ( y == 1 || y == 8 ) && ( type == "Pawn" ) ) {
              var chessPieces = ['Queen', 'Bishop', 'Knight', 'Pawn', 'Rook']
              $.each(chessPieces, function(i, val) {
                var button='<button type="button" class="btn btn-primary">'+ this +'</button>';
                $("#pawnPromote").append(button);
              });
            };
            location.reload(true);
            $(".alert alert-info").html("<%= flash[:notice] %>");
          },
        });
      }
    });
  });
});
