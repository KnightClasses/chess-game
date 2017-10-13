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
        $.ajax({
          type: 'PATCH',
          url: ui.draggable.data('update-url'),
          dataType: 'json',
          data: { 
            piece: piece
          },
          success: function(){

            if ( ( y == 1 || y == 8 ) && ( type == "Pawn" ) ) {
              var dfd = $.Deferred();
              dfd

              .done(function() {
                location.reload(true);
              });
              var chessPieces = ['Queen', 'Bishop', 'Knight', 'Rook']
              $.each(chessPieces, function(i, val) {
                var button='<button type="button" class="btn btn-primary" id="'+ this + '">'+ this +'</button>';
                $("#pawnPromote").append(button);
              });
              $.each(chessPieces, function(i, val) {
                var pieceName = this;
                $( "#" + this ).click(function() {
                  $.ajax({
                    type: 'PATCH',
                    url: ui.draggable.data('update-url') + "/promote_pawn",
                    dataType: 'json',
                    data: {
                      piece: {
                        type: pieceName
                      }
                    }
                  });
                  dfd.resolve();
                  App.room.speak();
                });
              });
            } else {
                App.room.speak();
                location.reload(true);
                $(".alert alert-info").html("<%= flash[:notice] %>");
            }
          },
        });

      }
    });
  });
});
