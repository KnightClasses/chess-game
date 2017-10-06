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
        var type = $(event.target).data("type");
        var color = $(event.target).data("color");
        var piece = {
          x: x,
          y: y,
          type: type,
          color: color
        }
        if (( type == "pawn" && y == 1 ) || ( type == "pawn" && y == 8 )) {
          alert("promote pawn?");
          // 1. Create the button
          var button = document.createElement("button");
          button.innerHTML = "Do Something";

          // 2. Append somewhere
          var body = document.getElementsByClassName("black messages")[0];
          body.appendChild(button);

          // 3. Add event handler
          button.addEventListener ("click", function() {
            alert("did something");
          });
        }

        $.ajax({
          type: 'PATCH',
          url: ui.draggable.data('update-url'),
          dataType: 'json',
          data: { 
            piece: piece
          },
          success: function(){
            location.reload(true);
            $(".alert alert-info").html("<%= flash[:notice] %>");
          },
        });
      }
    });
  });
});
